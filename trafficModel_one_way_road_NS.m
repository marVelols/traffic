%%
% Model based on Nagel Schreckenberg model
% Cellular automata simulation of traffic
% One-way road
clc
clear all
close all

timeStepsNumber = 10;
cellsNumber = 10;
trafficArray = zeros(timeStepsNumber, cellsNumber);
maxVelocity = 5;

for timeStep=2:timeStepsNumber
    [start,trafficArray] = generateCar(trafficArray,timeStep);
    for cell=start:cellsNumber
        % maximal distance that results from previous velocity
        distance = trafficArray(timeStep-1, cell);
        % iterate through cells from 1 to maximal distance
        for step=1:distance
            % if we are not out of array and we encounter a car on our way
            % - collision
            if cell+step <= cellsNumber && trafficArray(timeStep-1, cell+step) ~= 0
                % modify maximal distance to avoid collision
                distance = step-1;
                break
            end
        end
        %if there is no car for our maximal distance -> accelerate (+ 1
        %unit of velocity), but only when we won't be out of array and our velocity
        %won't be more than maximal allowed velocity
        if cell+distance+1 <= cellsNumber && trafficArray(timeStep-1,cell+distance+1) == 0 && distance < maxVelocity
            distance = distance+1;
        end
        %if the cell contains a car
        if trafficArray(timeStep-1, cell) ~= 0
            %if car movement won't be out of array
            if cell+distance <= cellsNumber
                %move the car of distance value
                trafficArray(timeStep, cell+distance) = distance;
            end
        end
    end
end
trafficArray

%%
% Model based on Nagel Schreckenberg model
% Cellular automata simulation of traffic
% T cross road - not ready
clc
clear all
close all

timeStepsNumber = 10;
priorityStreetCellsNumber = 11;
crossStreetCellsNumber = 5;
priorityStreet = -ones(timeStepsNumber, priorityStreetCellsNumber);
crossStreet = -ones(timeStepsNumber, crossStreetCellsNumber);
priorityStreetCrossCell = 6; %to which cell of priority street go cars from cross street
maxVelocity = 5;
canGoArray = [];
colorsArray = ['y', 'r', 'm', 'c', 'b', 'g'];
colorIndex = 1;
%arrays with cars' colors
priorityStreetColorArray = strings([timeStepsNumber, priorityStreetCellsNumber]);
crossStreetColorArray = strings([timeStepsNumber, crossStreetCellsNumber]);

for timeStep=2:timeStepsNumber
    
    [startPriority, priorityStreet, priorityStreetColorArray, colorIndex] = ...
        generateCar(priorityStreet, timeStep, priorityStreetColorArray, colorIndex, colorsArray);
    [priorityStreet, priorityStreetColorArray] = timeStepMovement(startPriority, priorityStreetCellsNumber, priorityStreet,...
        priorityStreetColorArray, timeStep, maxVelocity, 1)
    
    [startCross, crossStreet, crossStreetColorArray, colorIndex] = ...
        generateCar(crossStreet, timeStep, crossStreetColorArray, colorIndex, colorsArray);
    [crossStreet, crossStreetColorArray] = timeStepMovement(startCross, crossStreetCellsNumber, crossStreet,...
        crossStreetColorArray, timeStep, maxVelocity, 0)
    
    canGo = checkIfCarCanJoin(timeStep, crossStreet, priorityStreet, priorityStreetCrossCell, maxVelocity);
    canGoArray = [canGoArray canGo];
    if canGo == 1
        crossStreet(timeStep, end) = -1;
        priorityStreet(timeStep, priorityStreetCrossCell) = 1;
        priorityStreetColorArray(timeStep, priorityStreetCrossCell) = crossStreetColorArray(timeStep-1, end);
    end
    
end
crossStreet
priorityStreet
priorityStreetColorArray
canGoArray

figure
for i=1:timeStepsNumber
    subplot(timeStepsNumber/2, 2, i)
    grid on
    axis([1 priorityStreetCellsNumber 0 5])
    for j=1:priorityStreetCellsNumber
        if priorityStreet(i, j) ~= -1
            style = [priorityStreetColorArray(i, j) "."];
            style = join(style);
            plot(j, priorityStreet(i, j), style, 'MarkerSize', 30)
            xlabel("Cell")
            ylabel("Speed")
            title(num2str(i))
            grid on
            hold on
            axis([1 priorityStreetCellsNumber 0 5])
        end
    end
    drawnow
end

figure
for i=1:timeStepsNumber
    subplot(2, timeStepsNumber/2, i)
    grid on
    axis([0 5 1 crossStreetCellsNumber])
    for j=1:crossStreetCellsNumber
        if crossStreet(i, j) ~= -1
            style = [crossStreetColorArray(i, j) "."];
            style = join(style);
            plot(crossStreet(i, j), j, style, 'MarkerSize', 30)
            xlabel("Speed")
            ylabel("Cell")
            title(num2str(i))
            grid on
            hold on
            axis([0 5 1 crossStreetCellsNumber])
        end
    end
    drawnow
end
