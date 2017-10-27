function [ hdr ] = makehdr_selective(ldr1, ldr2, ldr3, exp1, exp2, exp3)
%MAKEHDR_SELECTIVE 
    [rows, cols, dim] = size(ldr1);

    ldr1 = im2double(ldr1);
    ldr2 = im2double(ldr2);
    ldr3 = im2double(ldr3);

    % Naive averaging of multiple ldr images
    ldr1_scaled = ldr1./exp1;
    ldr2_scaled = ldr2./exp2;
    ldr3_scaled = ldr3./exp3;
    
    hdr = zeros(rows, cols, dim, 'double');
    % Mean ldrs
    for r = 1:rows
        for c = 1:cols
            weight1 = 0;
            weight2 = 0;
            weight3 = 0;
            for d = 1:dim
                 weight1 = weight1 + (0.65-abs(ldr1(r,c,d)-0.5))/0.5;
                 weight2 = weight2 + (0.65-abs(ldr2(r,c,d)-0.5))/0.5;
                 weight3 = weight3 + (0.65-abs(ldr3(r,c,d)-0.5))/0.5;
            end
            weight1 = weight1/3;
            weight2 = weight2/3;
            weight3 = weight3/3;
            weight1 = (1-(1-weight1)^2);
            weight2 = (1-(1-weight2)^2);
            weight3 = (1-(1-weight3)^2);
            th = 0.005;
            for d = 1:dim
                if weight1 < th && weight2 < th && weight3 < th
%                     hdr(r,c,d) = (ldr1_scaled(r,c,d) + ldr2_scaled(r,c,d) + ldr3_scaled(r,c,d))/3;
                end
                hdr(r,c,d) = hdr(r,c,d) + (weight1*ldr1_scaled(r,c,d) + weight2*ldr2_scaled(r,c,d) + weight3*ldr3_scaled(r,c,d))/(weight1 + weight2 + weight3);
                if weight1 < th && weight2 < th && weight3 < th
%                     hdr(r,c,d) = hdr(r,c,d)/2;
                end
            end
        end
    end
   
    
    % Rescale
    hdr(:,:,1) = 255 * mat2gray(hdr(:,:,1));
    hdr(:,:,2) = 255 * mat2gray(hdr(:,:,2));
    hdr(:,:,3) = 255 * mat2gray(hdr(:,:,3));
    hdr = uint8(hdr);

end

