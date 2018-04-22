function [runTEO,tmp] = MTEO(rawSignal, ks, FiltFl)
%% Implements the MTEO detector according to 
%Note this is from => urut/april07
%% Inputs:
% rawSignal: raw signal
% ks : levels of MTEO
% FiltFL : Filter Flag, set zero to avoid filtering
%% Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull

if nargin < 3
    FiltFl = 1;
end


L = length(ks);
rawSignal = rawSignal(:);
tmp=zeros(L,length(rawSignal));
v = zeros(L,1);
for i=1:length(ks)
    tmp(i,:) = runningTEO(rawSignal, ks(i));
    % Filter flag
    if FiltFl
    v(i) = var(tmp(i,:));
    %apply the window
    win = hamming( 4*ks(i)+1, 'symmetric');
    tmp(i,:) = filtfilt( win,1,tmp(i,:))./(v(i)); %def was v unsquared
    end
    
end

 if i > 1
 runTEO = sum(tmp); %runTEO + tmp./v(i);
 %runTEO = max(tmp);
 else
 runTEO = tmp(i,:);  
 end
 
end

