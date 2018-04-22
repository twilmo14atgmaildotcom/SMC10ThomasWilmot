function [runMean] = runningAverage( rawSignal, windowSize, mode )
%% Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull

%% Script Begins here, Do not Change
if nargin<3
    mode=1;
end
if mode==1
    runMean = filter( ones(1,windowSize)/windowSize, 1,  rawSignal);
else
    runMean = filtfilt( ones(1,windowSize)/windowSize, 1,  rawSignal);
end


