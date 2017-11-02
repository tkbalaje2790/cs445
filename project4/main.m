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

% ldr1 = im2uint8(imread('./samples/new/2.jpg'));
% ldr2 = im2uint8(imread('./samples/new/4.jpg'));
% ldr3 = im2uint8(imread('./samples/new/8.jpg'));
% ldr4 = im2uint8(imread('./samples/new/15.jpg'));
% ldr5 = im2uint8(imread('./samples/new/30.jpg'));

ldr1 = im2uint8(imread('./samples/angle1/1:30.jpg'));
ldr2 = im2uint8(imread('./samples/angle1/1:15.jpg'));
ldr3 = im2uint8(imread('./samples/angle1/1:8.jpg'));
ldr4 = im2uint8(imread('./samples/angle1/1:4.jpg'));
ldr5 = im2uint8(imread('./samples/angle1/1:2.jpg'));

exps = [1/30 1/15 1/8 1/4 1/2];

ldrs = cat(4, ldr1, ldr2, ldr3, ldr4, ldr5);

%% LDR Merging 

naive_hdr = makehdr_naive(ldrs,exps);
naive_hdr = double(naive_hdr);
selective_hdr = makehdr_selective(ldrs, exps);
selective_hdr = double(selective_hdr);
[gsolve_hdr_scaled, gsolve_hdr] = makehdr_gsolve(ldrs,exps);
gsolve_hdr_scaled = double(gsolve_hdr_scaled);

figure(1),imagesc(naive_hdr), axis image, colormap default
hdrwrite(naive_hdr, './results/naive_hdr.hdr');
figure(2),imagesc(selective_hdr), axis image, colormap default
hdrwrite(selective_hdr, './results/selective_hdr.hdr');
figure(3),imagesc(gsolve_hdr_scaled), axis image, colormap default
hdrwrite(gsolve_hdr_scaled, './results/gsolve_hdr.hdr');

%% Irridiance Calculations

irr1 = irradiance(ldr1, exps(1));
irr2 = irradiance(ldr2, exps(2));
irr3 = irradiance(ldr3, exps(3));
irr4 = irradiance(ldr4, exps(4));
irr5 = irradiance(ldr5, exps(5));

irr6 = irradiance(naive_hdr,1);
irr7 = irradiance(selective_hdr,1);
irr8 = irradiance(gsolve_hdr, 1);

irrs = cat(4,irr1,irr2,irr3,irr4,irr5);

naive_irr = scale_irradiance(irrs,irr6);
selective_irr = scale_irradiance(irrs,irr7);
gsolve_irr = scale_irradiance(irrs,irr8);

% %filter out -inf values from log(0)g
% irr1_filtered = irr1 .* ~isinf(irr1);
% irr2_filtered = irr2 .* ~isinf(irr2);
% irr3_filtered = irr3 .* ~isinf(irr3);
% irr4_filtered = irr4 .* ~isinf(irr4);
% irr5_filtered = irr5 .* ~isinf(irr5);
% irr6_filtered = irr6 .* ~isinf(irr6);
% irr7_filtered = irr7 .* ~isinf(irr7);
% irr8_filtered = irr8 .* ~isinf(irr8);
% 
% min1 = min(irr1_filtered(:));
% min2 = min(irr2_filtered(:));
% min3 = min(irr3_filtered(:));
% min4 = min(irr4_filtered(:));
% min5 = min(irr5_filtered(:));
% min6 = min(irr6_filtered(:));
% min7 = min(irr7_filtered(:));
% min8 = min(irr8_filtered(:));
% 
% max1 = max(irr1(:));
% max2 = max(irr2(:));
% max3 = max(irr3(:));
% max4 = max(irr4(:));
% max5 = max(irr5(:));
% max6 = max(irr6(:));
% max7 = max(irr7(:));
% max8 = max(irr8(:));
% 
% %overall min/max across all exposures
% min_val = min([min1 min2 min3 min4 min5 min6 min7 min8]);
% max_val = max([max1 max2 max3 max4 max5 max6 max7 max8]);
% 
% %scale
% [y,x,z] = size(irr1);
% 
% for r = 1:y
%     for c = 1:x
%         for d = 1:z
%             irr1(r,c,d) = (irr1(r,c,d) - min_val) / (max_val-min_val);
%             irr2(r,c,d) = (irr2(r,c,d) - min_val) / (max_val-min_val);
%             irr3(r,c,d) = (irr3(r,c,d) - min_val) / (max_val-min_val);
%             irr4(r,c,d) = (irr4(r,c,d) - min_val) / (max_val-min_val);
%             irr5(r,c,d) = (irr5(r,c,d) - min_val) / (max_val-min_val);
%             irr6(r,c,d) = (irr6(r,c,d) - min_val) / (max_val-min_val);
%             irr7(r,c,d) = (irr7(r,c,d) - min_val) / (max_val-min_val);
%             irr8(r,c,d) = (irr8(r,c,d) - min_val) / (max_val-min_val);
%         end
%     end 
% end

figure(1)
subplot(1,5,1), imagesc(irr1), axis image, colormap jet
subplot(1,5,2), imagesc(irr2), axis image, colormap jet
subplot(1,5,3), imagesc(irr3), axis image, colormap jet
subplot(1,5,4), imagesc(irr4), axis image, colormap jet
subplot(1,5,5), imagesc(irr5), axis image, colormap jet

figure(100)
subplot(1,3,1), imagesc(naive_irr), axis image, colormap jet
subplot(1,3,2), imagesc(selective_irr), axis image, colormap jet
subplot(1,3,3), imagesc(gsolve_irr), axis image, colormap jet




%% Graphing

%figure(1)
%subplot(1,5,1), imagesc(ldr1), axis image, colormap default
%subplot(1,5,2), imagesc(ldr2), axis image, colormap default
%subplot(1,5,3), imagesc(ldr3), axis image, colormap default
%subplot(1,5,4), imagesc(ldr4), axis image, colormap default
%subplot(1,5,5), imagesc(ldr5), axis image, colormap default

%figure(2),imagesc(naive_hdr), axis image, colormap default
%figure(3),imagesc(selective_hdr), axis image, colormap default

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

