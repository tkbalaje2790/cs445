function [im_out] = color2gray(s)

[imh, imw, ~] = size(s);

im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw;

M = 2*imh*imw + 1;
N = imh*imw;

A = sparse([], [], [], M, N, 2*M);
b = zeros(M,1);

im_gray = rgb2gray(s);

% init
e = 1;
A(e, im2var(1,1))= 1; 
b(e) = im_gray(1,1);

tic;
for y = 1:(imh-1)
   for x = 1:(imw-1)
       %Y-direction
       grad1 = s(y,x,1) - s(y+1,x,1);
       grad2 = s(y,x,2) - s(y+1,x,2);
       grad3 = s(y,x,3) - s(y+1,x,3);
       
       e = e+1;
       A(e, im2var(y,x)) = 1;
       A(e, im2var(y+1,x)) = -1;
       if(abs(grad1) > abs(grad2) && abs(grad1) > abs(grad3))
           b(e) = grad1;
       elseif(abs(grad2) > abs(grad1) && abs(grad2) > abs(grad3))
           b(e) = grad2;
       else
           b(e) = grad3;
       end
       
       %X-direction
       grad1 = s(y,x,1) - s(y,x+1,1);
       grad2 = s(y,x,2) - s(y,x+1,2);
       grad3 = s(y,x,3) - s(y,x+1,3);
       
       e = e+1;
       A(e, im2var(y,x)) = 1;
       A(e, im2var(y,x+1)) = -1;
       if(abs(grad1) > abs(grad2) && abs(grad1) > abs(grad3))
           b(e) = grad1;
       elseif(abs(grad2) > abs(grad1) && abs(grad2) > abs(grad3))
           b(e) = grad2;
       else
           b(e) = grad3;
       end
       
   end
end

%unused equations
A = A(1:e,:);
b = b(1:e);

v = A\b;
im_out = reshape(v, imh, imw);

toc;