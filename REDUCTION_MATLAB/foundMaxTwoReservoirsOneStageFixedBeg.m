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
% [one,two]=foundMaxTwoReservoirsOneStageFixedBeg(10,400,350,200,160,390,192,178,59,1,325,325,4.1,3.4,0)



function [maxOut,finRes]=foundMaxTwoReservoirsOneStageFixedBeg(numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,beggUpFixed,beggDwnFixed,runoffUp,runoffDwn,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,maxIn)
format shortG;
sizeDivUp = (hBegRangeUp - hEndRangeUp)/numDiv;
sizeDivDwn = (hBegRangeDwn - hEndRangeDwn)/numDiv;
maxOut=0;

% compute generation power from a range of h0 with a single hi (fixed)
h0Up=beggUpFixed;
for h1Up=hBegRangeUp:-sizeDivUp:hEndRangeUp
    % 0 aditional inputs to upstream reservoir
    % test range of ho with a fixed h1 for upstream reservoir

    [turbinesOutflowUp,spilledVolUp,powerUp,totaLOutUp,finalh1Up]=computePowerUpstream(h0Up,h1Up,runoffUp,0,stageSize,turbLimitUp,resCapacityUp);
    
    h0Dwn=beggDwnFixed;    
    for h1Dwn=hBegRangeDwn:-sizeDivDwn:hEndRangeDwn        
        % downstream receives flow upstream output as input (totalOutUp)
        [turbinesOutflowDwn,spilledVolDwn,powerDwn,totaLOutDwn,finalh1Dwn]=computePowerDownstream(h0Dwn,h1Dwn,runoffDwn,totaLOutUp,stageSize,turbLimitDwn,resCapacityDwn);
        % powerUp + powerDwn = total power in a single computation
        % maxIn+powerUp+powerDwn = cumulative power production
        %res=[h0Up,h1Up,h0Dwn,h1Dwn,powerUp+powerDwn,maxIn+powerUp+powerDwn,finalh1Dwn];
        sumPower=(powerUp+powerDwn)/100000;
        cumSumPower=(maxIn+powerUp+powerDwn)/100000;
        res=[h0Up,h1Up,h0Dwn,h1Dwn,sumPower,cumSumPower,finalh1Dwn,turbinesOutflowUp,spilledVolUp,turbinesOutflowDwn,spilledVolDwn];
        %disp(res);
        if maxIn+powerUp+powerDwn > maxOut
            maxOut = maxIn+powerUp+powerDwn;
            finRes = res;
        end;
    end;
    
end;