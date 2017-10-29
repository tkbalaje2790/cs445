close all;
colormap(parula);

ldr1 = im2uint8(imread('./samples/1:50.jpg'));
ldr2 = im2uint8(imread('./samples/1:10.jpg'));
ldr3 = im2uint8(imread('./samples/10.jpg'));

exposure1 = 1/50;
exposure2 = 1/10;
exposure3 = 10;

naive_hdr = makehdr_naive(ldr1, ldr2, ldr3, exposure1, exposure2, exposure3);

% selective_hdr = makehdr_selective(ldr1, ldr2, ldr3, exposure1, exposure2, exposure3);


figure(1)
subplot(1,3,1), imagesc(ldr1), axis image, colormap default
subplot(1,3,2), imagesc(ldr2), axis image, colormap default
subplot(1,3,3), imagesc(ldr3), axis image, colormap default

figure(2),imagesc(naive_hdr), axis image, colormap default
% figure(3),imagesc(selective_hdr), axis image, colormap cdefault

% equirectangular = mirrorball2latlon(naive_hdr);
% figure(3),imagesc(equirectangular), axis image, colormap default
% imwrite(equirectangular, './results/equirectangular.jpg');

cubemap = mirrorball2cubemap(naive_hdr);
figure(4),imagesc(cubemap), axis image, colormap default
imwrite(cubemap, './results/cubemap.jpg');

% cubemap = latlon2cubemap();
% figure(4),imagesc(cubemap), axis image, colormap default
% imwrite(cubemap, './results/cubemap.jpg');

