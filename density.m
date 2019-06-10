function [densityArray] = density(array, rows, cols)
    densityArray = zeros(1, cols);
    for r=1:rows
        for c=1:cols
            if array(r, c) > -1
                densityArray(c) = densityArray(c) + 1;
            end
        end
    end
end

