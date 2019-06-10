function [] = showStreet(inputStreetCellsNumber, street, streetColorArray, vectorX, vectorY, timeStep)
    %plot(vectorX, vectorY, 'k')
    for j=1:inputStreetCellsNumber
        if street(timeStep, j) ~= -1
            style = [streetColorArray(timeStep, j) "."];
            style = join(style);
            plot(vectorX(j), vectorY(j), style, 'MarkerSize', 30)
            hold on
            axis([-14 14 -14 14])
            grid on
        end
    end
end

