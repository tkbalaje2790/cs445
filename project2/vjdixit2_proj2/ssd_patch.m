function [C] = ssd_patch(I,M,T)

% computes the cost of choosing the patch centered
% at I(y,x) given the input texture, mask, and template
% from the output image.

[y1,x1,z1] = size(I);
[y2,x2,z2] = size(M); 
[y3,x3,z3] = size(T);

%figure(1), image(M.*T)
if(z1 == 3 && z3 == 3)
    ssd_r = imfilter(I(:,:,1).^2, M) -2*imfilter(I(:,:,1), M.*T(:,:,1)) + sum(sum((M.*T(:,:,1)).^2));
    ssd_g = imfilter(I(:,:,2).^2, M) -2*imfilter(I(:,:,2), M.*T(:,:,2)) + sum(sum((M.*T(:,:,2)).^2));
    ssd_b = imfilter(I(:,:,3).^2, M) -2*imfilter(I(:,:,3), M.*T(:,:,3)) + sum(sum((M.*T(:,:,3)).^2));

    C = (ssd_r + ssd_g + ssd_b)/3;
end

if(z1 == 1 && z3 == 1)
    C = imfilter(I.^2, double(M)) -2*imfilter(I, double(M.*T)) + sum(sum((M.*T).^2));
end




