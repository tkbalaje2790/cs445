function [img] = quilt_cut(sample, outsize, patchsize, overlap, tol)

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
%     1 0 0        1 1 1        1 1 1        1 1 1
% A = 1 0 0    B = 0 0 0    C = 1 0 0    D = 1 1 1
%     1 0 0        0 0 0        1 0 0        1 1 1

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
            % nothing changes in this case from simple overlap
            img(1:patchsize,1:patchsize,:) = patch;
        elseif(y == 1)
            C = ssd_patch(sample, double(mask_A), img(1:patchsize,start_x:(start_x+patchsize-1),:));
            patch = choose_sample(sample, C, hsize, tol, 5);
            %img(1:patchsize,start_x:(start_x+patchsize-1),:) = patch;
            overlap_left = img(1:patchsize,start_x:(start_x+overlap-1),:);
            overlap_right = patch(:,1:overlap,:);
            vertical_error = mean(abs(overlap_right - overlap_left),3);
            cut_mask = cut(transpose(vertical_error));
            cut_mask = transpose(cut_mask)
            %fill in non-overlap part
            img(1:patchsize,(start_x+overlap):(start_x+patchsize-1),:) = patch(:,overlap+1:patchsize,:);
            %fill in left overlap
            img(1:patchsize,start_x:(start_x+overlap-1),:) = overlap_left.*(~cut_mask);
            %fill in right overlap
            img(1:patchsize,start_x:(start_x+overlap-1),:) = img(1:patchsize,start_x:(start_x+overlap-1),:)+overlap_right.*(cut_mask);
        elseif(x == 1)
            C = ssd_patch(sample, double(mask_B), img(start_y:(start_y+patchsize-1),1:patchsize,:));
            patch = choose_sample(sample, C, hsize, tol, 5);    
            %img(start_y:(start_y+patchsize-1),1:patchsize,:) = patch;
            overlap_top = img(start_y:(start_y+overlap-1),1:patchsize,:);
            overlap_bottom = patch(1:overlap,:,:);
            horizontal_error = mean(abs(overlap_top - overlap_bottom),3);
            cut_mask = cut(horizontal_error)
            %fill in non-overlap part
            img((start_y+overlap):(start_y+patchsize-1),1:patchsize,:) = patch(overlap+1:patchsize,:,:);
            %fill in top overlap
            img(start_y:(start_y+overlap-1),1:patchsize,:) = overlap_top.*(~cut_mask);
            %fill in bottom overlap
            img(start_y:(start_y+overlap-1),1:patchsize,:) = img(start_y:(start_y+overlap-1),1:patchsize,:)+overlap_bottom.*(cut_mask);
        else
            C = ssd_patch(sample, double(mask_C), img(start_y:(start_y+patchsize-1),start_x:(start_x+patchsize-1),:));
            image(C), colormap gray, axis image
            patch = choose_sample(sample, C, hsize, tol, 5);
            %img(start_y:(start_y+patchsize-1),start_x:(start_x+patchsize-1),:) = patch;
            overlap_left = img(1:patchsize,start_x:(start_x+overlap-1),:);
            overlap_right = patch(:,1:overlap,:);
            overlap_top = img(start_y:(start_y+overlap-1),1:patchsize,:);
            overlap_bottom = patch(1:overlap,:,:);
            vertical_error = mean(abs(overlap_right - overlap_left),3);
            horizontal_error = mean(abs(overlap_top - overlap_bottom),3);
            %--
            cut_mask_horiz = cut(horizontal_error)
            cut_mask_vert  = cut(transpose(vertical_error));
            cut_mask_vert = transpose(cut_mask_vert)
            %-- 
            % masklord!!
            %--
            masklord = ones(patchsize);
            masklord(:,1:overlap) = masklord(:,1:overlap) & cut_mask_vert;
            masklord(1:overlap,:) = masklord(1:overlap,:) & cut_mask_horiz
            
            %fill in corner
            img(start_y:(start_y+patchsize-1),start_x:(start_x+patchsize-1),:) = (~masklord) .* img(start_y:(start_y+patchsize-1),start_x:(start_x+patchsize-1),:);
            %fill in the rest
            img(start_y:(start_y+patchsize-1),start_x:(start_x+patchsize-1),:) = img(start_y:(start_y+patchsize-1),start_x:(start_x+patchsize-1),:)+ masklord .* patch;
        end
    end
end

img = img(1:outsize,1:outsize,:);