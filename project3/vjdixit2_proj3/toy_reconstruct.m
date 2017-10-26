function [img] = toy_reconstruct(s)

[imh,imw] = size(s);

im2var = zeros(imh, imw); 
im2var(1:imh*imw) = 1:imh*imw;

M = 2*imh*imw + 1;
N = imh*imw;

A = sparse([], [], [], M, N, 2*M);
b = zeros(M,1);

% init
e = 1;
A(e, im2var(1,1))= 1; 
b(e) = s(1,1); 

for y = 1:(imh)
   for x = 1:(imw)
       % constraint 1
       if(x~=imw)
           e = e + 1;
           A(e, im2var(y,x+1)) = 1; 
           A(e, im2var(y,x)) = -1; 
           b(e) = s(y,x+1)-s(y,x);
       else
           e = e + 1;
           %A(e, im2var(y,x+1)) = 1; 
           A(e, im2var(y,x)) = -1; 
           b(e) = -s(y,x);
       end
       
       % constraint 2
       if(y~=imh)
           e = e + 1;
           A(e, im2var(y+1,x))= 1; 
           A(e, im2var(y,x))= -1; 
           b(e) = s(y+1,x)-s(y,x);
       else
           e = e + 1;
           %A(e, im2var(y+1,x))= 1; 
           A(e, im2var(y,x))= -1; 
           b(e) = -s(y,x);
       end
   end
end

% fix corner
%A(e, im2var(imh,imw))= 1; 
%%e = e+1;
%A(e, im2var(imh,imw))= 1; 
%b(e) = s(imh,imw);

v = A\b;
img = reshape(v, imh, imw);
figure(1), imagesc(s), colormap gray, axis image
figure(2), imagesc(img), colormap gray, axis image



