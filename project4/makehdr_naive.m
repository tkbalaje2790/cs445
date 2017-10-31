function hdr = makehdr_naive(ldr1, ldr2, ldr3, exp1, exp2, exp3)
%MAKEHDR_NAIVE naive merging of ldr images

    ldr1 = im2double(ldr1);
    ldr2 = im2double(ldr2);
    ldr3 = im2double(ldr3);

    % Naive averaging of multiple ldr images
    ldr1_scaled = ldr1./exp1;
    ldr2_scaled = ldr2./exp2;
    ldr3_scaled = ldr3./exp3;
    
    % Mean ldrs
    ldrs = cat(4, ldr1_scaled, ldr2_scaled, ldr3_scaled);
    hdr = mean(ldrs, 4);
    
    % Rescale
    hdr(:,:,1) = 255 * mat2gray(hdr(:,:,1));
    hdr(:,:,2) = 255 * mat2gray(hdr(:,:,2));
    hdr(:,:,3) = 255 * mat2gray(hdr(:,:,3));
    hdr = uint8(hdr);

end
