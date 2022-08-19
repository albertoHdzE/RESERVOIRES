% computes total volume available to produce power
% in upstream reservoir.
% This is the difference between the begining-h and end-h
% as volume in m3 E09 plus inputs. This last, usually
% runoff data.
% vol is in m3 E09


function av=availableVolumeUpstream(h0,h1,runoff,otherInputs,stageSize)

% 1. DIFERENCIA DE VOLUMEN ENTRE m1 y m2
v0=h2vUpstream(h0); % convierte h a m3
v1=h2vUpstream(h1);

% 2. OBTENCIÓN DE VOLUMENES
seconds = stageSize * 30 * 24 * 60 * 60; % months to seconds
runoffVol = (seconds * runoff)/1000000000; %(m3/s) -> (m3)E09 by stagesize

% 3. CALCULO DE VOLUMEN DISPONIBLE EN EL PERIODO DE TIEMPO COMPRENDIDO
av = v0-v1+runoffVol+otherInputs; % diferencia de alturas + escurriemitos
















