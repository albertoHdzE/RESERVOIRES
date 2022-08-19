% Computes the final outflow from (upstream) reservoir, this is the sum of
% turbine's outflow + spilled volume.
% The principle of computations responds to the need to know how much water
% really leaves reservoir. Such volume depends on turbines capacity.
% inputs:
% - stageSize: size of considered period of time, months
% - v1       : volume of final h1 or h at the end of the period of time
% - availableVol: volume susceptible to be delivered, this is,
% v(h0)-v(h1)+inputs, where inputs usually are runoff data, (m3)E09
% turbineLimit: turbines capacity to delivering water (m3/s))
% storageReservoirCapacity: (m3)E09

% EXAMPLE:
% 1 month
% - volume for h1: 4.11 (m3)E09. Supposing volume balance is between h0: 400m
% and h1=400m. where 4.11 is vol corresponding to 400m 
% volume available: 0.4613 (m3)E09, 
% turbine capacity: 325 (m3/s)
% storage reservoir capacity: 4.12 (m3)E09
% [turbinesOutflow,totalOutflow,newh1]=totalOutflowAndfinalhUpstream(1,4.11,0.4613,325,4.12)

%absolute vol in sizeStage, rate of outflow     , spilled  , spill+out  , finalH 
%           (m3)E09          (m3/s)E04           (m3)E09   (m3)E09        (m)   
function [turbinesOutflow,rateOutflowAllTurbines,spilledVol,totalOutflow,newh1]=totalOutflowAndfinalhUpstream(stageSize,v1,availableVol,turbineLimit,storageReservoirCapacity)


seconds = stageSize * 30 * 24 * 60 * 60; % number of seconds in stage
potentialq=0; % volume suceptible to be delivered through turbines
              % when h0<h1 result can be negative, in this case
              % availableVol=0

% 1. VOLUMEN DISPONIBLE
% available vol is the vol ready to be used in the stageSize (m3) E09
if availableVol > 0 %  (it must to be possitive)
    potentialq=(availableVol/seconds)*1000000000;% (m3/s)E09
end

% 2. GASTO POR TURBINA
qPerTurbine = potentialq/4; % four turbines (m3/s)

% if outflow per turbine > limit, then outflow = limit * number of turbines
rateOutflowAllTurbines = 0;

% 3. ¿ES EL GASTO POR TURBINA MENOR AL LIMITE POR TURBINA?
if qPerTurbine < turbineLimit
    % 4. SI SÍ, ENTONCES gasto total = gasto * noTurbinas
    rateOutflowAllTurbines=(qPerTurbine*4)/10000; % 4 turbines in dam, (m3)E04 cuase scale of table
else
    % 5. SI NO, ETONCES, LIMITE * NUMERO DE TURBINAS
    rateOutflowAllTurbines=(turbineLimit*4)/10000;
end

% total turbines outflow in the whole stage size
turbinesOutflow = (rateOutflowAllTurbines * seconds)/100000; %(m3)E09

 % flow that cannot be leaved thought turbines is added to h1, this is vol
 % remaining in reservoir
% 6. CALCULO DE VOLUMEN NO LIBERADO
nonDeliveredVol = availableVol-turbinesOutflow; %(m3)E09
newV1=v1+nonDeliveredVol;

% if v1 (end vol) > storage reservoir capacity, then is spilled
% 7. CALCULO DE VOLUMEN VERTIDO
spilledVol = 0;
if newV1 > storageReservoirCapacity
    spilledVol = newV1-storageReservoirCapacity;
end

% in any case, delivered vol is vol-delivered by turbines + spilled one
totalOutflow = turbinesOutflow + spilledVol;
% 8. SALIDA TOTAL DE LAS TURBINAS
% real and final h in reservoir
newh1 = v2hUpstream(newV1-spilledVol);





