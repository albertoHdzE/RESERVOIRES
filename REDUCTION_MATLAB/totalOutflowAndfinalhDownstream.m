% computes total volume available to produce power
% in upstream reservoir.
% This is the difference between the begining-h and end-h
% as volume in m3 E09 plus inputs. This last, ussualy
% runoff data.
% vol is in m3 E09


function [turbinesOutflow,rateOutflowAllTurbines,spilledVol,totalOutflow,newh1]=totalOutflowAndfinalhDownstream(stageSize,v1,availableVol,turbineLimit,storageReservoirCapacity)


seconds = stageSize * 30 * 24 * 60 * 60; % number of seconds in stage

potentialq=0; % volume suceptible to be delivered through turbines
              % when h0<h1 result can be negative, in this case
              % availableVol=0
if availableVol > 0 % (m3) E09 (it must to be possitive)
    potentialq=(availableVol/seconds)*1000000000;% (m3)
end

qPerTurbine = potentialq/4; % four turbines (m3/s)

% if outflow per turbine > limit, then outflow = limit * number of turbines
rateOutflowAllTurbines = 0;
if qPerTurbine < turbineLimit
    rateOutflowAllTurbines=(qPerTurbine*4)/10000; % 4 turbines in dam, (m3)E04 cuase scale of table
else
    rateOutflowAllTurbines=(turbineLimit*4)/10000;
end

% fixing units
turbinesOutflow = (rateOutflowAllTurbines * seconds)/100000; %(m3)E09

 % flow that cannot be leaved thought turbines is added to h1, this is vol
 % remaining in reservoir
nonDeliveredVol = availableVol-turbinesOutflow;
newV1=v1+nonDeliveredVol;

% if v1 (end vol) > storage reservoir capacity, then is spilled
spilledVol = 0;
if newV1 > storageReservoirCapacity
    spilledVol = newV1-storageReservoirCapacity;
end

% in any case, delivered vol is vol-delivered by turbines + spilled one
totalOutflow = turbinesOutflow + spilledVol;

% real and final h in reservoir
newh1 = v2hDownstream(newV1-spilledVol);

