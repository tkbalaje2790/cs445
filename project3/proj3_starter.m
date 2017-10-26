% starter script for project 3
DO_TOY = false;
DO_BLEND = false;
DO_MIXED  = false;
DO_COLOR2GRAY = false;
DO_FLATTEN = true;

if DO_TOY 
    toyim = im2double(imread('./samples/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toy_reconstruct(toyim);
    disp(['Error: ' num2str(sqrt(sum((toyim(:)-im_out(:)).^2)))])
    
    % create comparison image
    fig = figure(1);
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    
    subplot(1,2,1), imagesc(toyim), axis image, colormap gray, title('Original'), set(gca,tickCell{:});
    subplot(1,2,2), imagesc(im_out), axis image, colormap gray, title('Reconstructed'), set(gca,tickCell{:});
    
    saveas(gcf,'./deliverables/toy.jpg');
end

if DO_BLEND
    % do a small one first, while debugging
    im_background = imresize(im2double(imread('./samples/co3.jpg')), 0.30, 'bilinear');
    im_object = imresize(im2double(imread('./samples/airplane.jpg')), 0.10, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s, im_t] = alignSource(im_object, objmask, im_background);

    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend)
    
    % saving results
    imwrite(im_t,'./deliverables/poisson5_pasted.jpg');
    imwrite(im_blend, './deliverables/poisson5_blend.jpg');
end

if DO_MIXED
    % read images
    %...
    im_background = imresize(im2double(imread('./samples/black_texture.jpg')), 0.20, 'bilinear');
    im_object = imresize(im2double(imread('./samples/grafiti.jpg')), 0.50, 'bilinear');
    
    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s, im_t] = alignSource(im_object, objmask, im_background);
    
    % blend
    im_mixed = mixedBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_mixed);
    
    %saving results
    imwrite(im_t,'./deliverables/mixed2_pasted.jpg');
    imwrite(im_mixed, './deliverables/mixed2_blend.jpg');
end

if DO_COLOR2GRAY
    % also feel welcome to try this on some natural images and compare to rgb2gray
    im_rgb = im2double(imread('./samples/colorBlind8.png'));
    im_gr = color2gray(im_rgb);
    
    fig = figure(4), hold off;
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
     
    subplot(1,3,1), imagesc(im_rgb), axis image, colormap default, title('Original'), set(gca,tickCell{:});
    subplot(1,3,2), imagesc(rgb2gray(im_rgb)), axis image, colormap gray, title('rgb2gray'), set(gca,tickCell{:});
    subplot(1,3,3), imagesc(im_gr), axis image, colormap gray, title('color2gray'), set(gca,tickCell{:});

    saveas(gcf,'./deliverables/color2gray_2.jpg');
end

if DO_FLATTEN
    im_s = im2double(imread('./samples/nithin.jpg'));
    mask_s = edge(rgb2gray(im_s),'Canny');
    im_flat = flattenTexture(im_s, mask_s);
    
    fig = figure(1);
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    
    subplot(1,3,1), imagesc(im_s), axis image, colormap default, title('Original'), set(gca,tickCell{:});
    subplot(1,3,2), imagesc(mask_s), axis image, colormap gray, title('Edge Mask'), set(gca,tickCell{:});
    subplot(1,3,3), imagesc(im_flat), axis image, colormap default, title('Flattened'), set(gca,tickCell{:});
    
    saveas(fig, './deliverables/flatten2.jpg');
end
