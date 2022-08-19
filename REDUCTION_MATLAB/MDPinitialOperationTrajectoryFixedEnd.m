% EXAMPLE 1 (dry year)
% upsDry=[208,228,235,608,1431,1157,669,280,216,404,398,178];
% dwnsDry=[69,75,77,200,471,381,291,93,71,133,131,59];
% initialOperationTrajectoryFixedEnd(upsDry,dwnsDry,10,400,350,200,160,1,325,325,4.11,3.4)
% EXAMPLE 2 (normal year)
% upsNorm=[172,312,426,258,529,1772,1716,1800,541,2305,642,427];
% dwnsNorm=[57,106,140,84,174,582,563,591,178,758,212,140];
% initialOperationTrajectoryFixedEnd(upsNorm,dwnsNorm,10,400,350,200,160,1,325,325,4.11,3.4)
% EXAMPLE 3 (wet year)
% upsWet=[244,266,346,761,912,1826,6193,1552,2730,2452,697,174];
% dwnsWet=[81,88,114,250,301,601,2036,511,898,806,230,57];
% MDPinitialOperationTrajectoryFixedEnd(upsDry,dwnsDry,10,400,350,200,160,1,200,350,4.11,3.4)

function path=MDPinitialOperationTrajectoryFixedEnd(runoffArrayUp,runoffArrayDwn,numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn)
path=zeros(12,7);
max=0;
endTUp = 380;
endTDwn = 184;
%Backward
for j=12:-1:1
    [max,finRes]=foundMaxTwoReservoirsOneStageFixedEnd(numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,endTUp,endTDwn,runoffArrayUp(j),runoffArrayDwn(j),stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,max);
    path(j,:)=finRes;
    endTUp=finRes(1);
    endTDwn=finRes(3);
%     disp('****************************************************');
%     disp(path(j,:))
%     disp('****************************************************');
end


upLine = path(:,1);
dwnLine = path(:,3);
length = size(path);
length = length(1);
equiz = (1:length)';
labels = cellstr (num2str(upLine));
plot(equiz, upLine);
%text(equiz, upLine,labels)
hold
grid on;
xlim([1 length]);
ylim([hEndRangeUp-5 hBegRangeUp+5]);
hold off
%disp(path);