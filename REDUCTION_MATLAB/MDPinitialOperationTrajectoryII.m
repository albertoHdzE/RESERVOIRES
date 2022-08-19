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
function [initialPath,finalPath]=MDPinitialOperationTrajectoryII(runoffArrayUp,runoffArrayDwn,numDiv,hBegUp,hEndUp,hBegDwn,hEndDwn,fixUpEnd,fixDwnEnd,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn)
initialPath=zeros(1,11); %backward
finalPath=zeros(1,12);   %forward includes sum of upstream outflows

%---- BACKWARD ----
max=0;
numberStages = 12/stageSize; % stageSize must be a fractional: 1/2 or 1/5 etc.
runoffUp=repelem(runoffArrayUp,numberStages/12);
runoffDwn=repelem(runoffArrayDwn,numberStages/12);

% ITERACIÓN HACIA ATRAS, DESDE t=T=12 HASTA t=1
for j=numberStages:-1:1
   [max,finRes]=foundMaxTwoReservoirsOneStage(numDiv,hBegUp,hEndUp,hBegDwn,hEndDwn,runoffUp(j),runoffDwn(j),stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,max);
   %finRes=[h0Up,h1Up,h0Dwn,h1Dwn,generatedPow,cumPower,finalh1Dwn,turbinesOutflowUp,spilledVolUp,turbinesOutflowDwn,spilledVolDwn];
   initialPath(j,:)=finRes;
end


% ---- FORWARD ----
% it takes h0s
% 
% initialPath=[400,400,400,400,400,400,400,400,400,400,400,400,400,399,394,392,392,392,391,392,392,392,392,392,392,394,396,396,396,395,395,396,392,387,375,356;
%     400,400,400,400,400,400,400,400,400,400,400,400,399,394,392,392,392,391,392,392,392,392,392,392,394,396,396,396,395,395,396,392,387,375,356,350;
%     200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,194,194,194,194,194,194,194,194,194,194,194,195,195,196,198,200,200,200,200,200,200;      
%     200,200,200,200,200,200,200,200,200,200,200,200,200,200,194,194,194,194,194,194,194,194,194,194,194,195,195,196,198,200,200,200,200,200,200,188]';

% if chooseBeg=1 then choose startring, else ending points
% ----------------------  CHOOSE ---------------------
% ----------------------------------------------------
chooseBeg = 1;
% ----------------------------------------------------
% ----------------------------------------------------

% starting points in initial trajectory or ending points
if chooseBeg == 1 
    upPath = initialPath(:,1);
    dwnPath = initialPath(:,3);
else
    upPath = initialPath(:,2);
    dwnPath = initialPath(:,4);
end


length=size(upPath);
length=length(1);


if chooseBeg==1    
    % fija el final
    upPath(length+1)=fixUpEnd;
    dwnPath(length+1)=fixDwnEnd;

else
    % abre espacio al inicio y recorre el arreglo
    upPath(2:length+1)=upPath;
    dwnPath(2:length+1)=dwnPath;
    % fija el final
    upPath(length+1)=fixUpEnd;
    dwnPath(length+1)=fixDwnEnd;
    % agrega el inicio
    upPath(1)=initialPath(1,1);
    dwnPath(1)=initialPath(1,3);
    
    
end


inputsUp=0;
cumPow=0;
% ITERACIÓN HACIA ADELANTE, DESDE t=1 HASTA T
for i=1:length
    [turbinesOutflowUp,spilledVolUp,powerUp,totaLOutUp,realh1Up]=computePowerUpstream(upPath(i),upPath(i+1),runoffUp(i),inputsUp,stageSize,turbLimitUp,resCapacityUp);
    [turbinesOutflowDwn,spilledVolDwn,powerDwn,totaLOutDwn,realh1Dwn]=computePowerDownstream(dwnPath(i),dwnPath(i+1),runoffDwn(i),totaLOutUp,stageSize,turbLimitDwn,resCapacityDwn);
    
    % FORCE TO DO NOT SPILL WATER
    % -----------------------------BEGIN
    if spilledVolUp>0.01
        spillhUp=h2vUpstream(upPath(i))-spilledVolUp; % volumes
%         difH=upPath(i)-v2hUpstream(spillhUp);
%         aux=upPath(i:length)-difH;
%         upPath(i:length)=aux;
        upPath(i)=v2hUpstream(spillhUp);
        % update last stage
        [turbinesOutflowUp2,spilledVolUp2,powerUp2,totaLOutUp2,realh1Up2]=computePowerUpstream(upPath(i-1),upPath(i),runoffUp(i-1),inputsUp,stageSize,turbLimitUp,resCapacityUp);
        [turbinesOutflowDwn2,spilledVolDwn2,powerDwn2,totaLOutDwn2,realh1Dwn2]=computePowerDownstream(dwnPath(i-1),dwnPath(i),runoffDwn(i-1),totaLOutUp2,stageSize,turbLimitDwn,resCapacityDwn);
        genPow=(powerUp2+powerDwn2)/1000000;
        cumPow = cumPow+genPow;
        res = [upPath(i-1), upPath(i), dwnPath(i-1), dwnPath(i), genPow, cumPow, realh1Dwn2,turbinesOutflowUp2,spilledVolUp2,turbinesOutflowDwn2,spilledVolDwn2];
        finalPath(i-1,:)=[res,totaLOutUp2];
        %update current stage
        [turbinesOutflowUp,spilledVolUp,powerUp,totaLOutUp,realh1Up]=computePowerUpstream(upPath(i),upPath(i+1),runoffUp(i),inputsUp,stageSize,turbLimitUp,resCapacityUp);
        
    end
    
    if spilledVolDwn>0.01
        spillhDwn=h2vDownstream(dwnPath(i))-spilledVolDwn;
        dwnPath(i)=v2hDownstream(spillhDwn);
        % update last stage
        [turbinesOutflowUp2,spilledVolUp2,powerUp2,totaLOutUp2,realh1Up2]=computePowerUpstream(upPath(i-1),upPath(i),runoffUp(i-1),inputsUp,stageSize,turbLimitUp,resCapacityUp);
        [turbinesOutflowDwn2,spilledVolDwn2,powerDwn2,totaLOutDwn2,realh1Dwn2]=computePowerDownstream(dwnPath(i-1),dwnPath(i),runoffDwn(i-1),totaLOutUp2,stageSize,turbLimitDwn,resCapacityDwn);
        genPow=(powerUp2+powerDwn2)/1000000;
        cumPow = cumPow+genPow;
        res = [upPath(i-1), upPath(i), dwnPath(i-1), dwnPath(i), genPow, cumPow, realh1Dwn2,turbinesOutflowUp2,spilledVolUp2,turbinesOutflowDwn2,spilledVolDwn2];
        finalPath(i-1,:)=[res,totaLOutUp2];
        %update current stage
        [turbinesOutflowDwn,spilledVolDwn,powerDwn,totaLOutDwn,realh1Dwn]=computePowerDownstream(dwnPath(i),dwnPath(i+1),runoffDwn(i),totaLOutUp,stageSize,turbLimitDwn,resCapacityDwn);
    end
    % FORCE TO DO NOT SPILL WATER
     % -----------------------------END
    
    genPow=(powerUp+powerDwn)/1000000;
    cumPow = cumPow+genPow;
    res = [upPath(i), upPath(i+1), dwnPath(i), dwnPath(i+1), genPow, cumPow, realh1Dwn,turbinesOutflowUp,spilledVolUp,turbinesOutflowDwn,spilledVolDwn];
    finalPath(i,:)=[res,totaLOutUp];
end


turbOutUpH = finalPath(:,8);
spilledVolUpH=finalPath(:,9);
turbOutDwnH = finalPath(:,10);
spilledVolDwnH=finalPath(:,11);
inputsDwn=finalPath(:,12);

% -------------------
% plotting function
% ------------------
%plotFlowBehaviour(initialPath,1,0,turbOutUpH,spilledVolUpH,turbOutDwnH,spilledVolDwnH,runoffArrayUp,runoffArrayDwn,turbLimitUp,4,turbLimitDwn,4,stageSize,fixUpEnd,fixDwnEnd,350,400,160,200,inputsDwn);


% plotting----------------------------------
% (initial) path for Upstream
% constant turbines limits along the time
% ------------------------------------------

initialYPathUp = zeros(1,length*2);
counter = 0;
for i=1:2:length*2
    counter = counter + 1;
    initialYPathUp(i) = initialPath(counter,1);
    initialYPathUp(i+1)=initialPath(counter,2);
end
initialXPathUp=zeros(1,length*2);
initialXPathUp(1)=0;
initialXPathUp(length*2)=length;

counter = 0;
for i=1:length-1
    counter = counter + 2;
    initialXPathUp(counter)=i;
    initialXPathUp(counter+1)=i;
end

% initial path for downstream reservoir. Path found in backward iteration.
initialYPathDwn = zeros(1,length*2);
counter = 0;
for i=1:2:length*2
    counter = counter + 1;
    initialYPathDwn(i) = initialPath(counter,3);
    initialYPathDwn(i+1)=initialPath(counter,4);
end

initialXPathDwn=zeros(1,length*2);
initialXPathDwn(1)=0;
initialXPathDwn(length*2)=length;

counter = 0;
for i=1:length-1
    counter = counter + 2;
    initialXPathDwn(counter)=i;
    initialXPathDwn(counter+1)=i;
end


% removing iteration from 0 to 1 point (X Coordinates)
% removing iteration from 0 to 1 point (Y coordinates)
%if chooseBeg==1
    initialYPathUp(1:2)=[];
    initialXPathUp(1:2)=[];
    initialYPathDwn(1:2)=[];
    initialXPathDwn(1:2)=[];
%end


% final path found by forward iteration
% final path is composed with h0s only accordingly to Jiang.

if chooseBeg==1
    finalPathUp = finalPath(:,2);
    finalPathDwn = finalPath(:,4);
else
    finalPathUp = finalPath(:,1);
    finalPathDwn = finalPath(:,3);
end

length = size(finalPathUp);
length = length(1);
equiz = (1:length)';

% if labels over points are required.
% labels = cellstr (num2str(finalPathUp));

% INITIAL TRAJECTORY UPSTREAM
% ---------------------------
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


% INITIAL TRAJECTORY DOWSNTREAM
% ------------------------------
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



% Turbines output and spilled Vols
turbOutUpH = finalPath(:,8);
spilledVolUpH=finalPath(:,9);
turbOutDwnH = finalPath(:,10);
spilledVolDwnH=finalPath(:,11);

turbLimitUpH=ones(size(turbOutUpH))*((turbLimitUp*720*60*60*stageSize)/1000000000)*4;
turbLimitDwnH=ones(size(turbOutDwnH))*((turbLimitDwn*720*60*60*stageSize)/1000000000)*4;


% OUTFLOW UPSTREAM BEHAVIOUR
% --------------------------
totalOutUp=finalPath(:,12);
normlizedRunoffUp=(runoffUp*720*60*60*stageSize)/1000000000;
figure(3)
plot(equiz, turbOutUpH);
title('Upstream output volumes')
%text(equiz, upLine,labels)
hold
plot(equiz, spilledVolUpH);
plot(equiz, normlizedRunoffUp);
plot(equiz, turbLimitUpH);
plot(equiz, totalOutUp)
grid on;
xlim([0 length+1]);
legend('Turbines output','Spilled volume','runoff','Turbines capacity', 'Total output')
hold off

% OUTFLOW DOWNSTREAM BEHAVIOUR
% -----------------------------
inputsDwn=finalPath(:,12);
runoffDwnArray=(runoffDwn*720*60*60*stageSize)/1000000000;
totalInputsDwn = inputsDwn+runoffDwnArray';
figure(4)
plot(equiz, turbOutDwnH);
title('Downstream output volumes')
%text(equiz, upLine,labels)
hold
plot(equiz, spilledVolDwnH);
plot(equiz, runoffDwnArray);
plot(equiz, turbLimitDwnH);
plot(equiz, inputsDwn);
plot(equiz, totalInputsDwn);

grid on;
xlim([0 length+1]);
legend('Turbines output','Spilled volume','runoff','Turbine limits','inputs from Upstream','total Inputs (inputs+runoffs)')
hold off
