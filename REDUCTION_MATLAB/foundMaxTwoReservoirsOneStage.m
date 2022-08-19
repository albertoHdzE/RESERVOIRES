% EXAMPLE:
% inputs:
% -10 divisions
% -Upstream reservoir h limits = [from 400 to 350](m)
% -Downstream reservoir h limits = [from 200 to 160](m)
% -runoff's upstream: 178 (m3/s)
% -runoff's downstream: 59 (m3/s)
% -1 month
% -turbines limits: 325 (m3/s)
% -storage reservoir limites upstream, downstream respectively: 4.11, 3.4
% (m3)E09
% [one,two]=foundMaxTwoReservoirsOneStage(10,400,350,200,160,178,59,1,325,325,4.11,3.4,0)



function [maxOut,finRes]=foundMaxTwoReservoirsOneStage(numDiv,hBegUp,hEndUp,hBegDwn,hEndDwn,runoffUp,runoffDwn,stageSize,turbLimitUp,turbLimitDwn,resCapacityUp,resCapacityDwn,maxIn)
format shortG;
sizeDivUp = (hBegUp - hEndUp)/numDiv;
sizeDivDwn = (hBegDwn - hEndDwn)/numDiv;
maxOut=0;

% (PASOS 1- 3) RECORRE m1 DESDE 1 HASTA M
for h0Up=hBegUp:-sizeDivUp:hEndUp
    for h1Up=hBegUp:-sizeDivUp:hEndUp
        % 0 aditional inputs to upstream reservoir
        [turbinesOutflowUp,spilledVolUp,powerUp,totaLOutUp,finalh1Up]=computePowerUpstream(h0Up,h1Up,runoffUp,0,stageSize,turbLimitUp,resCapacityUp);
        % RECORRE m2 DESDE 1 HASTA M
        for h0Dwn=hBegDwn:-sizeDivDwn:hEndDwn
            for h1Dwn=hBegDwn:-sizeDivDwn:hEndDwn
                % (PASO 4) CALCULA BALANCE DE VOLUMEN ENTRE m1 y m2
                [turbinesOutflowDwn,spilledVolDwn,powerDwn,totaLOutDwn,finalh1Dwn]=computePowerDownstream(h0Dwn,h1Dwn,runoffDwn,totaLOutUp,stageSize,turbLimitDwn,resCapacityDwn);
                generatedPow=powerUp+powerDwn;
                cumPower=maxIn+powerUp+powerDwn;
                res=[h0Up,h1Up,h0Dwn,h1Dwn,generatedPow,cumPower,finalh1Dwn,turbinesOutflowUp,spilledVolUp,turbinesOutflowDwn,spilledVolDwn];
                %disp(res);
                % (PASO 6) ENCUENTRA EL MAXIMO
                if maxIn+powerUp+powerDwn > maxOut
                    maxOut = maxIn+powerUp+powerDwn;
                    finRes = res;
                end;
            end;
        end;
    end;
end;



