function [y,template,Index,title] = inter_cancel(template,Index,title)
%% Interference Cancelation for MUAP templates
%% inputs : 
% template : holds the initial set of templates
% Index : index holding the indices of templates
% titles : how many templates were identified
%% output : 
% y :  Corrected mean of templates;
%% Method:
% The interference cancelation is based on the approach from Mc. Gill et al

%% Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull

M = size(template,2);
dumi = zeros(1,M);
tempi = zeros(1,M);
final_t = zeros(1,M);
y = zeros(size(template,1),M);
%M = round(M/2);
c = 1;
FH = true(1,size(template,1));
for j = 1:max(title)
   A = (title == j);
   ind_tmp =Index(A);  
   N = length(ind_tmp); 
   
 if N > 3 
     tmp = template(A,:);
     y(c,:) = (1/N)*sum(tmp);
  
  for i = 1 : max(title)
    if i ~= j
      B = (title == i);
      ind = Index(B);
     
      if length(ind) > 3
        D = zeros(1,length(ind));
        for p = 1 : length(ind)
           dd = (ind(p) - ind_tmp);
           [~,indi] = min(abs(dd));
           D(p) = dd(indi);
        end
        TF = (abs(D) < M);
        D1 = D(TF);
        if ~isempty(D1)
            tmp = template(B,:);
            y1 = mean(tmp);
            for n = 1:length(D1)
                
                if D1(n) < 0
                junk = y1(-D1(n):end);    
                tempi(1:length(junk)) = junk;
                elseif D1(n) > 0
                junk = y1(1:end-D1(n));    
                tempi(D1(n)+1:end)=junk;
                else 
                    tempi = y1;
                end
                dumi = dumi + tempi;
                tempi = zeros(1,M);
            end
        end  
      end
      final_t = final_t + dumi;
      dumi = zeros(1,M);
    end
    
  end
  y(c,:) = y(c,:) - ((1/N)*final_t);
  final_t = zeros(1,M);
  c = c+1;
  
 else
     FH(A) = 0;
 end
end

y = y(1:c-1,:);
template = template(FH,:);
Index = Index(FH);
title = title(FH);
end