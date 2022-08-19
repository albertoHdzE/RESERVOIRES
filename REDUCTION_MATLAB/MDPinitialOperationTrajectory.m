% Calculate initial operation trajectory
% computes volume valance for 12 months
% 
% * runoffArrayUp: runoff data for up stream reservoir (m/s/month)
% * runoffArrayDwn: runoff data for downs stream reservoir (m3/s/month)
% * numDiv: number of divisions (discretization) for h researvoirs. It must
%           be the same for all reservoirs in the system
% * hBegUp: starting level in upstream reservoir (m)
% * hEndUp: end h volumen level for upstream reservoir (m)
% * hBegDwn: starting level in downstream reservoir (m)
% * hEndDwn: end volume level for downstream reservoir (m)
% * stageSize: in months
% * turbLimitUp: limit capacity if upstream turbines (m3/s)
% * turbLimitDwn: limit capacity of downstream turbines (m3/s)
% * resCapacityUp: limit reservoir capacity of upstream reservoir (m3 E09)
% * resCapacityDwn: limit reservoir capacity of downstream reservoir (m3
%                   E09)
% WET YEAR
% upsDry=[208,228,235,608,1431,1157,669,280,216,404,398,178];
% dwnsDry=[69,75,77,200,471,381,291,93,71,133,131,59];
% example:
% upsDry=[208,228,235,608,1431,1157,669,280,216,404,398,178];
% dwnsDry=[69,75,77,200,471,381,291,93,71,133,131,59];
% [ini, fin]=MDPinitialOperationTrajectory(upsDry,dwnsDry,10,400,350,200,160,390,192,1,200,350,4.11,3.4)
% ini =
% 
%           400          365          200          180       258.42         3190        179.4
%           400          365          200          180       258.96       2931.6        179.4
%           400          365          200          180       259.14       2672.6        179.4
%           400          390          200          184       270.72       2413.5       184.89
%           400          400          200          200       283.64       2142.8       202.96
%           400          400          200          200       283.64       1859.1       202.96
%           400          390          200          188        273.1       1575.5        188.8
%           400          370          200          180       261.54       1302.4       179.82
%           400          365          200          180        258.6       1040.9        179.4
%           400          375          200          180       263.24       782.28       181.78
%           400          375          200          180       263.24       519.05       181.69
%           400          360          200          180       255.81       255.81        179.4
% 
% 
% fin =
% 
%           400          400          200          200       66.247       66.247       200.09
%           400          400          200          200       72.488       138.74       200.09
%           400          400          200          200       74.661        213.4       200.09
%           400          400          200          200        191.1        404.5       200.09
%           400          400          200          200       283.64       688.14       202.96
%           400          400          200          200       283.64       971.77       202.96
%           400          400          200          200        217.1       1188.9       200.09
%           400          400          200          200       88.935       1277.8       200.09
%           400          400          200          200       68.703       1346.5       200.09
%           400          400          200          200       127.69       1474.2       200.09
%           400          400          200          200       125.81         1600       200.09
%           400          390          200          192       134.13       1734.1       191.55
function [initialPath,finalPath]=MDPinitialOperationTrajectory(runoffArrayUp,runoffArrayDwn,numDiv,hBegUp,hEndUp,hBegDwn,hEndDwn,fixUpEnd,fixDwnEnd,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn)
initialPath=zeros(12,11);
finalPath=zeros(12,11);
% initialPath=zeros(1,7);
% finalPath=zeros(1,7);

%backward
max=0;
% numberStages = 12/stageSize; % stageSize must be a fractional: 1/2 or 1/5 etc.
% runoffUp=repelem(runoffArrayUp,numberStages);
% runoffDwn=repelem(runoffArrayDwn,numberStages);
% ITERACIÓN HACIA ATRAS, DESDE t=T=12 HASTA t=1
for j=12:-1:1
    [max,finRes]=foundMaxTwoReservoirsOneStage(numDiv,hBegUp,hEndUp,hBegDwn,hEndDwn,runoffArrayUp(j),runoffArrayDwn(j),stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,max);
    initialPath(j,:)=finRes;
end
% ---- forward ----
% it takes h0s

% initialPath=[400,400,400,400,400,400,400,400,400,400,400,400,399,394,392,392,392,391,392,392,392,392,392,392,394,396,396,396,395,395,396,392,387,375,356;
%     400,400,400,400,400,400,400,400,400,400,400,399,394,392,392,392,391,392,392,392,392,392,392,394,396,396,396,395,395,396,392,387,375,356,350;
%     200,200,200,200,200,200,200,200,200,200,200,200,200,200,194,194,194,194,194,194,194,194,194,194,194,195,195,196,198,200,200,200,200,200,200;      
%       200,200,200,200,200,200,200,200,200,200,200,200,200,194,194,194,194,194,194,194,194,194,194,194,195,195,196,198,200,200,200,200,200,200,188]';
% % runoffArrayDwn=[23,23,23,25,25,25,25.6,25.6,25.6,66.66,66.66,66.66,157,157,157,127,127,127,97,97,97,31,31,31,23.67,23.67,23.67,44.33,44.33,44.33,43.67,43.67,43.67,19.67,19.67,19.67];
% % runoffArrayUp=[69.33,69.33,69.33,76,76,76,78.33,78.33,78.33,202.67,202.67,202.67,477,477,477,385.67,385.67,385.67,223,223,223,93.33,93.33,93.33,72,72,72,134.67,134.67,134.67,132.67,132.67,132.67,59.33,59.33,59.33];
% runoffArrayDwn=[69,69,69,75,75,75,77,77,77,200,200,200,471,471,471,381,381,381,291,291,291,93,93,93,71,71,71,133,133,133,131,131,131,59,59,59];
% runoffArrayUp=[208,208,208,228,228,228,235,235,235,608,608,608,1431,1431,1431,1157,1157,1157,669,669,669,280,280,280,216,216,216,404,404,404,398,398,398,178,178,178];
% 

upPath = initialPath(:,2);
dwnPath = initialPath(:,4);

length=size(upPath);
length=length(1);
% upPath(length+1)=fixUpEnd;
% dwnPath(length+1)=fixDwnEnd;
% abre espacio al inicio y recorre el arreglo
upPath(2:length+1)=upPath;
dwnPath(2:length+1)=dwnPath;
% fija el final
upPath(length+1)=fixUpEnd;
dwnPath(length+1)=fixDwnEnd;
% agrega el inicio
upPath(1)=initialPath(1,1);
dwnPath(1)=initialPath(1,3);


inputsUp=0;
cumPow=0;
% ITERACIÓN HACIA ADELANTE, DESDE t=1 HASTA T=12
for i=1:length
    [turbinesOutflowUp,spilledVolUp,powerUp,totaLOutUp,realh1Up]=computePowerUpstream(upPath(i),upPath(i+1),runoffArrayUp(i),inputsUp,stageSize,turbLimitUp,resCapacityUp);
    [turbinesOutflowDwn,spilledVolDwn,powerDwn,totaLOutDwn,realh1Dwn]=computePowerDownstream(dwnPath(i),dwnPath(i+1),runoffArrayDwn(i),totaLOutUp,stageSize,turbLimitDwn,resCapacityDwn);
    
    cumPow = (cumPow+powerUp+powerDwn)/100000;
    generatedPower=powerUp+powerDwn/100000;
    res = [upPath(i),upPath(i+1),dwnPath(i),dwnPath(i+1),generatedPower,cumPow,realh1Dwn,turbinesOutflowUp,spilledVolUp,turbinesOutflowDwn,spilledVolDwn];
    finalPath(i,:)=res;
end

% plotting--------------
% initial path for Upstream
initialYPathUp = zeros(1,length*2);
counter = 0;
for i=1:2:length*2
    counter = counter + 1;
    initialYPathUp(i) = initialPath(counter,1);
    initialYPathUp(i+1)=initialPath(counter,2);
end

% removing iteration from 0 to 1 point (Y coordinates)
initialYPathUp(1:2)=[];

initialXPathUp=zeros(1,length*2);
initialXPathUp(1)=0;
initialXPathUp(length*2)=length;

counter = 0;
for i=1:length-1
    counter = counter + 2;
    initialXPathUp(counter)=i;
    initialXPathUp(counter+1)=i;
end

% removing iteration from 0 to 1 point (X Coordinates)
initialXPathUp(1:2)=[];

% initial path for downstream reservoir. Path found in backward iteration.
initialYPathDwn = zeros(1,length*2);
counter = 0;
for i=1:2:length*2
    counter = counter + 1;
    initialYPathDwn(i) = initialPath(counter,3);
    initialYPathDwn(i+1)=initialPath(counter,4);
end

% removing iteration from 0 to 1 point (Y coordinates)
initialYPathDwn(1:2)=[];

initialXPathDwn=zeros(1,length*2);
initialXPathDwn(1)=0;
initialXPathDwn(length*2)=length;

counter = 0;
for i=1:length-1
    counter = counter + 2;
    initialXPathDwn(counter)=i;
    initialXPathDwn(counter+1)=i;
end

initialXPathDwn(1:2)=[];

% final path found by forward iteration
% final path is composed with h0s only accordingly to Jiang.
finalPathUp = finalPath(:,2);
finalPathDwn = finalPath(:,4);

length = size(finalPathUp);
length = length(1);
equiz = (1:length)';

% if labels over points are required.
% labels = cellstr (num2str(finalPathUp));

figure(1)
plot(equiz, (finalPathUp));
hold;
plot(initialXPathUp, initialYPathUp);
title('Upstream reservoir trajectory');
%text(equiz, upLine,labels)
grid on;
xlim([0 length+1]);
ylim([hEndUp-5 hBegUp+5]);
legend('forward iteration','backward iteration');
hold off

figure(2)
plot(equiz, (finalPathDwn));
title('Downstream reservoir trajectory')
%text(equiz, upLine,labels)
hold
plot(initialXPathDwn, initialYPathDwn);

grid on;
xlim([0 length+1]);
ylim([hEndDwn-5 hBegDwn+5]);
legend('forward iteration','backward iteration')
hold off





















