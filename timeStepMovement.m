function [street, streetColorArray] = timeStepMovement(start, cellsNumber, street, streetColorArray, timeStep, maxVelocity, priority)
    for cell=start:cellsNumber
        %if the cell contains a car
        if street(timeStep-1, cell) ~= -1
            % maximal distance that results from previous velocity
            distance = street(timeStep-1, cell);
            % iterate through cells from 1 to maximal distance
            for step=1:distance
                % if we are not out of array and we encounter a car on our way
                % - collision
                if cell+step <= cellsNumber && street(timeStep-1, cell+step) ~= -1
                    % modify maximal distance to avoid collision
                    distance = step-1;
                    break
                end
            end
            %if there is no car for our maximal distance -> accelerate (+1
            %unit of velocity), but only when we won't be out of array and our velocity
            %won't be more than maximal allowed velocity
            if cell+distance+1 <= cellsNumber && street(timeStep-1,cell+distance+1) == -1 && distance < maxVelocity
                distance = distance+1;
            end
            %if car movement won't be out of array
            if cell+distance <= cellsNumber
                %move the car of distance value
                %if car stands in last cell
                if street(timeStep-1,cell) == 0 && cell == cellsNumber
                    %if street doesn't end on another street
                    if priority
                        street(timeStep, cell) = -1;
                        streetColorArray(timeStep, cell) = '';
                    %if street ends on another street
                    else
                        street(timeStep, cell) = 0;
                        streetColorArray(timeStep, cell) = streetColorArray(timeStep-1, cell);
                    end
                %normal car movement
                else
                    street(timeStep, cell+distance) = distance;
                    streetColorArray(timeStep, cell+distance) = streetColorArray(timeStep-1, cell);
                end
            %stop car when it reaches road end
            else
                street(timeStep, cellsNumber) = 0;
                streetColorArray(timeStep, cellsNumber) = streetColorArray(timeStep-1, cell);
            end
        end
    end
end

