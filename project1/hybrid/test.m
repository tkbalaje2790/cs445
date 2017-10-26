%import picture
im1 = im2single(imread('./drake.jpg'));
im1 = rgb2gray(im1); % convert to grayscale


%apply low pass filter
cutoff_high = (1/200);
sigma2 = 1/(2*pi*(cutoff_high))
h2 = fspecial('gaussian', 6*round(sigma2)+1, sigma2)
im2f = im1 - filter2(h2, im1)



imagesc(im2f), axis off, colormap gray




%figure(1), hold off, imagesc(im2f), axis image, colormap gray


