clear;
close all;
colormap(parula);

ldr1 = im2uint8(imread('./samples/1:50.jpg'));
ldr2 = im2uint8(imread('./samples/1:10.jpg'));
ldr3 = im2uint8(imread('./samples/10.jpg'));

exps = [1/50 1/10 10];

%% LDR Merging 

ldrs = cat(4, ldr1, ldr2, ldr3);

naive_hdr = makehdr_naive(ldrs,exps);
selective_hdr = makehdr_selective(ldrs, exps);

%% Irridiance Calculations

irr1 = irradiance(ldr1, 1/50);
irr2 = irradiance(ldr2, 1/10);
irr3 = irradiance(ldr3, 10);
irr4 = irradiance(naive_hdr,1);
irr5 = irradiance(selective_hdr,1);

%filter out inf values from log(0)
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

%scale
[y,x,z] = size(irr1);

for r = 1:y
    for c = 1:x
        for d = 1:z
            irr1(r,c,d) = (irr1(r,c,d) - min_val) / (max_val-min_val);
            irr2(r,c,d) = (irr2(r,c,d) - min_val) / (max_val-min_val);
            irr3(r,c,d) = (irr3(r,c,d) - min_val) / (max_val-min_val);
            irr4(r,c,d) = (irr4(r,c,d) - min_val) / (max_val-min_val);
            irr5(r,c,d) = (irr5(r,c,d) - min_val) / (max_val-min_val);
        end
    end 
end

%figure(1)
%subplot(1,5,1), imagesc(irr1), axis image, colormap default
%subplot(1,5,2), imagesc(irr2), axis image, colormap default
%subplot(1,5,3), imagesc(irr3), axis image, colormap default
%subplot(1,5,4), imagesc(irr4), axis image, colormap default
%subplot(1,5,5), imagesc(irr5), axis image, colormap default


%% Response function estimation

hdr_gsolve = makehdr_gsolve(ldrs,exps);
figure(1), imagesc(hdr_gsolve), axis image, colormap default;

%% Graphing

%figure(1)
%subplot(1,5,1), imagesc(ldr1), axis image, colormap default
%subplot(1,5,2), imagesc(ldr2), axis image, colormap default
%subplot(1,5,3), imagesc(ldr3), axis image, colormap default
%subplot(1,5,4), imagesc(ldr4), axis image, colormap default
%subplot(1,5,5), imagesc(ldr5), axis image, colormap default

%figure(2),imagesc(naive_hdr), axis image, colormap default
%figure(3),imagesc(selective_hdr), axis image, colormap default

% equirectangular = mirrorball2latlon(naive_hdr);
% figure(3),imagesc(equirectangular), axis image, colormap default
% imwrite(equirectangular, './results/equirectangular.jpg');

%cubemap = mirrorball2cubemap(naive_hdr);
%figure(4),imagesc(cubemap), axis image, colormap default
%imwrite(cubemap, './results/cubemap.jpg');

% cubemap = latlon2cubemap();
% figure(4),imagesc(cubemap), axis image, colormap default
% imwrite(cubemap, './results/cubemap.jpg');



