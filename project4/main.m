ldr1 = im2uint8(imread('./samples/1:50.jpg'));
ldr2 = im2uint8(imread('./samples/1:10.jpg'));
ldr3 = im2uint8(imread('./samples/10.jpg'));

exposures = [1/50 1/10 10];

ldr1_scaled = double(ldr1)/exposures(1);
ldr2_scaled = double(ldr2)/exposures(2);
ldr3_scaled = double(ldr3)/exposures(3);

ldrs = cat(4,ldr1_scaled,ldr2_scaled,ldr3_scaled);

naive_hdr = makehdr_naive(ldrs,exposures);


figure(1)
subplot(1,3,1), imagesc(ldr1), axis image, colormap default
subplot(1,3,2), imagesc(ldr2), axis image, colormap default
subplot(1,3,3), imagesc(ldr3), axis image, colormap default
figure(2),imagesc(naive_hdr), axis image, colormap default

