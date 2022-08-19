% upsDry=[208,228,235,608,1431,1157,669,280,216,404,398,178];
% dwnsDry=[69,75,77,200,471,381,291,93,71,133,131,59];
% [ini, fin]=initialOperationTrajectory(upsDry,dwnsDry,10,400,350,200,160,390,192,1,150,150,4.11,3.4)
%newPath=IMDPImprovingPathTwoReservoirsFixBeg(fin,4,5,4,10,10,400,350,200,160,upsDry,dwnsDry,1,150,150,4.11,3.4)


function newPath=IMDPImprovingPathTwoReservoirsFixBeg(fullInitialPath,corridorSize,unitSizeUp,unitSizeDwn,numDivh0,numDivh1,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,runoffUpArray,runoffDwnArray,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn)
format shortG;

initialh0PathUp = fullInitialPath(:,1);
initialh0PathDwn = fullInitialPath(:,3);

length=size(initialh0PathUp);
length=length(1);
maxIn=0;

newPath = zeros(length,7);
newPath(length,:)=fullInitialPath(length,:);

for i=1:(length-1)
    [maxOut,finRes]=IMDPOneStageTwoReservoirsFixBeg(initialh0PathUp(i),initialh0PathUp(i+1),initialh0PathDwn(i),initialh0PathDwn(i+1),corridorSize,unitSizeUp,unitSizeDwn,numDivh0,numDivh1,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,runoffUpArray(i),runoffDwnArray(i),stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,maxIn);
    maxIn = maxOut;
    initialh0PathUp(i+1)=finRes(2);
    initialh0PathDwn(i+1)=finRes(4);
    newPath(i,:)=finRes;
end

newPath(:,1)=initialh0PathUp;
newPath(:,3)=initialh0PathDwn;

% plotting--------------
iniPathUp = fullInitialPath(:,1);
iniPathDwn = fullInitialPath(:,3);
length = size(iniPathUp);
length = length(1);
equiz = (1:length)';
labels = cellstr (num2str(iniPathUp));
plot(equiz, iniPathUp);
%text(equiz, upLine,labels)
hold
plot (equiz,initialh0PathUp);
grid on;
xlim([1 length]);
ylim([hEndRangeUp-5 hBegRangeUp+5]);
hold off