function [img] = quilt_simple(sample, outsize, patchsize, overlap, tol)

%this function will:
% 1. Use ssd_patch to get a costs array
% 3. Pass costs to choose_sample
% 4. Place the sample 
% 5. Repeat until done

hsize = (patchsize-1)/2;

% overlap + (patchsize - overlap)N = outsize, 
% N - the number of tiles per dimension (NxN)
% the ceiling will cause overtiling which we can mask out later
N = ceil((outsize-overlap)/(patchsize-overlap))
oversize = overlap + (patchsize - overlap)*N;

% fill eventually fill this image in
img = zeros(oversize, oversize,3)

% possible masks:
%
%     1 0 0        1 1 1        1 1 1
% A = 1 0 0    B = 0 0 0    C = 1 0 0
%     1 0 0        0 0 0        1 0 0

mask_A = zeros(patchsize);
mask_A(:,1) = 1;

mask_B = zeros(patchsize);
mask_B(1,:) = 1;

mask_C = mask_A | mask_B;

for y = 1:N
    for x = 1:N
        start_y = (patchsize-overlap)*(y-1);
        start_x = (patchsize-overlap)*(x-1);
        if(y == 1 && x == 1)
            C = ssd_patch(sample, double(mask_A), img(1:patchsize,1:patchsize,:));
            patch = choose_sample(sample, C, hsize, tol, 5);
            img(1:patchsize,1:patchsize,:) = patch;
        elseif(y == 1)
            C = ssd_patch(sample, double(mask_A), img(1:patchsize,start_x:(start_x+patchsize-1),:));
            patch = choose_sample(sample, C, hsize, tol, 5);
            img(1:patchsize,start_x:(start_x+patchsize-1),:) = patch;
        elseif(x == 1)
            C = ssd_patch(sample, double(mask_B), img(start_y:(start_y+patchsize-1),1:patchsize,:));
            patch = choose_sample(sample, C, hsize, tol, 5);    
            img(start_y:(start_y+patchsize-1),1:patchsize,:) = patch;
        else
            C = ssd_patch(sample, double(mask_C), img(start_y:(start_y+patchsize-1),start_x:(start_x+patchsize-1),:));
            patch = choose_sample(sample, C, hsize, tol, 5);
            img(start_y:(start_y+patchsize-1),start_x:(start_x+patchsize-1),:) = patch;
        end
    end
end

img = img(1:outsize,1:outsize,:);






