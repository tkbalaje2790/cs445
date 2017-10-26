%function img = histogram_equalization(im, alpha)

im1 = im2uint8(imread('./blurry_sky.jpg'));
%[h,s,v] = rgb2gray(im1); % convert to grayscale
im1 = rgb2gray(im1);

[y0,x0,z0] = size(im1);

%v = v*255

histogram = zeros(256,1);
cdf = zeros(256, 1);
im2 = zeros(y0,x0);

for i = 1:256
    for y = 1:y0
        for x = 1:x0
            if(im1(y,x) == i)
                histogram(i) = histogram(i)+1;
                if(i > 1)
                    cdf(i) = cdf(i-1) + histogram(i);
                end
            end
        end
    end
end

alpha = 0.65;

for y = 1:y0
    for x = 1:x0
        intensity = im1(y,x);
        im2(y,x) = (alpha*(cdf(intensity+1)/(x0*y0))*255) + ((1-alpha)*intensity);
    end
end

%v = single(v / 255);

%im2(:,:,1) = h;
%im2(:,:,2) = s;
%im2(:,:,3) = v;

%figure(1), image(hsv2rgb(im1)), axis image
%figure(2), image(hsv2rgb(im2)), axis image

figure(1), hold off, imagesc(im1), axis off, colormap gray
figure(2), hold off, imagesc(im2), axis off, colormap gray





        
