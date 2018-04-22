function features = border_detector(S_block,template,TH,TH1)
%% This function Assigns a label to each template
% For more details read the following paper:
%% Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull
% TH1 is the threshold to detect each peak bounderies 
 [amp_M1,Maxima1] = findpeaks(S_block);

 A = amp_M1 > TH;
 B = Maxima1(A);                                    % Logical Indexing
 if length(B) > 5
    B = B(1:5); 
 end
 tmp = zeros(2*length(B),2);
 D_border = zeros(length(B),1);
 features = NaN(1,24);
 
 %% compute features related to exterema (limited to 3 for now)
  for i = 1:length(B)                    %length(B) 
      
    if i <=5  %(limited to 5 turns or maximas)
     dummy = find(S_block(1:B(i)) <= TH1);
     
     if isempty(dummy)
      [~,tmp(i,1)] = min(S_block(1:B(i)));    
     else
      tmp(i,1) = dummy(end);
     end     
     tmp(i,1) = B(i) - tmp(i,1);
     
     
     dummy = find(S_block(B(i):end) <= TH1);
     
     if isempty(dummy)
     [~,tmp(i,2)] = min(S_block(B(i):end));     
     else
     tmp(i,2) = dummy(1);
     end
     D_border(i,1) = tmp(i,1) + tmp(i,2);
     
    end
  end
 
 % See if the peak is a maxima or minima
 %amp = amp_M1(A);
 amp = S_block(B);
 for i = 1: length(B)
    if template(B(i)) < 0 
       amp(i) = 1;                               % 1 shows a minima
    else
       amp(i) = 2;                               % 2 shows a maxima
    end 
 end
 
  
  
 features(1,1:length(amp)) = amp;                % number of local Max (1:5)
 features(1,6:5+length(D_border)) = D_border(:); % approximate period (6:10)
 features(1,11:10+length(diff(B))) = diff(B);    % time difference between each maxima(11:14)
 features(1,15:14+length(amp)) = S_block(B);     % Amp of Exterma(15:19)
 features(1,20:19+length(amp)) = B;              % Phase of maximas(20:24)
 %features(1,25) = sum(S_block);                 % Integral of M_TEO
 %features(1,26) = rms(S_block);                 % RMS of the template 




end