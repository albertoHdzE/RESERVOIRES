% supposing upDwnPaths contains the backwards trayectory found, and all
% data as turbine outflow and spilled volumens were already computed in the
% forward iteration. Then, upDwnPath contains initial and final trajectory,
% where final one is taken as the starting or ending points of the initial
% trajectory.

%    h0u h1u h0d h1d
%-------------------
%1.  400 365 200 180       
%2.  400 365 200 180       
%3.  400 365 200 180       
%4.  400 390 200 184       
%5.  400 400 200 200       
%6.  400 400 200 200       
%7.  400 390 200 188       
%8.  400 370 200 180       
%9.  400 365 200 180       
%10. 400 375 200 180       
%11. 400 375 200 180       
%12. 400 360 200 180       

% x= 1 , 2 , 2 , 3 , 3 , 4 , 4 , 5 , 5 , 6 , 6 , 7 , 7 , 8 , 8 , 9 , 9 , 10, 10, 11, 11, 12, 12, 13 
% y=400,365,400,365,400,365,400,390,400,400,400,400,400,390,400,370,400,365,400,375,400,375,400,360
% l= 1-24

% 400--0--0--0--0--0--0--0--0--0--0--0--0--|
% 395--|--|--|--|--|--|--|--|--|--|--|--|--|
% 390--|--|--|--|--0--|--|--0--|--|--|--|--|
% 385--|--|--|--|--|--|--|--|--|--|--|--|--|
% 380--|--|--|--|--|--|--|--|--|--|--|--|--|
% 375--|--|--|--|--|--|--|--|--|--|--0--0--|
% 370--|--|--|--|--|--|--|--|--0--|--|--|--|
% 365--|--0--0--0--|--|--|--|--|--0--|--|--|
% 360--|--|--|--|--|--|--|--|--|--|--|--|--0
% 355--|--|--|--|--|--|--|--|--|--|--|--|--|
% 350--|--|--|--|--|--|--|--|--|--|--|--|--|
%      1  2  3  4  5  6  7  8  9 10 11 12 13 --> 13 starting points for
%        1  2  3  4  5  6  7  8  9 10 11 12      12 stages



%    h0u h1u h0d h1d
%-------------------
%0    |->400   ---> starting added when endings are choosen
%1.  400 365 
%2.  400 365 
%3.  400 365 
%4.  400 390 
%5.  400 400 
%6.  400 400 
%7.  400 390 
%8.  400 370 
%9.  400 365 
%10. 400 375 
%11. 400 375        
%12. 400 360 --> fixed-end substitute the end found in backwards iteration
%13  390<-| --> fixed-end is added when starting are choosen

function plotFlowBehaviour(upDwnPaths,finalBegOpt,finalEndOpt,turbOutUpH,spilledVolUpH,turbOutDwnH,spilledVolDwnH,runoffArrayUp,runoffArrayDwn,turbLimitUp,noTurbUp,turbLimitDwn,noTurbDwn,stageSize,fixedEndUp,fixedEndDwn,hEndUp,hBegUp,hEndDwn,hBegDwn,inputsDwn)


numberStages = 12/stageSize; % stageSize must be a fractional: 1/2 or 1/5 etc.
runoffUp=repelem(runoffArrayUp,numberStages/12);
runoffDwn=repelem(runoffArrayDwn,numberStages/12);

% constant turbines limits along the time
turbLimitUpH=ones(size(runoffUp))*((turbLimitUp*720*60*60*stageSize)/1000000000)*noTurbUp;
turbLimitDwnH=ones(size(runoffUp))*((turbLimitDwn*720*60*60*stageSize)/1000000000)*noTurbDwn;


length=size(upDwnPaths);
length=length(1);

% STARTING POINTS = TRAJECTORY
if finalBegOpt==1 && finalEndOpt==0
    pathUp=upDwnPaths(:,1);
    pathUp(length+1)=fixedEndUp;
    pathDwn=upDwnPaths(:,3);
    pathDwn(length+1)=fixedEndDwn;
end

% ENDING POINTS = TRAJECTORY
if finalEndOpt==1 && finalBegOpt==0
    pathUp(2:length+1)=upDwnPaths(:,2);
    pathDwn(2:length+1)=upDwnPaths(:,4);
    pathUp(1)=upDwnPaths(1,1);
    pathDwn(1)=upDwnPaths(1,3);
end

% length=size(pathUp);
% length=length(1);
% plotting initial trajectories ----UPWARDS
% (initial) path for Upstream
initialYPathUp = zeros(1,length*2);
counter = 0;
for i=1:2:length*2
    counter = counter + 1;
    initialYPathUp(i) = upDwnPaths(counter,1);
    initialYPathUp(i+1)=upDwnPaths(counter,2);
end

initialXPathUp=zeros(1,length*2);
% x starts with 1 and ends withs length
initialXPathUp(1)=1;
initialXPathUp(length*2)=length+1;
% x is filled of repetitions of numbers
counter = 0;
for i=2:length    
    counter = counter + 2;
    initialXPathUp(counter)=i;
    initialXPathUp(counter+1)=i;
end



% plotting initial trajectories ----BACKWARDS
% (initial) path for Upstream
initialYPathDwn = zeros(1,length*2);
counter = 0;
for i=1:2:length*2
    counter = counter + 1;
    initialYPathDwn(i) = upDwnPaths(counter,3);
    initialYPathDwn(i+1)=upDwnPaths(counter,4);
end

initialXPathDwn=zeros(1,length*2);
initialXPathDwn(1)=1;
initialXPathDwn(length*2)=length+1;

counter = 0;
for i=2:length-1
    counter = counter + 2;
    initialXPathDwn(counter)=i;
    initialXPathDwn(counter+1)=i;
end


% removing iteration from 0 to 1 point (X Coordinates)
% removing iteration from 0 to 1 point (Y coordinates)
%if chooseBeg==1
%     initialYPathUp(1:2)=[];
%     initialXPathUp(1:2)=[];
%     initialYPathDwn(1:2)=[];
%     initialXPathDwn(1:2)=[];
%end


length = size(pathUp);
length = length(1);
equiz = (1:length)';


% if labels over points are required.
% labels = cellstr (num2str(finalPathUp));

% INITIAL TRAJECTORY UPSTREAM
% ---------------------------
figure(1)
plot(equiz, pathUp);
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
plot(equiz, pathDwn);
title('Downstream reservoir trajectory')
%text(equiz, upLine,labels)
hold
plot(initialXPathDwn, initialYPathDwn);
grid on;
xlim([0 length+1]);
ylim([hEndDwn-5 hBegDwn+5]);
legend('forward iteration','backward iteration')
hold off


equiz=(1:size(turbOutUpH));
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

