function [] = plotStreet(inputStreetCellsNumber)
    roundValueVector = [flip(-3:0) -2:0 1:3 flip(0:2)];
    roundVector = [-3:2 flip(-3:3)];
    min = -inputStreetCellsNumber-4;
    max = inputStreetCellsNumber+4;
    plot(roundVector, roundValueVector,'k')
    hold on
    plot(min:-4, zeros(1, inputStreetCellsNumber+1), 'k') %west
    plot(zeros(1, inputStreetCellsNumber+1), min:-4,'k') %south
    plot(4:max, zeros(1, inputStreetCellsNumber+1), 'k') %east
    plot(zeros(1, inputStreetCellsNumber+1), 4:max,'k') %north
end

