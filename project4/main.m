close all;
colormap(parula);

%% LDR Merging 

ldr1 = im2uint8(imread('./samples/1:50.jpg'));
ldr2 = im2uint8(imread('./samples/1:10.jpg'));
ldr3 = im2uint8(imread('./samples/10.jpg'));

exps = [1/50 1/10 10];
ldrs = cat(4, ldr1, ldr2, ldr3);

naive_hdr = makehdr_naive(ldrs,exps);
selective_hdr = makehdr_selective(ldrs, exps);

%figure(1)
%subplot(1,5,1), imagesc(ldr1), axis image, colormap default
%subplot(1,5,2), imagesc(ldr2), axis image, colormap default
%subplot(1,5,3), imagesc(ldr3), axis image, colormap default
%subplot(1,5,4), imagesc(ldr4), axis image, colormap default
%subplot(1,5,5), imagesc(ldr5), axis image, colormap default

figure(2),imagesc(naive_hdr), axis image, colormap default
figure(3),imagesc(selective_hdr), axis image, colormap default

% equirectangular = mirrorball2latlon(naive_hdr);
% figure(3),imagesc(equirectangular), axis image, colormap default
% imwrite(equirectangular, './results/equirectangular.jpg');

%cubemap = mirrorball2cubemap(naive_hdr);
%figure(4),imagesc(cubemap), axis image, colormap default
%imwrite(cubemap, './results/cubemap.jpg');

% cubemap = latlon2cubemap();
% figure(4),imagesc(cubemap), axis image, colormap default
% imwrite(cubemap, './results/cubemap.jpg');

