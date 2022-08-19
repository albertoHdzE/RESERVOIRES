% upsDry=[208,228,235,608,1431,1157,669,280,216,404,398,178];
% dwnsDry=[69,75,77,200,471,381,291,93,71,133,131,59];
% [ini, fin]=MDPinitialOperationTrajectory(upsDry,dwnsDry,10,400,350,200,160,390,192,1,150,150,4.11,3.4)
% [backNewPath,forNewPath]=IMDPImprovingPathTwoReservoirs(fin,8,5,4,10,10,400,350,200,160,390,192,upsDry,dwnsDry,1,325,325,4.11,3.4)

function [backNewPath,forNewPath]=IMDPImprovingPathTwoReservoirs(fullInitialPath,corridorSize,unitSizeUp,unitSizeDwn,numDivh0,numDivh1,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,fixUpEnd,fixDwnEnd,runoffUpArray,runoffDwnArray,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn)
format shortG;

length=size(fullInitialPath);
length=length(1);
maxIn=0;

% original initial Path to be improved
initialh0PathUp = zeros(1,length+1);
initialh0PathUp(1,1) = fullInitialPath(1,1);
initialh0PathUp(2:length+1) = fullInitialPath(:,2)';

initialh0PathDwn = zeros(1,length+1);
initialh0PathDwn(1,1) = fullInitialPath(1,3);
initialh0PathDwn(2:length+1) = fullInitialPath(:,4)';

% new path forward iteration
forNewPath=zeros(length,12);
forNewPath(length,:)=fullInitialPath(length,:);

% new backward path iteration
backNewPath = zeros(length,7); %only for initial trajectory

% saving corridors
upCorridorUp=zeros(1,length);
dwCorridorUp=zeros(1,length);
upCorridorDwn=zeros(1,length);
dwCorridorDwn=zeros(1,length);

numberStages = 12/stageSize; % stageSize must be a fractional: 1/2 or 1/5 etc.
runoffUp=repelem(runoffUpArray,numberStages/12);
runoffDwn=repelem(runoffDwnArray,numberStages/12);

%BACKWARD
for i=length+1:-1:2
    % APLICACIÓN DE MDP CON DIFERENTES LIMITES
    
%      initial=[initialh0PathUp(i-1),initialh0PathUp(i),initialh0PathDwn(i-1),initialh0PathDwn(i)];
%      disp('--------------');  
%      disp(strcat('initialValues: ',num2str(initial)));
    
    [maxOut,finRes,cCoorUp,cCoorDwn]=IMDPOneStageTwoReservoirs(initialh0PathUp(i-1),initialh0PathUp(i),initialh0PathDwn(i-1),initialh0PathDwn(i),corridorSize,unitSizeUp,unitSizeDwn,numDivh0,numDivh1,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,runoffUp(i-1),runoffDwn(i-1),stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,maxIn);
    maxIn = maxOut;
    
    % updating new beegginings
    initialh0PathUp(i)=finRes(2);
    initialh0PathDwn(i)=finRes(4);
    
%      final=[initialh0PathUp(i-1),initialh0PathUp(i),initialh0PathDwn(i-1),initialh0PathDwn(i)];
%      disp(strcat('finalValues: ',num2str(final)));
    
    
    % corridor is computed on original points, not over new points
    
%     upCorridorUp(i-2) = cCoorUp(1); % h0 begining
%     dwCorridorUp(i-2) = cCoorUp(2); % h0 end
    upCorridorUp(i-1) = cCoorUp(3); % h0 begining
    dwCorridorUp(i-1) = cCoorUp(4); % h0 end 
    
    
%     upCorridorDwn(i-1) = cCoorDwn(1);
%     dwCorridorDwn(i-1) = cCoorDwn(2);
    upCorridorDwn(i-1) = cCoorDwn(3);
    dwCorridorDwn(i-1) = cCoorDwn(4);
    
%     corridors = [cCoorUp(3),cCoorUp(4),cCoorDwn(3),cCoorDwn(4)];
%     disp(strcat('CORRIDORS: ',num2str(corridors)));

    backNewPath(i-1,:)=finRes;
end


%forward
upPath = backNewPath(:,2);
dwnPath = backNewPath(:,4);

length=size(upPath);
length=length(1);
upPath(2:length+1)=upPath(1:length);
dwnPath(2:length+1)=dwnPath(1:length);
upPath(1)=backNewPath(1,1);
dwnPath(1)=backNewPath(1, 3);

inputsUp=0;
cumPow=0;

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
        forNewPath(i-1,:)=[res,totaLOutUp2];
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
        forNewPath(i-1,:)=[res,totaLOutUp2];
        %update current stage
        [turbinesOutflowDwn,spilledVolDwn,powerDwn,totaLOutDwn,realh1Dwn]=computePowerDownstream(dwnPath(i),dwnPath(i+1),runoffDwn(i),totaLOutUp,stageSize,turbLimitDwn,resCapacityDwn);
    end
    % FORCE TO DO NOT SPILL WATER
     % -----------------------------END
    
    
    genPow=(powerUp+powerDwn)/1000000;
    cumPow =cumPow+genPow ;
    res = [upPath(i), upPath(i+1), dwnPath(i), dwnPath(i+1), genPow, cumPow, realh1Dwn,turbinesOutflowUp,spilledVolUp,turbinesOutflowDwn,spilledVolDwn,totaLOutUp];
    forNewPath(i,:)=res;
end

% plotting--------------
finalPathUp = forNewPath(:,2);
finalPathDwn = forNewPath(:,4);

length = size(finalPathUp);
length = length(1);
equiz = (1:length)';
labels = cellstr (num2str(finalPathUp));


figure(1)
plot(equiz, upCorridorUp,'color', 'black');
hold

title('Upstream reservoir trajectory');
%text(equiz, upLine,labels)

plot(equiz, dwCorridorUp,'color', 'black');
plot(equiz, finalPathUp, 'color', 'red');
grid on;
xlim([0 length+1]);
ylim([hEndRangeUp-5 hBegRangeUp+5]);
legend('Upper corridor limit','Lower corridor limit','Improved trayectory');
hold off


figure(2)
plot(equiz, upCorridorDwn,'color', 'black');
hold

title('Downstream reservoir trajectory')
plot(equiz, dwCorridorDwn,'color', 'black');
plot(equiz, finalPathDwn, 'color', 'red');
%text(equiz, upLine,labels)
hold
grid on;
xlim([0 length+1]);
ylim([hEndRangeDwn-5 hBegRangeDwn+5]);
legend('Upper corridor limit','Lower corridor limit','Improved trayectory');
hold off


% Turbines output and spilled Vols
turbOutUpH = forNewPath(:,8);
spilledVolUpH=forNewPath(:,9);
turbOutDwnH = forNewPath(:,10);
spilledVolDwnH=forNewPath(:,11);

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
inputsDwn=forNewPath(:,12);
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

% newPath(:,1)=initialh0PathUp;
% newPath(:,3)=initialh0PathDwn;

% % plotting--------------
% iniPathUp = fullInitialPath(:,1);
% iniPathDwn = fullInitialPath(:,3);
% length = size(iniPathUp);
% length = length(1);
% equiz = (1:length)';
% labels = cellstr (num2str(iniPathUp));
% plot(equiz, iniPathUp);
% %text(equiz, upLine,labels)
% hold
% plot (equiz,initialh0PathUp);
% grid on;
% xlim([1 length]);
% ylim([hEndRangeUp-5 hBegRangeUp+5]);
% hold off