% it test 400 - h -390 where h vary from 400 to 350


%       runoff    398              178
%      ---------------------------------------
% %      h0               h               h1
% %    ---------------------------------------
%    fx * 400 ---------- 400 -            400               
%         
%         395   \------- 395 --\          395               
%         
%         390     \----  390 ----\----    390   * fx-end
%         
%         385      ...   385 --------/    385
% 
%         380            380 ------/      380
%     
%         375            375   ...        375
%         
%         370            370              370
%         
%         365            365              365
%         
%         360            360              360
%         
%         355            355              355
%         
%         350          \-350-/            350
% =====================================================

%       runoff    131              59
% %      h0               h               h1
% %    ---------------------------------------
%    fx * 200             200             200
%         
%         196             196             196
%         
%         192             192             192   * fx-end
%         
%         188             188             188
% 
%         184             184             184
%     
%         180             180             180
%         
%         176             176             176
%         
%         172             172             172
%         
%         168             168             168
%         
%         164             164             164
%         
%         160             160             160
% =====================================================

%EXAMPLE:
% inputs:
% -10 divisions for central point h: [h0, h, h1]
% -Upstream reservoir h limits = [from 400 to 350](m)
% -Downstream reservoir h limits = [from 200 to 160](m)
% -fixed begining and end point for upstream reservoir: [400 h 390] (here h
% will vary between h limits
% -fixed begining and end point for downstream reservoir: [200 h 192] (here h
% will vary between h limits
% -runoff's upstream for fixed begining: 398 (m3/s)
% -runoff's upstream for fixed end: 178 (m3/s)
% -runoff's downstream for fixed begining: 131 (m3/s)
% -runoff's downstream for fixed end: 59 (m3/s)
% -stage length: 1 month
% -upstream turbines limits: 225 (m3/s)
% -downstream turbines limits: 225 (m3/s) **Note: 325 makes reservoirs emty
% -storage reservoir limites upstream, downstream respectively: 4.11, 3.4
% (m3)E09
%
% [maxOut,finRes]=POAFixedEndAndBegOneStep(10,400,350,200,160,400,390,200,192,398,178,131,59,1,225,225,4.11,3.4,0)
% maxOut =
%       269.97
% finRes =
% h0Up  hUp  h1Up  h0Dwn  hDwn h1Dwn powBeg    powEnd  powSum  cumulativePow
% 400   370   390   200   200   192   239.78   30.193   269.97   269.97

          


function [maxParcialOut,finRes]=POAFixedEndAndBegOneStep(numDiv,hBegRangeUp,hEndRangeUp,hBegRangeDwn,hEndRangeDwn,begUpFixed,endUpFixed,begDwnFixed,endDwnFixed,runoffUpBeg,runoffUpEnd,runoffDwnBeg,runoffDwnEnd,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,maxIn)
format shortG;
sizeDivUp = (hBegRangeUp - hEndRangeUp)/numDiv;
sizeDivDwn = (hBegRangeDwn - hEndRangeDwn)/numDiv;
maxTotalOut=0;
maxParcialOut=0;

% 1. CALCULA DE ADELANTE HACIA ATRAS
for hUp=hBegRangeUp:-sizeDivUp:hEndRangeUp
    h0Up=begUpFixed;
    h1Up=endUpFixed;
    
    % 0 aditional inputs to upstream reservoir
    % computes power from fixed begining to h
    % and from h to fixed end
    % 2. BALANCE DE VOLUMEN ENTRE t-1, t (AGUAS ARRIBA)
    %turbinesOutflowUp,spilledVol,powerUp,totaLOutUp,realh1Up
    [turbOutUpBeg,spillVolUpBeg,powerUpFixBeg,totaLOutUpFixBeg,finalh1UpFixBeg]=computePowerUpstream(h0Up,hUp,runoffUpBeg,0,stageSize,turbLimitUp,resCapacityUp);
    % 2.1 BALANCE DE COLUMEN ENTRE t y t+1 (AGUAS ARRIBA)
    [turbOutUpEnd,spillVolUpEnd,powerUpFixEnd,totaLOutUpFixEnd,finalh1UpFixEnd]=computePowerUpstream(hUp,h1Up,runoffUpEnd,0,stageSize,turbLimitUp,resCapacityUp);
        
    % last data stay fixed to review all possible combinations in
    % downstream
    for hDwn=hBegRangeDwn:-sizeDivDwn:hEndRangeDwn
        h0Dwn=begDwnFixed;
        h1Dwn=endDwnFixed;
        
        % comptues power from fixed begining to h
        % and from h to fixed end.
        % 3. BALANCE DE VOLUMEN ENTRE t-1, t y t+1 (AGUAS ABAJO)
        [turbOutDwnBeg,spillVolDwnBeg,powerDwnFixBeg,totaLOutDwnFixBeg,finalh1DwnFixBeg]=computePowerDownstream(h0Dwn,hDwn,runoffDwnBeg,totaLOutUpFixBeg,stageSize,turbLimitDwn,resCapacityDwn);
        [turbOutDwnEnd,spillVolDwnEnd,powerDwnFixEnd,totaLOutDwnFixEnd,finalh1DwnFixEnd]=computePowerDownstream(hDwn,h1Dwn,runoffDwnEnd,totaLOutUpFixEnd,stageSize,turbLimitDwn,resCapacityDwn);

        % sum power in the begining and end
        powerSumFixEnd = powerUpFixEnd+powerDwnFixEnd;
        powerSumFixBeg = powerUpFixBeg+powerDwnFixBeg;

        % total power in both stages
        %currentPowerSum=powerSumFixEnd+powerSumFixBeg;
        % maxIn corresponds only for the end stage, it is not for both
        % stages here considerated since in the next step, beggining stage
        % turns on end stage for next computation
        % 4. GUARDA EL MAXIMO ACTUAL ENCONTRADO
        totalPowerSum=(maxIn + powerSumFixBeg + powerSumFixEnd);
        
        %resArray=[powerUpFixBeg,powerDwnFixBeg,powerUpFixEnd,powerDwnFixEnd,powerSumFixBeg,powerSumFixEnd,currentPowerSum];
        %disp(resArray);
        
        %res=[h0Up,hUp,h1Up,h0Dwn,hDwn,h1Dwn,powerSumFixBeg,powerSumFixEnd,currentPowerSum,cumulativePowerSum];
        % this result is for rebuild the new path with the same format.
        resModified = [hUp,h1Up,hDwn,h1Dwn,powerSumFixEnd,finalh1DwnFixEnd,h0Up,hUp,h0Dwn,hDwn,powerSumFixBeg,finalh1DwnFixBeg];
        %disp(resModified);
        % cumulative power must be optimized
        if totalPowerSum > maxTotalOut
            maxTotalOut = maxIn + powerSumFixBeg + powerSumFixEnd;
            %partial sum considers the end sum, and it is used as
            %cumulative for the next cycle. This is updatet via maxIn
            maxParcialOut = maxIn + powerSumFixEnd;
            finRes = resModified;
        end;
    end;

end;



    