function [loc,new_sig] = findspikes(template,sig,locs,Fs,TH)
%% Uses Psuedo Correlation for spike Classification
% NOTE: USES PsC_Mex for fast clustering
%% Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull

loc = false(1,length(locs));
lag = round(0.0002*Fs); %lag (def was 0.0002)

  for i = 1:length(locs)
    tmp = sig(i,:);
    [PsC_s,~] = PsC_mex(template,tmp,lag);
    if PsC_s >= TH
         loc(i) = 1;
         sig(i,:) = sig(i,:) - template;
    end
  end
  
  new_sig = sig;


  

end