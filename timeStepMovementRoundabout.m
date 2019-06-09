function [street, streetColorArray, destination] = timeStepMovementRoundabout(cellsNumber, street, streetColorArray, timeStep, priority, destination)
    for cell=1:cellsNumber
        %if the cell contains a car
        if street(timeStep-1, cell) ~= -1
            if cell==destination(timeStep-1, cell)
                street(timeStep, cell) = -1;
                destination(timeStep, cell) = -1;
                streetColorArray(timeStep, cell) = '';
                continue;
            end
            % maximal distance that results from previous velocity
            distance = street(timeStep-1, cell);
            % if we are not out of array and we encounter a car on our way
            % - collision
            if (cell+1 <= cellsNumber && street(timeStep-1, cell+1) ~= -1) || (cell==cellsNumber && street(timeStep-1, 1) ~= -1)
                % modify maximal distance to avoid collision
                distance = 0;
            end           
            %if there is no car for our maximal distance -> accelerate (+1
            %unit of velocity), but only when we won't be out of array and our velocity
            %won't be more than maximal allowed velocity
            if (cell+distance+1 <= cellsNumber && street(timeStep-1,cell+distance+1) == -1 && distance < 1) ...
                    || (cell==cellsNumber && street(timeStep-1,1) == -1 && distance < 1)
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
                        destination(timeStep, cell) = -1;
                    %if street ends on another street
                    else
                        street(timeStep, cell) = 0;
                        streetColorArray(timeStep, cell) = streetColorArray(timeStep-1, cell);
                        destination(timeStep, cell) = destination(timeStep-1, cell)
                    end
                %normal car movement
                else
                    street(timeStep, cell+distance) = distance;
                    streetColorArray(timeStep, cell+distance) = streetColorArray(timeStep-1, cell);
                    destination(timeStep, cell+distance) = destination(timeStep-1, cell)
                end
            %stop car when it reaches road end
            else
                street(timeStep, 1) = distance;
                streetColorArray(timeStep, 1) = streetColorArray(timeStep-1, cell);
                destination(timeStep, 1) = destination(timeStep-1, cell);
            end
        end
    end
end