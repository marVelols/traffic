function [canGo] = checkIfCarCanJoinRoundabout(timeStep, inPutStreet, outPutStreet, outPutIndex)
    canGo = 0;
    cellToCheck = 0;
    if inPutStreet(timeStep-1, end) == 0
        if outPutStreet(timeStep-1, outPutIndex) == -1 && outPutStreet(timeStep-1, outPutIndex+1) == -1
            canGo = 1;
        end
    else
        canGo = -1;
    end
end

