function hdr = makehdr_naive(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Testing
    
    %figure(1), imagesc(ldrs(:,:,:,1)), axis image, colormap default;
    %figure(2), imagesc(ldrs(:,:,:,2)), axis image, colormap default;
    %figure(3), imagesc(ldrs(:,:,:,3)), axis image, colormap default;
    
    
    %Create naive HDR here
    hdr = mean(ldrs,4);
    
    %mat2gray(hdr(:,:,1));
    
    %rescale
    hdr(:,:,1) = 255 * mat2gray(hdr(:,:,1));
    hdr(:,:,2) = 255 * mat2gray(hdr(:,:,2));
    hdr(:,:,3) = 255 * mat2gray(hdr(:,:,3));
    hdr = uint8(hdr);

end
