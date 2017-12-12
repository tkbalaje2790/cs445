function hdr = makehdr_naive(ldrs, exps)
%MAKEHDR_NAIVE

    num_images = size(ldrs,4);
    
    ldrs = im2double(ldrs);

    % Scaling into same intensity domain
    for i = 1:num_images
        ldrs(:,:,:,i) = ldrs(:,:,:,i)./exps(i);
    end
    
    % Mean ldrs
    hdr = mean(ldrs, 4);
   
end
