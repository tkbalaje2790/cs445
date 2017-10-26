function [img] = quilt_random(sample, outsize, patchsize)

% initial implementation: sample patches and the output image are squares
% if patchsize doesn't fit nicely into outsize, pick the closest outsize
% that works

%im = im2single(imread('./samples/bricks_small.jpg'));

[h,s,v] = rgb2hsv(sample);

if(mod(outsize,patchsize) ~= 0)
   outsize = patchsize*idivide(int64(outsize), int64(patchsize));
end

[rows,cols] = size(v);
sz = max(rows, cols);

if(patchsize > sz)
    return
end

%--

dim = (outsize/patchsize);
img = zeros(outsize, outsize,3);

rng('shuffle');

for j = 0:(dim-1)
    for i = 0:(dim-1)
        y = floor(rand*(rows-patchsize)) + 1;
        x = floor(rand*(cols-patchsize)) + 1;
        % copy appropiate patches
        tile_h = h(y:(y-1+patchsize),x:(x-1+patchsize));
        tile_s = s(y:(y-1+patchsize),x:(x-1+patchsize));
        tile_v = v(y:(y-1+patchsize),x:(x-1+patchsize));
        %
        y_start = j*patchsize + 1;
        y_end = y_start+(patchsize-1);
        x_start = i*patchsize+1;
        x_end = x_start+(patchsize-1);
        %
        img(y_start:y_end, x_start:x_end, 1) = tile_h;
        img(y_start:y_end, x_start:x_end, 2) = tile_s;
        img(y_start:y_end, x_start:x_end, 3) = tile_v;
    end
end

img = (hsv2rgb(img));
    




    
    