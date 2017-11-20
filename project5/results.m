clear;

DO_PART1 = false;
DO_PART2 = true;

%% Part 1: Stitch two key frames

if(DO_PART1)
    
    reference_idx = 3;
    projection_idx = 2;

    %populate Ia and Ib
    try_correspondence;
    close all;
    
    threshold = 10;
    H = auto_homography(Ia,Ib,threshold);

    % close images from try_correspondance
    close all;

    % projecting 
    T = maketform('projective', H');
    imt = imtransform(Ia, T, 'XData',[-651 980],'YData',[-51 460]);

    % projecting the reference plane onto output surface
    T = maketform('projective', eye(3));
    imt2 = imtransform(Ib, T, 'XData', [-651 980],'YData',[-51 460]);

    % blending w/ naive method
    mask = (imt2 == 0);
    im_out = im2double(imt).*mask + im2double(imt2);
    figure(1), imagesc(im_out), axis image;
end

%% Part 2: Panorama using five key frames

if(DO_PART2)
    
    % master_frames = [90   270   450   630   810];
    
    % populate Ia and Ib for 270 -> 450
    projection_idx = 2;
    reference_idx = 3;
    try_correspondence;
    close all;

    % place reference frame first
    T = maketform('projective', eye(3));
    pano = imtransform(Ib, T, 'XData', [-651 980],'YData',[-51 460]);

    % compute H between frame 270 and 450
    threshold = 10;
    H_270 = auto_homography(Ia,Ib,threshold);
    T = maketform('projective', H_270');
    im_270 = imtransform(Ia, T, 'XData',[-651 980],'YData',[-51 460]);

    % blending
    mask = (pano == 0);
    pano = im2double(im_270).*mask + im2double(pano);
    
    % populate Ia and Ib for 630 -> 450
    projection_idx = 4;
    reference_idx = 3;
    try_correspondence;
    close all;
    
    % compute H between frame 630 and 450
    % threshold = 12.5;
    H_630 = auto_homography(Ia,Ib,threshold);
    T = maketform('projective', H_630');
    im_630 = imtransform(Ia, T, 'XData',[-651 980],'YData',[-51 460]);
    
    % blending
    mask = (pano == 0);
    pano = im2double(im_630).*mask + im2double(pano);
    figure(1), imagesc(pano), axis image;
    
    % populate Ia and Ib for 90 -> 270
    projection_idx = 1;
    reference_idx = 2;
    try_correspondence;
    close all;
    
    % threshold = 12.5;
    H_90 = auto_homography(Ia,Ib,threshold);
    
    % H_{90,450} = H_{90,270} * H_{270, 450}
    H_90 = H_90 * H_270;
    T = maketform('projective', H_90');
    im_90 = imtransform(Ia, T, 'XData',[-651 980],'YData',[-51 460]);
    
    % blending
    mask = (pano == 0);
    pano = im2double(im_90).*mask + im2double(pano);
    figure(1), imagesc(pano), axis image;
    
    % populate Ia and Ib for 810 -> 630
    projection_idx = 5;
    reference_idx = 4;
    try_correspondence;
    close all;
    
    % threshold = 12.5;
    H_810 = auto_homography(Ia,Ib,threshold);
    
    % H_{810,450} = H_{810,630} * H_{630, 450}
    H_810 = H_810 * H_630;
    T = maketform('projective', H_810');
    im_810 = imtransform(Ia, T, 'XData',[-651 980],'YData',[-51 460]);
    
    % blending
    mask = (pano == 0);
    pano = im2double(im_810).*mask + im2double(pano);
    figure(1), imagesc(pano), axis image;
    
end

%% Part 3: Map the video to the reference plane

