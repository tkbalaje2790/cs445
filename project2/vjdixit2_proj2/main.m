clear

im1 = im2single(imread('./samples/bricks.jpg'));

sample = im2single(imread('./samples/sketch.tiff'));
target = im2single(imread('./samples/feynman.tiff'));

%random quilting
%quilt_random_img = quilt_random(im1, 480, 48);
%figure(1),imagesc(quilt_random_img), axis image
%title('Random Quilting')
%imwrite(quilt_random_img,'./deliverables/random_quilt5.png');

%overlap quilting
tol = 0.01;
%quilt_simple_img = quilt_simple(im1, 480, 21,5,tol);
%figure(2),imagesc(quilt_simple_img), axis image
%title('Overlap Quilting')
%imwrite(quilt_simple_img,'./deliverables/overlap_quilt5.png');

%cut quilting
tol = 0.01;
quilt_cut_img = quilt_cut(im1, 400, 21,5,tol);
figure(3),imagesc(quilt_cut_img), axis image
%title('Cut Quilting');
%imwrite(quilt_cut_img,'./deliverables/cut_quilt5.png');

%texture transfer
tol = 0.1;
alpha = 0.8;
%texture_transfer_img = texture_transfer(sample, target, 11, 5, tol, alpha)
%figure(4), imagesc(texture_transfer_img), colormap default, axis image
%imwrite(texture_transfer_img,'./deliverables/feynman_transfer.png');


