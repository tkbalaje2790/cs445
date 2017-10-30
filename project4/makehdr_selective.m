function [ hdr ] = makehdr_selective(ldrs,exps)
%MAKEHDR_SELECTIVE 
    [rows, cols, dim] = size(ldrs(:,:,:,1));
    
    num_images = size(ldrs,4);
    ldrs = im2double(ldrs);

    % Scaling into same intensity domain
    for i = 1:num_images
        ldrs_scaled(:,:,:,i) = ldrs(:,:,:,i)./exps(i);
    end
    
    hdr = zeros(rows, cols, dim, 'double');
    % Mean ldrs
    for r = 1:rows
        for c = 1:cols
            weights = zeros(1,num_images);
            for d = 1:dim
                for i = 1:num_images
                    weights(i) = weights(i) + (0.65-abs(ldrs(r,c,d,i)-0.5))/0.5;
                end
            end
            for i = 1:num_images
                weights(i) = weights(i)/num_images;
                weights(i) = (1-(1-weights(i))^2);
            end
            for d = 1:dim
                for i = 1:num_images
                    hdr(r,c,d) = hdr(r,c,d) + weights(i)*ldrs_scaled(r,c,d,i);
                end
                hdr(r,c,d) = hdr(r,c,d)/sum(weights);
            end
        end
    end
    
    % Rescale
    hdr(:,:,1) = 255 * mat2gray(hdr(:,:,1));
    hdr(:,:,2) = 255 * mat2gray(hdr(:,:,2));
    hdr(:,:,3) = 255 * mat2gray(hdr(:,:,3));
    hdr = uint8(hdr);

end

