%-------------------------- EXAMPLE (dry year) ------------------------
% upsDry=[208,228,235,608,1431,1157,669,280,216,404,398,178];
% dwnsDry=[69,75,77,200,471,381,291,93,71,133,131,59];
% iniPathDry=MDPinitialOperationTrajectoryFixedBeg(upsDry,dwnsDry,10,400,350,200,160,1,150,150,4.11,3.4)
% 
% ans =
% 
%           390          365          192          192       152.85       152.85       194.16
%           365          350          192          184       114.09       266.94       186.87
%           350          350          184          168       81.034       347.98       168.03
%           350          350          168          180       129.65       477.62       179.51
%           350          400          180          200       150.56       628.18       200.14
%           400          400          200          200       168.41       796.59       202.96
%           400          400          200          200       168.41       964.99       202.96
%           400          380          200          200       163.31       1128.3       202.96
%           380          350          200          200       150.56       1278.9       202.36
%           350          350          200          196       115.69       1394.5       197.99
%           350          350          196          192       112.84       1507.4       193.18
%           350          350          192          172        77.06       1584.4        174.7

function path=MDPinitialOperationTrajectoryFixedBeg(runoffArrayUp,runoffArrayDwn,numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn)
grid on;
path=zeros(12,11);
max=0;

%FIXED STARTING POINTS
beggUpFixed = 400;
beggDwnFixed = 200;

% COMPUTING NUMBER OF STAGES
numberStages = 12/stageSize; % stageSize must be a fractional: 1/2 or 1/5 etc.
runoffUp=runoffArrayUp;
runoffDwn=runoffArrayDwn;
runoffUp=repelem(runoffUp,(numberStages/12));
runoffDwn=repelem(runoffDwn,(numberStages/12));

%FORWARD ->
for j=1:numberStages
    
    [max,finRes]=foundMaxTwoReservoirsOneStageFixedBeg(numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,beggUpFixed,beggDwnFixed,runoffUp(j),runoffDwn(j),stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,max);
%     if finRes(2) >= hEndRangeUp && finRes(4) >= hBegRangeDwn
        path(j,:)=finRes;
        % FINAL points are FIXED
        beggUpFixed=finRes(2);
        beggDwnFixed=finRes(4);
%     end
%     disp('****************************************************');
%     disp(path(j,:))
%     disp('****************************************************');
end

upLine = path(:,1);
dwnLine = path(:,3);
length = size(path);
length = length(1);
equiz = (1:length)';
figure(1);
labels = cellstr (num2str(upLine));
plot(equiz, upLine);
%text(equiz, upLine,labels)
hold
grid on;
xlim([1 length]);
ylim([hEndRangeUp-5 hBegRangeUp+5]);
hold off


figure(2);
plot(equiz, dwnLine);
hold
grid on;
xlim([1 length]);
ylim([hEndRangeDwn-5 hBegRangeDwn+5]);
hold off



%disp(path);
