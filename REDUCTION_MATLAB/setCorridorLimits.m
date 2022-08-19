function [begCorridor,endCorridor]=setCorridorLimits(point,hBegRange,hEndRange,corridorSize,unitSize)
% case 3: when corridor fits perfectly in limits
    pointPlus = point + ((corridorSize/2)*unitSize);
    pointMinus = point - ((corridorSize/2)*unitSize);

    if point < hBegRange && pointPlus<= hBegRange && pointMinus >= hEndRange
        begCorridor = point + ((corridorSize/2)*unitSize);
        endCorridor = point - ((corridorSize/2)*unitSize);
    end
    
    % case 4: when point is near or is equal to upper limit
    if point <= hBegRange && pointPlus> hBegRange && pointMinus > hEndRange
        begCorridor = hBegRange;
        endCorridor = point - ((corridorSize/2)*unitSize);
    end
    % case 5: when point is near or is equal to lower limit
    if point >= hEndRange && pointMinus< hEndRange && pointPlus<hBegRange
        endCorridor = hEndRange;
        begCorridor = point + ((corridorSize/2)*unitSize);
    end
end
