
im1 = im2uint8(imread('./expansive.jpg'));
[h,s,v] = rgb2hsv(im1);
im1 = rgb2hsv(im1);
[y,x,z] = size(im1);

im2 = im1;

s = nthroot(s, 1.3);

[y1,x1,z1] = size(s);

im2(:,:,1) = h;
im2(:,:,2) = s;
im2(:,:,3) = v;

figure(1), image(hsv2rgb(im1)), axis off
figure(2), image(hsv2rgb(im2)), axis off








