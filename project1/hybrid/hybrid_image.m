function img = hybrid_image(im1, im2, cutoff_low, cutoff_high)


%cutoff_low is the cutoff for the low-pass filter
%cutoff_high is the cutoff for the high-pass filter
sigma1 = 1/(2*pi*cutoff_low)
h1 = fspecial('gaussian', 6*round(sigma1)+1, sigma1)
im1f = filter2(h1, im1)

sigma2 = 1/(2*pi*(cutoff_high))
h2 = fspecial('gaussian', 6*round(sigma2)+1, sigma2)
im2f = im2 - filter2(h1, im2)

img = (im1f+im2f)/2





