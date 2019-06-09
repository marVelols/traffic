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
% T cross road
clc
clear all
close all

timeStepsNumber = 20;
priorityStreetCellsNumber = 21;
crossStreetCellsNumber = 11;
priorityStreet = -ones(timeStepsNumber, priorityStreetCellsNumber);
crossStreet = -ones(timeStepsNumber, crossStreetCellsNumber);
priorityStreetCrossCell = 10; %to which cell of priority street go cars from cross street
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
    subplot(5, timeStepsNumber/5, i)
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
    subplot(5, timeStepsNumber/5, i)
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
%%
% Model based on Nagel Schreckenberg model
% Cellular automata simulation of traffic
% roundabout - not ready
clc
clear all
close all

timeStepsNumber = 10;
inputStreetCellsNumber = 10;
roundaboutCellsNumber = 12;
westStreet = -ones(timeStepsNumber, inputStreetCellsNumber);
northStreet = -ones(timeStepsNumber, inputStreetCellsNumber);
eastStreet = -ones(timeStepsNumber, inputStreetCellsNumber);
southStreet = -ones(timeStepsNumber, inputStreetCellsNumber);
roundabout = -ones(timeStepsNumber, roundaboutCellsNumber);
roundaboutDestination = -ones(timeStepsNumber, roundaboutCellsNumber);
roundaboutCrossCells = [12, 3, 6, 9]; %to which cell of roundabout go cars from inputStreets
roundaboutOuputCells = [11, 2, 5, 8]; %to which cell of roundabout go cars from roundabout
maxVelocityStreet = 5;
maxVelocityRoundabout = 1;
canGoArray = [];
colorsArray = ['y', 'r', 'm', 'c', 'b', 'g'];
colorIndex = 1;
%arrays with cars' colors
westStreetColorArray = strings([timeStepsNumber, inputStreetCellsNumber]);
northStreetColorArray = strings([timeStepsNumber, inputStreetCellsNumber]);
eastStreetColorArray = strings([timeStepsNumber, inputStreetCellsNumber]);
southStreetColorArray = strings([timeStepsNumber, inputStreetCellsNumber]);
roundaboutColorArray = strings([timeStepsNumber, roundaboutCellsNumber]);

for timeStep=2:timeStepsNumber
    % generate cars
    % west car
    [startWest, westStreet, westStreetColorArray, colorIndex] = ...
        generateCar(westStreet, timeStep, westStreetColorArray, colorIndex, colorsArray);
    % north car
    [startNorth, northStreet, northStreetColorArray, colorIndex] = ...
        generateCar(northStreet, timeStep, northStreetColorArray, colorIndex, colorsArray);
    % east car
    [startEast, eastStreet, eastStreetColorArray, colorIndex] = ...
        generateCar(eastStreet, timeStep, eastStreetColorArray, colorIndex, colorsArray);
    % south car
    [startSouth, southStreet, southStreetColorArray, colorIndex] = ...
        generateCar(southStreet, timeStep, southStreetColorArray, colorIndex, colorsArray);
    
    % move cars
    % west street
    [westStreet, westStreetColorArray] = timeStepMovement(startWest, inputStreetCellsNumber, westStreet,...
        westStreetColorArray, timeStep, maxVelocityStreet, 0);
    % north street
    [northStreet, northStreetColorArray] = timeStepMovement(startNorth, inputStreetCellsNumber, northStreet,...
        northStreetColorArray, timeStep, maxVelocityStreet, 0);
    % east street
    [eastStreet, eastStreetColorArray] = timeStepMovement(startEast, inputStreetCellsNumber, eastStreet,...
        eastStreetColorArray, timeStep, maxVelocityStreet, 0);
    % south street
    [southStreet, southStreetColorArray] = timeStepMovement(startSouth, inputStreetCellsNumber, southStreet,...
        southStreetColorArray, timeStep, maxVelocityStreet, 0);
    % roundabout
    [roundabout, roundaboutColorArray, roundaboutDestination] = timeStepMovementRoundabout(roundaboutCellsNumber, roundabout,...
        roundaboutColorArray, timeStep, 1, roundaboutDestination);

    canGo = checkIfCarCanJoinRoundabout(timeStep, westStreet, roundabout, roundaboutOuputCells(1));
    %canGoArray = [canGoArray canGo];
    if canGo == 1
        [westStreet, roundabout, roundaboutDestination, roundaboutColorArray] = ...
            carJoinment(westStreet,roundabout,timeStep,roundaboutCrossCells(1),roundaboutOuputCells, roundaboutDestination, roundaboutColorArray, westStreetColorArray);
    end
    
    canGo = checkIfCarCanJoinRoundabout(timeStep, southStreet, roundabout, roundaboutOuputCells(2));
    %canGoArray = [canGoArray canGo];
    if canGo == 1
        [southStreet, roundabout, roundaboutDestination, roundaboutColorArray] = ...
            carJoinment(southStreet,roundabout,timeStep,roundaboutCrossCells(2),roundaboutOuputCells, roundaboutDestination, roundaboutColorArray, southStreetColorArray);
    end
    
    canGo = checkIfCarCanJoinRoundabout(timeStep, eastStreet, roundabout, roundaboutOuputCells(3));
    %canGoArray = [canGoArray canGo];
    if canGo == 1
        [eastStreet, roundabout, roundaboutDestination, roundaboutColorArray] = ...
            carJoinment(eastStreet,roundabout,timeStep,roundaboutCrossCells(3),roundaboutOuputCells, roundaboutDestination, roundaboutColorArray, eastStreetColorArray);
    end
    
    canGo = checkIfCarCanJoinRoundabout(timeStep, northStreet, roundabout, roundaboutOuputCells(4));
    %canGoArray = [canGoArray canGo];
    if canGo == 1
        [northStreet, roundabout, roundaboutDestination, roundaboutColorArray] = ...
            carJoinment(northStreet,roundabout,timeStep,roundaboutCrossCells(4),roundaboutOuputCells, roundaboutDestination, roundaboutColorArray, northStreetColorArray);
    end
end

westStreet
%northStreet
%eastStreet
southStreet
%canGoArray
roundabout
roundaboutDestination

for i=1:timeStepsNumber
    figure
    subplot(3, 3, 2)
    grid on
    axis([0 inputStreetCellsNumber 0 5])
    for j=1:inputStreetCellsNumber
        if northStreet(i, j) ~= -1
            style = [northStreetColorArray(i, j) "."];
            style = join(style);
            plot(j, northStreet(i, j), style, 'MarkerSize', 30)
            xlabel("Cell")
            ylabel("Speed")
            title(num2str(i))
            grid on
            hold on
            axis([0 inputStreetCellsNumber 0 5])
        end
    end
    
    subplot(3, 3, 8)
    grid on
    axis([0 inputStreetCellsNumber 0 5])
    for j=1:inputStreetCellsNumber
        if southStreet(i, j) ~= -1
            style = [southStreetColorArray(i, j) "."];
            style = join(style);
            plot(j, southStreet(i, j), style, 'MarkerSize', 30)
            xlabel("Cell")
            ylabel("Speed")
            title(num2str(i))
            grid on
            hold on
            axis([0 inputStreetCellsNumber 0 5])
        end
    end
    
    subplot(3, 3, 4)
    grid on
    axis([0 inputStreetCellsNumber 0 5])
    for j=1:inputStreetCellsNumber
        if westStreet(i, j) ~= -1
            style = [westStreetColorArray(i, j) "."];
            style = join(style);
            plot(j, westStreet(i, j), style, 'MarkerSize', 30)
            xlabel("Cell")
            ylabel("Speed")
            title(num2str(i))
            grid on
            hold on
            axis([0 inputStreetCellsNumber 0 5])
        end
    end
    
    subplot(3, 3, 6)
    grid on
    axis([0 inputStreetCellsNumber 0 5])
    for j=1:inputStreetCellsNumber
        if eastStreet(i, j) ~= -1
            style = [eastStreetColorArray(i, j) "."];
            style = join(style);
            plot(j, eastStreet(i, j), style, 'MarkerSize', 30)
            xlabel("Cell")
            ylabel("Speed")
            title(num2str(i))
            grid on
            hold on
            axis([0 inputStreetCellsNumber 0 5])
        end
    end
    
    subplot(3, 3, 5)
    grid on
    axis([0 5 0 5])
    vector = linspace(0, 5, 7);
    roundVector = [vector(2:end) flip(vector(1:end-1))];
    roundValueVector = [vector(5:end) flip(vector(1:end-1)) vector(2:4)];
    for j=1:inputStreetCellsNumber
        if roundabout(i, j) ~= -1
            style = [roundaboutColorArray(i, j) "."];
            style = join(style);
            plot(roundVector(j), roundValueVector(j), style, 'MarkerSize', 30)
            xlabel("Cell")
            ylabel("Position")
            title(num2str(i))
            grid on
            hold on
            axis([0 5 0 5])
        end
    end
end