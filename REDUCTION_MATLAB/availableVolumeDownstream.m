% computes total volume available to produce power
% in upstream reservoir.
% This is the difference between the begining-h and end-h
% as volume in m3 E09 plus inputs. This last, ussualy
% runoff data.
% vol is in m3 E09


function av=availableVolumeDownstream(h0,h1,runoff,otherInputs,stageSize)

v0=h2vDownstream(h0);
v1=h2vDownstream(h1);

seconds = stageSize * 30 * 24 * 60 * 60; % months to seconds
runoffVol = (seconds * runoff)/1000000000; %(m3/s) -> (m3/s) E09

av = v0-v1+runoffVol+otherInputs;
