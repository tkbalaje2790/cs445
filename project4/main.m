clear;
close all;
colormap(parula);

% ldr1 = im2uint8(imread('./samples/table/1_80_ball.jpg'));
% ldr2 = im2uint8(imread('./samples/table/1_30_ball.jpg'));
% ldr3 = im2uint8(imread('./samples/table/1_13_ball.jpg'));
% ldr4 = im2uint8(imread('./samples/table/4_ball.jpg'));
% ldr5 = im2uint8(imread('./samples/table/8_ball.jpg'));
% exps = [1/80 1/30 1/13 4 8];
% 
% ldrs = cat(4, ldr1, ldr2, ldr3, ldr4, ldr5);

ldr1 = im2uint8(imread('./samples/new/2.jpg'));
ldr2 = im2uint8(imread('./samples/new/4.jpg'));
ldr3 = im2uint8(imread('./samples/new/8.jpg'));
ldr4 = im2uint8(imread('./samples/new/15.jpg'));
ldr5 = im2uint8(imread('./samples/new/30.jpg'));
exps = [2 4 8 15 30];

% ldr1 = im2uint8(imread('./samples/angle1/1:30.jpg'));
% ldr2 = im2uint8(imread('./samples/angle1/1:15.jpg'));
% ldr3 = im2uint8(imread('./samples/angle1/1:8.jpg'));
% ldr4 = im2uint8(imread('./samples/angle1/1:4.jpg'));
% ldr5 = im2uint8(imread('./samples/angle1/1:2.jpg'));

% exps = [1/30 1/15 1/8 1/4 1/2];

ldrs = cat(4, ldr1, ldr2, ldr3, ldr4, ldr5);

%% LDR Merging 

naive_hdr = makehdr_naive(ldrs,exps);
naive_hdr = double(naive_hdr);
selective_hdr = makehdr_selective(ldrs, exps);
selective_hdr = double(selective_hdr);
gsolve_hdr = makehdr_gsolve(ldrs,exps);
gsolve_hdr = double(gsolve_hdr);

figure(1),imagesc(naive_hdr), axis image, colormap default
hdrwrite(naive_hdr, './results/naive_hdr.hdr');
imwrite(tonemap(naive_hdr), './results/naive_hdr.jpg');
figure(2),imagesc(selective_hdr), axis image, colormap default
hdrwrite(selective_hdr, './results/selective_hdr.hdr');
imwrite(tonemap(selective_hdr), './results/selective_hdr.jpg');
figure(3),imagesc(gsolve_hdr), axis image, colormap default
hdrwrite(gsolve_hdr, './results/gsolve_hdr.hdr');
imwrite(tonemap(gsolve_hdr), './results/gsolve_hdr.jpg');


%% Projective transformations

% equirectangular = mirrorball2latlon(gsolve_hdr);
% equirectangular(equirectangular< 0) = 0;
% figure(3),imagesc(equirectangular), axis image, colormap default
% hdrwrite(equirectangular, './results/equirectangular.hdr');
% imwrite(tonemap(equirectangular), './results/equirectangular.jpg');

% cubemap = mirrorball2cubemap(gsolve_hdr);
% cubemap(~isfinite(cubemap)) = 1;
% figure(4),imagesc(cubemap), axis image, colormap default
% hdrwrite(cubemap, './results/cubemap.hdr');
% imwrite(tonemap(cubemap), './results/cubemap.jpg');

% cubemap = latlon2cubemap();
% figure(4),imagesc(cubemap), axis image, colormap default
% imwrite(cubemap, './results/cubemap.jpg');

% angular = mirrorball2angular(gsolve_hdr);
% figure(4),imagesc(angular), axis image, colormap default
% hdrwrite(angular, './results/angular.hdr');
% imwrite(tonemap(angular), './results/angular.jpg');

