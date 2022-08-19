% computes total volume from runoff average data
% - stage Size is the size of time considered for computation
%   usually expressed in months.
% - runoff data in runoff monthly average data.
% - vol is expressed in (m3)E09, this is, millions of m3


function vol=runoffVolume(stageZise, runoffData)
sec = stageZise * 30 * 24 * 3600; % seconds in stage size
vol = (runoffData * sec)/1000000000; %vol in m3 E09
