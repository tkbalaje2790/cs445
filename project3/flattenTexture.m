function [im_out] = flattenTexture(s, mask)

[imh, imw, ~] = size(s);

im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw;

%M is the maximum number of equations
M = (2*imh*imw)+4;
N = imh*imw;

im_out = zeros(imh,imw,3);

tic;
for channel = 1:3
    A = sparse([], [], [], M, N, 4*M);
    b = zeros(M,1);
    
    %setting a few initial conditions
    e = 1;
    A(e,im2var(1,1)) = 1;
    b(e) = s(1,1,channel);
    
    e = e+1;
    A(e,im2var(imh,1)) = 1;
    b(e) = s(imh,1, channel);
    
    e = e+1;
    A(e,im2var(1,imw)) = 1;
    b(e) = s(1,imw, channel);
    
    e = e+1;
    A(e,im2var(imh,imw)) = 1;
    b(e) = s(imh,imw, channel);
    
    for y = 1:(imh-1)
       for x = 1:(imw-1)
           %inside edge region 
           if(mask(y,x))               
               
               e = e+1;
               A(e, im2var(y,x)) = 1;
               A(e, im2var(y+1,x)) = -1;
               b(e) = s(y,x,channel) - s(y+1,x,channel);
               
               e = e+1;
               A(e, im2var(y,x)) = 1;
               b(e) = s(y,x,channel);
               
               e = e+1;
               A(e, im2var(y,x)) = 1;
               A(e, im2var(y,x+1)) = -1;
               b(e) = s(y,x,channel) - s(y,x+1,channel);
               
           else
               e = e+1;
               A(e, im2var(y,x)) = 1;
               A(e, im2var(y+1,x)) = -1;
               b(e) = 0;
               
               %e = e+1;
               %A(e, im2var(y,x)) = 1;
               %b(e) = s(y,x,channel);
               
               e = e+1;
               A(e, im2var(y,x)) = 1;
               A(e, im2var(y,x+1)) = -1;
               b(e) = 0;
           end
       end
    end
    
    %unused equations
    A = A(1:e,:);
    b = b(1:e);
    
    v = A\b;
    v = reshape(v, imh, imw);
    im_out(:,:,channel) = v;
end
toc;