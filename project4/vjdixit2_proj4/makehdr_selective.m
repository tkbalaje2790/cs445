function [ hdr ] = makehdr_selective(ldrs,exps)
%MAKEHDR_SELECTIVE 
    [rows, cols, dim] = size(ldrs(:,:,:,1));
    
    num_images = size(ldrs,4);
    ldrs = double(ldrs);

    % Scaling into same intensity domain
    for i = 1:num_images
        ldrs_scaled(:,:,:,i) = ldrs(:,:,:,i)./exps(i);
    end
    
    hdr = zeros(rows, cols, dim, 'double');
    w = @(z) double(128-abs(z-128));
    % Mean ldrs
    for r = 1:rows
        for c = 1:cols
            weights = zeros(dim, num_images);
            for d = 1:dim
                for i = 1:num_images
                    weights(d, i) = max(w(ldrs(r,c,d,i)), 10);
                end
            end
            for d = 1:dim
                for i = 1:num_images
                    hdr(r,c,d) = hdr(r,c,d) + weights(d, i)*ldrs_scaled(r,c,d,i);
                end
                hdr(r,c,d) = hdr(r,c,d)/sum(weights(d, :));
            end
        end
    end

end

