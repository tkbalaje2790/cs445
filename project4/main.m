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

%ldr1 = im2uint8(imread('./samples/new/2.jpg'));
%ldr2 = im2uint8(imread('./samples/new/4.jpg'));
%ldr3 = im2uint8(imread('./samples/new/8.jpg'));
%ldr4 = im2uint8(imread('./samples/new/15.jpg'));
%ldr5 = im2uint8(imread('./samples/new/30.jpg'));
%exps = [2 4 8 15 30];

% ldr1 = im2uint8(imread('./samples/angle1/1:30.jpg'));
% ldr2 = im2uint8(imread('./samples/angle1/1:15.jpg'));
% ldr3 = im2uint8(imread('./samples/angle1/1:8.jpg'));
% ldr4 = im2uint8(imread('./samples/angle1/1:4.jpg'));
% ldr5 = im2uint8(imread('./samples/angle1/1:2.jpg'));
% 
% exps = [1/30 1/15 1/8 1/4 1/2];

ldr1 = im2uint8(imread('./samples/angle2/1:20.jpg'));
ldr2 = im2uint8(imread('./samples/angle2/1:10.jpg'));
ldr3 = im2uint8(imread('./samples/angle2/1:5.jpg'));
ldr4 = im2uint8(imread('./samples/angle2/0.4.jpg'));
ldr5 = im2uint8(imread('./samples/angle2/0.8.jpg'));

exps = [1/20 1/10 1/5 0.4 0.8];

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

%% Irradiance scaling

irr1 = irradiance(ldr1, exps(1));
irr2 = irradiance(ldr2, exps(2));
irr3 = irradiance(ldr3, exps(3));
irr4 = irradiance(ldr4, exps(4));
irr5 = irradiance(ldr5, exps(5));

irr6 = irradiance(naive_hdr,1);
irr7 = irradiance(selective_hdr,1);
irr8 = irradiance(gsolve_hdr, 1);

irrs = cat(4,irr1,irr2,irr3,irr4,irr5);

%filter out -inf values from log(0)g
irr1_filtered = irr1 .* ~isinf(irr1);
irr2_filtered = irr2 .* ~isinf(irr2);
irr3_filtered = irr3 .* ~isinf(irr3);
irr4_filtered = irr4 .* ~isinf(irr4);
irr5_filtered = irr5 .* ~isinf(irr5);

min1 = min(irr1_filtered(:));
min2 = min(irr2_filtered(:));
min3 = min(irr3_filtered(:));
min4 = min(irr4_filtered(:));
min5 = min(irr5_filtered(:));

max1 = max(irr1(:));
max2 = max(irr2(:));
max3 = max(irr3(:));
max4 = max(irr4(:));
max5 = max(irr5(:));

%overall min/max across all exposures
min_val = min([min1 min2 min3 min4 min5]);
max_val = max([max1 max2 max3 max4 max5]);

irr1 = scale_irradiance(irr1,min_val,max_val);
irr2 = scale_irradiance(irr2,min_val,max_val);
irr3 = scale_irradiance(irr3,min_val,max_val);
irr4 = scale_irradiance(irr4,min_val,max_val);
irr5 = scale_irradiance(irr5,min_val,max_val);
imwrite(irr1, './results/irr1.jpg');
imwrite(irr2, './results/irr2.jpg');
imwrite(irr3, './results/irr3.jpg');
imwrite(irr4, './results/irr4.jpg');
imwrite(irr5, './results/irr5.jpg');

naive_irr = scale_irradiance(irr6,min_val,max_val);
imwrite(naive_irr, './results/naive_irr.jpg');
selective_irr = scale_irradiance(irr7,min_val,max_val);
imwrite(selective_irr, './results/selective_irr.jpg');
gsolve_irr = scale_irradiance(irr8,min_val,max_val);
imwrite(gsolve_irr, './results/gsolve_irr.jpg');

figure(1)
subplot(1,5,1), imagesc(irr1), axis image, colormap jet
subplot(1,5,2), imagesc(irr2), axis image, colormap jet
subplot(1,5,3), imagesc(irr3), axis image, colormap jet
subplot(1,5,4), imagesc(irr4), axis image, colormap jet
subplot(1,5,5), imagesc(irr5), axis image, colormap jet

figure(2)
subplot(1,3,1), imagesc(naive_irr), axis image, colormap jet
subplot(1,3,2), imagesc(selective_irr), axis image, colormap jet
subplot(1,3,3), imagesc(gsolve_irr), axis image, colormap jet


equirectangular = mirrorball2latlon(gsolve_hdr);
equirectangular(equirectangular< 0) = 0;
figure(3),imagesc(equirectangular), axis image, colormap default
hdrwrite(equirectangular, './results/equirectangular.hdr');
imwrite(tonemap(equirectangular), './results/equirectangular.jpg');

cubemap = mirrorball2cubemap(gsolve_hdr);
cubemap(~isfinite(cubemap)) = 1;
figure(4),imagesc(cubemap), axis image, colormap default
hdrwrite(cubemap, './results/cubemap.hdr');
imwrite(tonemap(cubemap), './results/cubemap.jpg');

% cubemap = latlon2cubemap();
% figure(4),imagesc(cubemap), axis image, colormap default
% imwrite(cubemap, './results/cubemap.jpg');

angular = mirrorball2angular(gsolve_hdr);
figure(4),imagesc(angular), axis image, colormap default
hdrwrite(angular, './results/angular.hdr');
imwrite(tonemap(angular), './results/angular.jpg');

