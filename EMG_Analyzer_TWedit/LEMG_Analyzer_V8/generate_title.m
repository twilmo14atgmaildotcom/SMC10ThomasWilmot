function title = generate_title(features)
%% Title Generation:
% generates the titles and also initial set of clusters based on label
% matching 

%% Part of : Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull

  title = cell(size(features,1),1);
  complete = cell(size(features,1),1);
  L = zeros(size(features,1),1);

  for i = 1 : size(features,1)
      tmp1 = ~isnan(features(i,1:5));
      tmp1 = features(i,tmp1);
      tmp = ~isnan(features(i,:));
      tmp = features(i,tmp);
      title{i} = num2str(tmp1,'%d');
      complete{i,1} = num2str(tmp,'%d');
      L(i) = length(title{i});
  end
  
  [tmp,ai] = unique(title);
  L = L(ai);
  [~, title] = ismember(title, tmp);


  for i = 1:length(L)
      LI = (L(i)-1);
      ind1 = (title == i);
      locs = find(title == i);
      test = cell2mat(complete(ind1,1));
      for j = 1 : size(test,1)
          for k = 1 : size(test,1)
              
              if (j > 1) 
                  TP = (test(j,:)==test(j-1,:));
                  if all(TP)
                     break; 
                  end  
              end
              
            d = abs(test(j,:) - test(k,:));
            B = any(and((d ~= 1),(d ~= 0)));
            V = any(d(end-LI:end));
            if (~B && ~V)
                test(k,:)= test(j,:);
                complete(locs(k),1) = complete(locs(j),1);
            end
          end
      end
  end
  
  tmp = unique(complete);
  [~, title] = ismember(complete, tmp);
end