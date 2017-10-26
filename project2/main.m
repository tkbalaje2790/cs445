%clear

im1 = im2single(imread('./samples/pattern2.jpg'));

sample = im2single(imread('./samples/northface.jpg'));
target = im2single(imread('./samples/feynman.tiff'));

%random quilting
%quilt_random_img = quilt_random(im1, 480, 48);
%imwrite(quilt_random_img,'./deliverables/random_quilt8.png');

%overlap quilting
tol = 0.1;
%quilt_simple_img = quilt_simple(im1, 480, 11,5,tol);
%imwrite(quilt_simple_img,'./deliverables/overlap_quilt8.png');

%cut quilting
tol = 0.05;
quilt_cut_img = quilt_cut(im1, 480, 25,7,tol);
imwrite(quilt_cut_img,'./deliverables/cheater.png');

%figure(1)
%subplot(1,3,1)
%imagesc(quilt_random_img), axis image
%title('Random Quilting')
%subplot(1,3,2)
%imagesc(quilt_simple_img), axis image
%title('Overlap Quilting')
%subplot(1,3,3)
imagesc(quilt_cut_img), axis image
title('Cut Quilting');


%texture transfer
%close all
tol = 0.1;
alpha = 0.5;
%texture_transfer_img = texture_transfer(sample, target, 21, 9, tol, alpha)
%figure(4), imagesc(texture_transfer_img), colormap default, axis image
%imwrite(texture_transfer_img,'./deliverables/red_feynman.png');


