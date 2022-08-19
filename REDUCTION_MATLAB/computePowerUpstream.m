% Computes power generation for upstream reservoir in MW
% INPUTS:
% - h0: beginning h, (m)
% - h1: end h, (m)
% - runoff: average per month, (m3/s)
% - inputs: other inputs in (m3)E09
% - stageSize: size of period of time in consideration, month
% - turbineLimit: Turbine capacity, (m3/s)
% - storageReservoirCapacity, (m3)E09
% EXAMPLE
% from h0=400 to h1=400(m) (no difference), runoff 178 (m3/s), no more
% inputs, 1 month, turbine capacity for delivering water = 325 (m3/s) and
% reservoir capacity = 4.12 (m3)E09
%
% computePowerUpstream(400,400,178,0,1,325,4.12)

function [turbinesOutflowUp,spilledVol,powerUp,totaLOutUp,realh1Up]=computePowerUpstream(h0Up,h1Up,runoffUp,inputsUp,stageSize,turbineLimitUp,storageReservoirCapacityUp)

%1. CALCULO DEL VOLUMEN DISPONIBLE
avUpstr = availableVolumeUpstream(h0Up,h1Up,runoffUp,inputsUp,stageSize); %(m3) E09
v1=h2vUpstream(h1Up); % convert h1 to volumen using charts ((m3) E09)
%2. CALCULO DE LA SALIDA DE VOLUMEN EN LAS TURBINAS
[turbinesOutflowUp,rateOutflowAllTurbinesUp,spilledVol,totaLOutUp,realh1Up] = totalOutflowAndfinalhUpstream(stageSize,v1,avUpstr,turbineLimitUp,storageReservoirCapacityUp);
%3. CALCULO DE ENERGÍA GENERADA POR LAS TURBINAS
tail=tailUpstream(rateOutflowAllTurbinesUp);
headUp = ((h0Up+h1Up)/2)-tail;
% ----------------------------- ADAPTATION ------------------------
powerUp = (headUp*turbinesOutflowUp*10000*1); % 8.5 -> eficiency factor






















