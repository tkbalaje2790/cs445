function [im_blend] = poissonBlend(im_object, im_mask, im_background)

[imh, imw, ~] = size(im_object);

s = im_object;
t = im_background;

%find boundaries of S to save iteration
[ys,xs] = find(im_mask);
a = min(ys):max(ys);
b = min(xs):max(xs);

im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw;

%M is the maximum number of equations
M = 4*size(a,2)*size(b,2);
N = imh*imw;

im_blend = zeros(imh,imw,3);

tic;
for channel = 1:3
    A = sparse([], [], [], M, N, 4*M);
    b = zeros(M,1);
    e = 0;
    for y = min(ys):max(ys)
       for x = min(xs):max(xs)
           %inside S 
           if(im_mask(y,x))
                %down gradient
                e = e+1;
                A(e,im2var(y,x)) = 1;                                             
                if(im_mask(y+1,x))
                    A(e, im2var(y+1,x)) = -1;
                    b(e) = s(y,x,channel) - s(y+1,x,channel);
                else
                    b(e) = s(y,x,channel) - s(y+1,x,channel) + t(y+1,x,channel);
                end
                
                %right gradient
                e = e+1;
                A(e,im2var(y,x)) = 1; 
                if(im_mask(y,x+1))
                    A(e, im2var(y,x+1)) = -1;
                    b(e) = s(y,x,channel) - s(y,x+1,channel);
                else
                    b(e) = s(y,x,channel) - s(y,x+1,channel) + t(y,x+1,channel);
                end
                
                %up gradient
                e = e+1;
                A(e,im2var(y,x)) = 1; 
                if(im_mask(y-1,x)) 
                    A(e, im2var(y-1,x)) = -1;
                    b(e) = s(y,x,channel) - s(y-1,x,channel);
                else
                    b(e) = s(y,x,channel) - s(y-1,x,channel) + t(y-1,x,channel);
                end
                
                %left gradient
                e = e+1;
                A(e,im2var(y,x)) = 1; 
                if(im_mask(y,x-1)) 
                    A(e, im2var(y,x-1)) = -1;
                    b(e) = s(y,x,channel) - s(y,x-1,channel);
                else
                    b(e) = s(y,x,channel) - s(y,x-1,channel) + t(y,x-1,channel);
                end
            end
       end
    end
    
    %unused equations
    A = A(1:e,:);
    b = b(1:e);
    
    v = A\b;
    v = reshape(v, imh, imw);
    im_blend(:,:,channel) = v + ~im_mask.*t(:,:,channel);
end
toc;