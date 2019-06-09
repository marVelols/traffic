function [street, roundabout, destination, colorArray] = carJoinment(street,roundabout,timeStep,crossCell,roundaboutOuputCells, destination, colorArray, streetColorArray)
        street(timeStep, end) = -1;
        roundabout(timeStep, crossCell) = 1;
        msize = numel(roundaboutOuputCells);
        destination(timeStep, crossCell) = roundaboutOuputCells(randperm(msize, 1));
        colorArray(timeStep, crossCell) =  streetColorArray(timeStep-1, end);
end

