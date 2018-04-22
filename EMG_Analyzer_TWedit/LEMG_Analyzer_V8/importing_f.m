function  importing_f(filename,pathname)
%% imports different types of datasets(nihon,synergy, .dat,.txt,.wav,.mat)
%% pitty that I used a global variable, I will change it in future

%% Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull
global data;

%%%% Importing Begins
if isequal(filename,0)
   disp('User selected Cancel');
   return;
else
   disp(['User selected: ', fullfile(pathname, filename)]);
   data.pn = pathname;
end

%%%% To Use different Import functions here later
extension = filename(end-3:end);
if (strcmp(extension,'.mat'))
    S = load(fullfile(pathname, filename));
    
elseif (strcmp(extension,'.wav')) || (strcmp(extension,'.WAV'))
    [S.S,data.Fs] = audioread(fullfile(pathname, filename));
else
   %%%% Use import functions here (Viking, Synergy)
   %%%% 
   flag = determine_EMG_Machine(fullfile(pathname, filename));
   msgbox({'You have selected an export file!',...
       'Please wait while it is getting imported.',...
       'This import will save a copy of the imported file,',...
       'in the same location with the format .mat .',...
       'You can use this file for future to avoid importing again.'},...
       'Importing...');
   switch flag       
       case 1    
       S = import_NihonKohden(filename,pathname,1); %nihon
       case 2
       [~,F] = importSynergy_new(fullfile(pathname, filename)); %Natus
       S.merged = F;
       otherwise
       return;
   end
end


names = fieldnames(S); 
if length(names) > 1 && ismember('data',names)%then this is from Nihon Kohden
    % 
    [~,ind]=ismember('data',names);
    if ~isempty(ind)
      answer = inputdlg('Enter Sampling freqeuncy of the Sig:(Hz)',...
          'Sampling Frequency',1,{'10000'}); 
      answer = str2num(str2mat(answer));
     for  i = 1 : length(names{ind})
      data.sig(i,:) = S.(names{ind})(:,i);
     end
      
      data.Fs = answer(1);   
    else
      disp('Not the right format!');
    return;
    
    end

else
      if strcmp(names{1,1},'merged') || length(names) > 2
          names1 = fieldnames(S.(names{1,1})); 
          answer = inputdlg('Enter Sampling freqeuncy of the Sig:(Hz)',...
          'Sampling Frequency',1,{'10000'});
          answer = str2num(str2mat(answer));
          if ~isempty(answer)
            for i = 1 : length(names1)   
             data.sig(i,:) = S.(names{1,1}).(names1{i});
            end 
           data.Fs = answer(1);
          else
              return;
          end
      elseif length(names) == 1
        [~,ind] = min(size(S.(names{1})));
        if ind~=2
           S.(names{1}) = S.(names{1})'; 
        end
        for i = 1:min(size(S.(names{1})))  
        data.sig(i,:) = S.(names{1})(:,i);
        end
        answer = inputdlg('Enter Sampling freqeuncy of the Sig:(Hz)',...
          'Sampling Frequency',1,{'10000'});
        if ~isempty(answer)
         data.Fs = str2num(str2mat(answer(1)));
        else
          return;
        end
      else
          return; % not recognized format
     end
end
