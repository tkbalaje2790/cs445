function hdr = makehdr_naive(ldrs, exps)
%MAKEHDR_NAIVE

    num_images = size(ldrs,4);

    % Scaling into same intensity domain
    for i = 1:num_images
        ldr_scaled = im2double(ldrs(:,:,:,i));
        ldrs(:,:,:,i) = ldr_scaled./exps(i);
    end
    
    % Mean ldrs
    hdr = mean(ldrs, 4);
    
    % Rescale
    hdr(:,:,1) = 255 * mat2gray(hdr(:,:,1));
    hdr(:,:,2) = 255 * mat2gray(hdr(:,:,2));
    hdr(:,:,3) = 255 * mat2gray(hdr(:,:,3));
    hdr = uint8(hdr);
    
end
