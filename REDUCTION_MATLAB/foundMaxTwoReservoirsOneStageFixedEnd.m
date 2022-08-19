% EXAMPLE:
% inputs:
% -10 divisions
% -Upstream reservoir h limits = [from 400 to 350](m)
% -Downstream reservoir h limits = [from 200 to 160](m)
% -390(m) fixed end point for upstream reservoir
% -192(m) fixed end point for downstream reservoir
% -runoff's upstream: 178 (m3/s)
% -runoff's downstream: 59 (m3/s)
% -1 month
% -turbines limits: 325 (m3/s)
% -storage reservoir limites upstream, downstream respectively: 4.11, 3.4
% (m3)E09
% [one,two]=foundMaxTwoReservoirsOneStageFixedEnd(10,400,350,200,160,390,192,178,59,1,325,325,4.1,3.4,0)



function [maxOut,finRes]=foundMaxTwoReservoirsOneStageFixedEnd(numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,endUpFixed,endDwnFixed,runoffUp,runoffDwn,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,maxIn)
format shortG;
sizeDivUp = (hBegRangeUp - hEndRangeUp)/numDiv;
sizeDivDwn = (hBegRangeDwn - hEndRangeDwn)/numDiv;
bigMatrix=zeros(1,7);
counter=0;
maxOut=0;
% compute generation power from a range of h0 with a single hi (fixed)
for h0Up=hBegRangeUp:-sizeDivUp:hEndRangeUp
    h1Up=endUpFixed;
    % 0 aditional inputs to upstream reservoir
    % test range of ho with a fixed h1 for upstream reservoir
    [powerUp,totaLOutUp,finalh1Up]=computePowerUpstream(h0Up,h1Up,runoffUp,0,stageSize,turbLimitUp,resCapacityUp);
    for h0Dwn=hBegRangeDwn:-sizeDivDwn:hEndRangeDwn
        h1Dwn=endDwnFixed;
        % downstream receives flow upstream output as input (totalOutUp)
        [powerDwn,totaLOutDwn,finalh1Dwn]=computePowerDownstream(h0Dwn,h1Dwn,runoffDwn,totaLOutUp,stageSize,turbLimitDwn,resCapacityDwn);
        % powerUp + powerDwn = total power in a single computation
        % maxIn+powerUp+powerDwn = cumulative power production
        res=[h0Up,h1Up,h0Dwn,h1Dwn,powerUp+powerDwn,maxIn+powerUp+powerDwn,finalh1Dwn];
        counter = counter +1;
        bigMatrix(counter,:)=res(1,:);
        
        %disp(res);
        if maxIn+powerUp+powerDwn > maxOut
            maxOut = maxIn+powerUp+powerDwn;
            finRes = res;
            
        end;
    end;
    
end;

csvwrite('bigMatrix1.csv',bigMatrix);