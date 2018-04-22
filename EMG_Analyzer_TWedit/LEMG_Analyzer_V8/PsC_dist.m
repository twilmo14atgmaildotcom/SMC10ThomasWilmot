function d = PsC_dist(X,Y)
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

lag = 0;
d = zeros(1,size(Y,1));

  for i = 1:size(Y,1)
    d(i) = PsC(X,Y(i,:),lag);
    d(i) = 1 - d(i);
  end


end