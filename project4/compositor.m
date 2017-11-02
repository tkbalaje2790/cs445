
R = im2uint8(imread('./rendered.jpg'));
E = im2uint8(imread('./plane.jpg'));
M = im2uint8(imread('./mask.jpg'));
M = M/255;
I = im2uint8(imread('./samples/new/background.resized.jpg'));
I = I(1:364, :, :);

c = 1;
composite = M.*R + (1-M).*I + (1-M).*(R-E).*c;
figure(1),imagesc(composite), axis image, colormap default