% 
% ---- defines runoff data and computes initial path ---
% ------------------------------------------------------
% upsDry=[208,228,235,608,1431,1157,669,280,216,404,398,178];
% dwnsDry=[69,75,77,200,471,381,291,93,71,133,131,59];

% -- example 1 for initial trajectory --
% initialOperationTrajectoryFixedEnd(runoffArrayUp,runoffArrayDwn,numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn)
% pathDry=initialOperationTrajectoryFixedEnd(upsDry,dwnsDry,20,400,350,200,160,1,75,75,4.11,3.4)

% -- example 2 for initial trajectory --
% pathDry=initialOperationTrajectoryFixedEnd(upsDry,dwnsDry,10,400,350,200,160,1,325,325,4.11,3.4)

% calculating new path by means POA
% [maxOut,newPath]=ApplyPOACreateNewPathTwoReservoirs(pathDry,upsDry,dwnsDry,20,400,350,200,160,1,325,325,4.11,3.4)
% 
% ------- Result (initial path) example 1 for initial trajectory --------------------

% pathDry =
%          hUpBeg       hUpEnd       hDwnBeg     hDwnEnd   totalPow   cumulativePow   finalh1Dwn
%       -----------------------------------------------------------------------------------------
%           400          400          200          200       66.247       952.06       200.09
%           400          400          200          200       71.949       885.81       200.26
%           400          400          200          200       73.192       813.86       200.56
%           400          400          200          200       84.726       740.67       202.96
%           400          400          200          200       84.726       655.94       202.96
%           400          400          200          200       84.726       571.22       202.96
%           400          400          200          200       84.726       486.49       202.96
%           400          400          200          200        81.18       401.77       202.49
%           400          400          200          200       68.703       320.59       200.09
%           400          400          200          200       84.726       251.88       202.96
%           400          400          200          200       84.726       167.16       202.96
%           400          390          200          192       82.431       82.431       201.98
%

% % ------- Result (initial path) example 2 for initial trajectory --------------------
% pathDry =
% 
%           400          400          200          200       66.247       1863.5       200.09
%           400          400          200          200       72.488       1797.2       200.09
%           400          400          200          200       74.661       1724.7       200.09
%           400          400          200          200        191.1       1650.1       200.09
%           400          400          200          200        360.7         1459       202.96
%           400          400          200          200       335.91       1098.3       202.96
%           400          400          200          200        217.1       762.35       200.09
%           400          400          200          200       88.935       545.26       200.09
%           400          400          200          200       68.703       456.32       200.09
%           400          400          200          200       127.69       387.62       200.09
%           400          400          200          200       125.81       259.94       200.09
%           400          390          200          192       134.13       134.13       191.55
% 
% fist iteration
% ---------------------------------------------------------------------------------------------
% newPath =
% 
%           400          400          200          200       66.247       2010.6            0
%           400          400          200          200       74.661       1944.4            0
%           400        357.5          200          200       244.19       1869.7            0
%         357.5          400          200          200       7.8731       1625.6            0
%           400          400          200          200       74.661       1617.7            0
%           400          365          200          200       327.56         1543            0
%           365          375          200          192       321.16       1215.5            0
%           375          375          192          200       306.67        894.3            0
%           375          350          200          200       274.87       587.63            0
%           350          400          200          200       9.7569       312.76            0
%           400          350          200          200       265.43          303            0
%           350          390          200          192       37.571       37.571            0
% 
% second iteration:
% [maxOut,newPath]=ApplyPOACreateNewPathTwoReservoirs(newPath2,upsDry,dwnsDry,20,400,350,200,160,1,325,325,4.11,3.4)
% ---------------------------------------------------------------------------------------------
% newPath =
% 
%           400          400          200          200       66.247       2060.1            0
%           400          350          200          192       286.37       1993.9            0
%           350          400          192          200            0       1707.5            0
%           400        367.5          200          200       219.85       1707.5            0
%         367.5          400          200          200       8.0825       1487.6            0
%           400        392.5          200          194       246.81       1479.6            0
%         392.5          400          194          160       327.06       1232.7            0
%           400          400          160          168       296.13       905.69            0
%           400          350          168          184       306.56       609.56            0
%           350          400          184          200            0          303            0
%           400          350          200          200       265.43          303            0
%           350          390          200          192       37.571       37.571            0

% tirth iteration:
% [maxOut,newPath]=ApplyPOACreateNewPathTwoReservoirs(newPath2,upsDry,dwnsDry,20,400,350,200,160,1,325,325,4.11,3.4)
% ---------------------------------------------------------------------------------------------
% newPath =
% 
%           400          400          200          200       66.247       1952.1            0
%           400          370          200          200       213.43       1885.8            0
%           370          350          200          166       177.07       1672.4            0
%           350          400          166          200            0       1495.3            0
%           400        392.5          200          200        116.6       1495.3            0
%         392.5        362.5          200          200       302.66       1378.7            0
%         362.5          350          200          182       302.42       1076.1            0
%           350        357.5          182          184          260       773.65            0
%         357.5          350          184          170       210.65       513.66            0
%           350          400          170          200            0          303            0
%           400          350          200          200       265.43          303            0
%           350          390          200          192       37.571       37.571            0



function [maxOut,finalPath]=ApplyPOACreateNewPathTwoReservoirs(completePath,runoffUpArray,runoffDwnArray,numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn)
format shortG;
pathUp = completePath(:,2); % the path for upstream reservoir
pathDwn = completePath(:,4);% the path for downstream reservoir
maxIn=0;
% path format:
% [hUpBeg,hUpEnd,hDwnBeg,hDwnEnd,totalPow,cumulativePow,finalh1Dwn]

newPath=zeros(size(completePath));


numberStages = 12/stageSize; % stageSize must be a fractional: 1/2 or 1/5 etc.
runoffUp=repelem(runoffUpArray,numberStages/12);
runoffDwn=repelem(runoffDwnArray,numberStages/12);



% backward
for i=size(pathUp):-1:3
    % 1. TOMA TRES PUNTOS EN LA TRAYECTORIA ORIGINAL
    h1Up=pathUp(i);
    h0Up=pathUp(i-2);
    runoffUpBeg=runoffUp(i);
    runoffUpEnd=runoffUp(i-1);
    h1Dwn=pathDwn(i);
    h0Dwn=pathDwn(i-2);
    runoffDwnBeg=runoffDwn(i);
    runoffDwnEnd=runoffDwn(i-1);
    % fix begin and end, up and dwn and tries every options in the middle
    % to find max
    % finRes format: [hUp,h1Up,hDwn,h1Dwn,powerSumFixEnd,finalh1DwnFixEnd,h0Up,hUp,h0Dwn,hDwn,powerSumFixBeg,finalh1DwnFixBeg];
    % 2. CALCULA EL MAXIMO EN LA TRIADA DE PUNTOS ACTUAL
    [maxOut,finRes]=POAFixedEndAndBegOneStep(numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,h0Up,h1Up,h0Dwn,h1Dwn,runoffUpBeg,runoffUpEnd,runoffDwnBeg,runoffDwnEnd,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,maxIn);
    % RESULTS FORMAT:
    % [hUp,h1Up,hDwn,h1Dwn,powerSumFixEnd,finalh1DwnFixEnd,h0Up,hUp,h0Dwn,hDwn,powerSumFixBeg,finalh1DwnFixBeg]
    pathUp(i-1)=finRes(1); % found new points replace old ones
    pathDwn(i-1)=finRes(3);
    %new trajectory at i and i-1 points
    newPathLinei = [finRes(1),finRes(2),finRes(3),finRes(4),finRes(5)];
    newPathLinei_1=[finRes(7),finRes(8),finRes(9),finRes(10),finRes(11)];
    %newRes=[finRes(2),finRes(3),finRes(5),finRes(6),maxOut,maxIn+maxOut];
    % 3. ACTUALIZA LA TRAYECTORIA
    newPath(i,1:5)=newPathLinei;
    newPath(i-1,1:5)=newPathLinei_1; 
    maxIn=maxOut;
end
newPath(1,1:5)=completePath(1,1:5);

% compute acumulative power
powers = newPath(:,5)/10000;
limit = size(powers);
limit=limit(1);
cumulativePowerSum = zeros(limit,1);
for i=limit:-1:1
    if i==limit
        cumulativePowerSum(i)=powers(i);
    else
        cumulativePowerSum(i)=powers(i)+cumulativePowerSum(i+1);
    end
end
newPath(:,6)=cumulativePowerSum;


upPath=newPath(:,2);
dwnPath=newPath(:,4);
length=size(upPath);
length=length(1);
upPath(2:length+1)=upPath;
dwnPath(2:length+1)=dwnPath;
upPath(1)=newPath(1,1);
dwnPath(1)=newPath(1,3);


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

        newh=v2hUpstream(spillhUp);
        if newh >= dwCorridorUp(i)
            upPath(i)=newh;
        elseif newh < dwCorridorUp(i)
            upPath(i)=dwCorridorUp(i);
        end
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
        
        newh=v2hDownstream(spillhDwn);
        if newh >= dwCorridorDwn(i)
            dwnPath(i)=newh;
        elseif newh < dwCorridorDwn(i)
            dwnPath(i)=dwCorridorDwn(i);
        end
       
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



% original path 
initialPathUp = completePath(:,2);
initialPathDwn = completePath(:,4);
% length=size(initialPathUp);
% initialPathUp(2:length+1)=initialPathUp;
% initialPathDwn(2:length+1)=initialPathDwn;
% initialPathUp(1)=completePath(1,1);
% initialPathDwn(1)=completePath(1,3);

finalPathUp = finalPath(:,2);
finalPathDwn = finalPath(:,4);
% finalPathUp(2:length+1)=finalPathUp;
% finalPathDwn(2:length+1)=finalPathDwn;
% finalPathUp(1)=finalPath(1,1);
% finalPathDwn(1)=finalPath(1,3);



length = size(initialPathUp);
length = length(1);
equiz = (1:length)';

figure(1)
plot(equiz, initialPathUp);
hold;
plot(equiz, finalPathUp);
title('Upstream reservoir trajectory');
%text(equiz, upLine,labels)
grid on;
xlim([0 length+1]);
ylim([hEndRangeUp-5 hBegRangeUp+5]);
legend('Initial trayectory','Improved trayectory via POA');
hold off

figure(2)
plot(equiz, initialPathDwn);
title('Downstream reservoir trajectory')
%text(equiz, upLine,labels)
hold
plot(equiz, finalPathDwn);
grid on;
xlim([0 length+1]);
ylim([hEndRangeDwn-5 hBegRangeDwn+5]);
legend('Initial trayectory','Improved trayectory via POA');
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
normlizedRunoffUp=(runoffUp*720*60*60*stageSize)/1000000000;
figure(3)
plot(equiz, turbOutUpH);
title('Upstream output volumes')
%text(equiz, upLine,labels)
hold
plot(equiz, spilledVolUpH);
plot(equiz, normlizedRunoffUp);
plot(equiz, turbLimitUpH);
grid on;
xlim([0 length+1]);
legend('Turbines output','Spilled volume','runoff','Turbines capacity')
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



% 
% % original path 
% initialPathUp = completePath(:,2);
% finalPathUp = newPath(:,2);
% initialPathDwn = completePath(:,4);
% finalPathDwn = newPath(:,4);
% 
% 
% length = size(initialPathUp);
% length = length(1);
% equiz = (1:length)';
% 
% figure(1)
% plot(equiz, initialPathUp);
% hold;
% plot(equiz, finalPathUp);
% title('Upstream reservoir trajectory');
% %text(equiz, upLine,labels)
% grid on;
% xlim([0 length+1]);
% ylim([hEndRangeUp-5 hBegRangeUp+5]);
% legend('Initial trayectory','Improved trayectory via POA');
% hold off
% 
% figure(2)
% plot(equiz, initialPathDwn);
% title('Downstream reservoir trajectory')
% %text(equiz, upLine,labels)
% hold
% plot(equiz, finalPathDwn);
% grid on;
% xlim([0 length+1]);
% ylim([hEndRangeDwn-5 hBegRangeDwn+5]);
% legend('Initial trayectory','Improved trayectory via POA');
% hold off