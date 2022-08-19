% Computes power generation for downstream reservoir in (MW) in one single
% division (discretization) of a stage.
% computes power from h0 to h1
% INPUTS:
% - h0: beginning h, (m)
% - h1: end h, (m)
% - runoff: average per month, (m3/s)
% - inputs: other inputs in (m3)E09
% - stageSize: size of period of time in consideration, month
% - turbineLimit: Turbine capacity, (m3/s)
% - storageReservoirCapacity, (m3)E09
% EXAMPLE
% from h0=200 to h1=200(m) (no difference), runoff 59 (m3/s), 0.4614 (m3)E09
% inputs from upstream, 1 month, turbine capacity for delivering water = 325 (m3/s) and
% reservoir capacity = 3.4 (m3)E09
%
% computePowerDownstream(200,200,59,0.4614,1,325,3.4)
% ans =  24.7519 (MW)

function [turbinesOutflowDwn,spilledVol,powerDwn,totaLOutDwn,realh1Dwn]=computePowerDownstream(h0Dwn,h1Dwn,runoffDwn,inputsDwn,stageSize,turbineLimitDwn,storageReservoirCapacityDwn)

avDwn = availableVolumeDownstream(h0Dwn,h1Dwn,runoffDwn,inputsDwn,stageSize);
v1=h2vDownstream(h1Dwn);
[turbinesOutflowDwn,rateOutflowAllTurbinesDwn,spilledVol,totaLOutDwn,realh1Dwn] = totalOutflowAndfinalhDownstream(stageSize,v1,avDwn,turbineLimitDwn,storageReservoirCapacityDwn);
tailDwn=tailDownstream(rateOutflowAllTurbinesDwn);
headDwn = ((h0Dwn+h1Dwn)/2)-tailDwn;
powerDwn = (headDwn*turbinesOutflowDwn*10000*1); % 8.5 -> eficiency factor


