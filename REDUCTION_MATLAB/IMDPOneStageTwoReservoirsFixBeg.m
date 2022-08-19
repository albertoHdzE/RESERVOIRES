% EXAMPLE:
% -------------
% INPUTS DESCRIPTION
% h0Up,h1Up: original point in initial path for upstream reservoir
% h0Dwn,h1Dwn: original point in initial path for dowstream reservoir
% corridorSize: number of units considered for corridor definition
% unitSizes: the size in (m) of divisions in original path, this is, for
% example, if [400-350] range is divided in 10, then unitSize = 5m
% numDivh0: number of divisions for corridor in h0 upstream
% numDivh1: number of divisions for corridor in h1 upstream
% hBegRangeUp,hEndRangeUp : limits for calculation in upstream reservoir.
% This is not the corridor, but original limits for reservoir
% hBegRangeDwn,hEndRangeDwn: limits for calculus in dowstream reservoir
% runoffUp,runoffDwn: runoff data
% stageSize:
% turbLimitUp,turbLimitDwn: turbine capacities
% resCapacityUp,resCapacityDwn: holding reservoirs capacities
% maxIn: output from previous stage. This is used for cumulative power


% inputs:
% - 390->365: upstream points
% - 192->192: dowsntream points (h0, h1)
% - corridor size: 2 units forward and backward to the point
% - unit size of divisions: 5m for upstream, 4m for downstream
% - number of divisions for corridor: 10 for h0, and 10 for h1 both,
% upstream and dowsntream
% - range limits for calculations: [400-350] for upstream, [200-160]
% downstream
% runoff data: 178 ups, 59 downs
% -turbines limits: 150 (m3/s)
% -storage reservoir limites upstream, downstream respectively: 4.11, 3.4
% (m3)E09
% inputs for other sources: 0

% [maxOut,finRes]=IMDPOneStageTwoReservoirsFixBeg(390,365,192,192,2,5,4,10,10,400,350,200,160,178,59,1,150,150,4.11,3.4,0)
% ------------ RESULTS ----------------
% maxOut =
%        157.44
% finRes =
%          395          370          196          196       157.44       157.44       197.83



function [maxOut,finRes]=IMDPOneStageTwoReservoirsFixBeg(h0Up,h1Up,h0Dwn,h1Dwn,corridorSize,unitSizeUp,unitSizeDwn,numDivh0,numDivh1,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,runoffUp,runoffDwn,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,maxIn)
format shortG;

maxOut=0;

% defining corridor limits
[h0BegRangeUp,h0EndRangeUp] = setCorridorLimits(h0Up,hBegRangeUp,hEndRangeUp,corridorSize,unitSizeUp);
[h1BegRangeUp,h1EndRangeUp] = setCorridorLimits(h1Up,hBegRangeUp,hEndRangeUp,corridorSize,unitSizeUp);

[h0BegRangeDwn,h0EndRangeDwn] = setCorridorLimits(h0Dwn,hBegRangeDwn,hEndRangeDwn,corridorSize,unitSizeDwn);
[h1BegRangeDwn,h1EndRangeDwn] = setCorridorLimits(h1Dwn,hBegRangeDwn,hEndRangeDwn,corridorSize,unitSizeDwn);

sizeDivh0Up = (h0BegRangeUp-h0EndRangeUp)/numDivh0;
sizeDivh1Up = (h1BegRangeUp-h1EndRangeUp)/numDivh1;
sizeDivh0Dwn = (h0BegRangeDwn-h0EndRangeDwn)/numDivh0;
sizeDivh1Dwn = (h1BegRangeDwn-h1EndRangeDwn)/numDivh1;

for h01Up=h1BegRangeUp:-sizeDivh1Up:h1EndRangeUp
    h0Up=h0Up; %fixed beggining
    % 0 aditional inputs to upstream reservoir
    [powerUp,totaLOutUp,finalh1Up]=computePowerUpstream(h0Up,h1Up,runoffUp,0,stageSize,turbLimitUp,resCapacityUp);
    for h1Dwn=h1BegRangeDwn:-sizeDivh1Dwn:h1EndRangeDwn
        h0Dwn=h0Dwn; % fixed beggining
        [powerDwn,totaLOutDwn,finalh1Dwn]=computePowerDownstream(h0Dwn,h1Dwn,runoffDwn,totaLOutUp,stageSize,turbLimitDwn,resCapacityDwn);
        res=[h0Up,h1Up,h0Dwn,h1Dwn,powerUp+powerDwn,maxIn+powerUp+powerDwn,finalh1Dwn];
        disp(res);
        if maxIn+powerUp+powerDwn > maxOut
            maxOut = maxIn+powerUp+powerDwn;
            finRes = res;
        end;
    end;
end;
    


