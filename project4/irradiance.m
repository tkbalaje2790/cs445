function [out] = irradiance(img, exposure)
% generates the log irradiance image for naive and selective LDR merging
% ln(Z) = ln(t) + ln(R)

[y,x,z] = size(img);
    
out = zeros(y,x,z);

for r = 1:y
    for c = 1:x
        for d = 1:z
            out(r,c,d) = log(double(img(r,c,d))) - log(exposure);
        end
    end
end
    
