function [y,x] = draw_line(err, mask)

[rows,cols] = size(mask)

y = zeros(1,rows);
x = zeros(1,rows);

for j = 1:rows
    for i = 1:cols
        if (mask(j,i) == 1)
            y(j) = i;
            x(j) = j;
            break;
        end
    end
end
            
       




