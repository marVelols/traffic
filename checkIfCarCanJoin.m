function [canGo] = checkIfCarCanJoin(timeStep, inPutStreet, outPutStreet, outPutIndex, maxVelocity)
    canGo = 0;
    if inPutStreet(timeStep-1, end) == 0
        for i=flip(outPutIndex-maxVelocity:outPutIndex-1), j=1:maxVelocity;
            if outPutStreet(timeStep-1, i) < j
                canGo = 1;
            else
                canGo = 0;
                break;
            end
        end
    else
        canGo = -1;
    end
end

