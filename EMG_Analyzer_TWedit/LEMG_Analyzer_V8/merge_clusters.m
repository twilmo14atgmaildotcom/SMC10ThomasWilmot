function uniq_c = merge_clusters(template,title,TH,Fs,sig_l)
%% This function uses Pysuedo- Correlation for clustering
%% Method
%%% Checks first for inter-cluster similarity and then for clusters
%%% themself that are similar

%% Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull
%% Begin
c = 1;
semi_final = zeros(max(title),size(template,2));
counter = false(max(title),1);

if round(sig_l/Fs) < 10
min_l = ceil(sig_l/Fs);            %minimum length of clusters
else
min_l = 3;
end

lag = round(0.0002*Fs);                        %lag(def 0.0002)
% Checking for inter-cluster similarity
  for i = 1 : max(title)
      A = (title == i);
      tmp_t2 = template(A,:); 
      if size(tmp_t2,1) >= min_l
       semi_final(c,:) = median(tmp_t2);
       
         for j = 1:size(tmp_t2,1)
             PsC_s = PsC_mex(semi_final(c,:),tmp_t2(j,:),4);
             if PsC_s < TH
                 tmp_t2(j,:) = NaN;
             end
         end
       tmp_t2 = (tmp_t2(isfinite(tmp_t2(:, 1)), :));
       if size(tmp_t2,1) < min_l
        semi_final(c,:) = NaN;
        counter(c) = 0;        
       else
        semi_final(c,:) = median(tmp_t2);
        counter(c) = 1;
       end
       c = c +1;
      end   
  end

  
% Now merging clusters that are similar
semi_final = semi_final(counter,:);


  for i = 1: size(semi_final,1)
     if all(~isnan(semi_final(i,:)))
       for j = 1 : size(semi_final,1)
          if (i~=j) && (all(~isnan(semi_final(j,:))))   
             PsC_s = PsC_mex(semi_final(i,:),semi_final(j,:),lag);
               if  PsC_s > TH
                semi_final(i,:) = (semi_final(i,:)+semi_final(j,:))*1/2;
                semi_final(j,:) = NaN;
               end       
          end
       end
     end
  end
  
  
   uniq_c = (semi_final(isfinite(semi_final(:, 1)), :));

end