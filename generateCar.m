function [start, street, streetColorArray, colorIndex] = generateCar(street,timeStep, streetColorArray, colorIndex, colorsArray, prob)
    %generate a car
    start = 1;
    % if there is no car in first cell and round(rand) == 1
    ifGenerate = randsrc(1,1,[0,1;1-prob,prob]);
    if street(timeStep-1, 1) == -1 && ifGenerate
        % generate car with velocity 1-5 for first cell
        velocity = randi([1 5],1,1);
        % add new car to array
        street(timeStep, 1) = velocity;
        streetColorArray(timeStep, 1) = colorsArray(colorIndex);
        % start analysis from second car, because for first cell movemnet
        % is already done - car came
        if colorIndex + 1 <= length(colorsArray)
            colorIndex = colorIndex + 1;
        else
            colorIndex = 1;
        end
        start = 2;
    end
end

