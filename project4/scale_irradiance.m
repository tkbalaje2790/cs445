function [ out ]  = scale_irradiance(irrs, hdr)

%add hdr
irrs = cat(4,irrs,hdr);

num_images = size(irrs,4);

mins = zeros(1,num_images);
maxs = zeros(1,num_images);

%remove -inf values
irrs = irrs .* ~isinf(irrs);
hdr = hdr .* ~isinf(hdr);

for i = 1:num_images
    irr = irrs(:,:,:,i);
    mins(i) = min(irr(:));
    maxs(i) = max(irr(:));
end

global_min = min(mins);
global_max = max(maxs);

out = (hdr - global_min)/(global_max - global_min);


