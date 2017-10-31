function [ hdr ] = makehdr_gsolve(ldrs,exps)
% Find the response function and create hdr image
% g(Z) = ln(t) + ln(R)

[y,x,z] = size(ldrs(:,:,:,1));

hdr = zeros(y,x,z,'uint8');
num_images = size(ldrs,4);

ldrs_scaled = im2double(ldrs);

% Scaling into same intensity domain
for i = 1:num_images
    ldrs_scaled(:,:,:,i) = (ldrs_scaled(:,:,:,i))./exps(i);
end

%randomly sample pixels
n = 200;
y = randperm(y);
x = randperm(x);

Z = zeros(n,num_images);
B = log(exps);
l = 100;
w = @(z) double(128-abs(z-128));

for d = 1:3
    %finding response function
    for i = 1:n
        for j = 1:num_images
            Z(i,j) = ldrs(y(i),x(i),d,j);
        end
    end
    
    [g,lE] = gsolve(Z,B,l,w);
    
    %reconstructing
    for r = 1:y
        for c = 1:x
            numer = 0;
            denom = 0;
            for j = 1:num_images
                z = ldrs(r,c,d,j);
                numer = numer + w(z)*(g(z+1) - B(j));   
                denom = denom + w(z);
            end
            lR = numer/denom;
            [~, index] = min(abs(g-(lR)));
            hdr(r,c,d) = index-1;
        end
    end
end
