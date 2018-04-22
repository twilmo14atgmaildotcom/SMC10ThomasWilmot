function C = optimize_C(sig,Fs,C)
%% Simple Optimization scheme for determining the Threshold and Correlation
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

[~,F] = sort(abs(C));
C = C(F);
f = zeros(1,length(C));

  for i = 1: length(C)
   [~,loc] = TK_filter(sig,Fs,C(i),0.1,0);

    % SNR
    ind = (loc==-1);
    S = loc(~ind);
    N = loc(ind);
    f(i) = length(S)/length(N);
    
    if i > 3
       if ~isnan(f(i-2)) && ~isnan(f(i))
        if f(i-3) < f(i-2) && f(i-2) > f(i-1) && f(i-2) >= f(i)
           C = C(i-1);
           return;
        end  
       end
    end
    
    
  end

[~,ind] = max(f);
C = C(ind);
end