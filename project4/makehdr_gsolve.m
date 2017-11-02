function [ hdr_irr] = makehdr_gsolve(ldrs,exps)
% Find the response function and create hdr image
% g(Z) = ln(t) + ln(R)

[rows, cols, dim] = size(ldrs(:,:,:,1));

hdr = zeros(rows,cols,dim,'uint8');
num_images = size(ldrs,4);

%randomly sample pixels
n = 200;
randRows = randperm(rows, n);
randCols = randperm(cols, n);

Z = zeros(n, num_images);
B = log(exps);
l = 10;
w = @(z) double(129-abs(z-128));

hdr_irr = zeros(rows,cols, dim);
hdr_irr_scaled = zeros(rows,cols, dim);

for d = 1:3
    %finding response function
    for i = 1:n
        for j = 1:num_images
            Z(i, j) = ldrs(randRows(i),randCols(i),d,j);
        end
    end
    
    figure(4), hold on
    
    [g,lE] = gsolve(Z,B,l,w);
    if d == 1
       plot(g(1:255), 1:255, 'r-', 'LineWidth',3), axis square, colormap default
    elseif d == 2
       plot(g(1:255), 1:255, 'g-', 'LineWidth',3), axis square, colormap default
    else
       plot(g(1:255), 1:255, 'b-', 'LineWidth',3), axis square, colormap default
    end
    
    %reconstructing
    for r = 1:rows
        for c = 1:cols
            numer = 0;
            denom = 0;
            for j = 1:num_images
                z = ldrs(r,c,d,j);
                numer = numer + w(z)*(g(z+1) - B(j));   
                denom = denom + w(z);
            end
            hdr_irr(r,c,d) = numer/denom;
        end
    end
%     I = hdr_irr(:,:,d);
%     minel = min(I(:));
%     offsetI = I-minel;
%     hdr_irr_scaled(:,:,d) = offsetI/max(offsetI(:));
    
end
hdr_irr = exp(hdr_irr);    
cmap = jet(256);
I =255*mat2gray(mean(hdr_irr,3));
imwrite(I, cmap, './results/irradiance_map.jpg');
figure(7), imagesc(I), axis image, colormap parula
