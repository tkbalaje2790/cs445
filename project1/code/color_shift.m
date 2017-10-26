im1 = im2uint8(imread('./ny.jpg'));
[l a b] = rgb2lab(im1);
im1 = rgb2lab(im1);

[y,x,z] = size(im1);

alpha = .065;

a_red = a + (127 - a)*alpha;
b_yellow = b + (127 - b)*alpha;

im2 = zeros(y,x);
im3 = zeros(y,x);

im2(:,:,1) = l;
im2(:,:,2) = a_red;
im2(:,:,3) = b;

im3(:,:,1) = l;
im3(:,:,2) = a;
im3(:,:,3) = b_yellow;


subplot(1,3,1);
image(lab2rgb(im1)), axis image
subplot(1,3,2);
image(lab2rgb(im2)), axis image
subplot(1,3,3);
image(lab2rgb(im3)), axis image