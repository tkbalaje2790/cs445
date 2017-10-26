N = 3;

for y = 1:N
    for x = 1:N
        if(y == 1 && x == 1)
            z = 1
        elseif(y == 1)
            z = 2
        elseif(x == 1)
            z = 3
        else
            z = 4
        end
        
    end
end