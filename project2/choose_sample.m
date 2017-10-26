function [good_patch] = choose_sample(I, C, hsize, tol, n)

% choose_sample will take a cost image (where each 
% pixel's value is the cost of selecting the patch 
% centered at that pixel), the tolerance, and pick 
% from n patches.

[rows,cols] = size(C)

%setting non-square patches to tolerance so we don't pick them
C(1:(hsize),:) = realmax('single');
C(:,1:(hsize)) = realmax('single');
C((rows-(hsize-1)):rows,:) = realmax('single');
C(:,cols-(hsize-1):cols) = realmax('single');

minc = min(min(C));

[y, x] = find(C<tol);

% remove non-square patches 
% y_valid = y(y > hsize & x > hsize)
% y_valid = y(y <= (rows - hsize) & x <= (cols - hsize))
% x_valid = x(x > hsize & y > hsize)
% x = x(x <= (cols - hsize) & y <= (rows - hsize))

% pick random patch
[n,~] = size(x);
idx = floor(rand*(n-1) + 1);

if(n == 0)
    [y, x] = find(C<minc*(1+tol));
    [n,~] = size(x);
    idx = floor(rand*(n-1) + 1);
end

y(idx)
x(idx)

good_patch = I(y(idx)-hsize:y(idx)+hsize,x(idx)-hsize:x(idx)+hsize,:);































