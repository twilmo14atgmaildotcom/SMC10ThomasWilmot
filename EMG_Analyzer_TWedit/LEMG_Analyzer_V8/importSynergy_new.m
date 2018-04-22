function [data,merged] = importSynergy_new(FileName,store,inverse)
%% Fast IMPORTSYNERGY Function 
% set Inverse 1 when you want the data to be saved upside down
%% Fast Import of the Synergy .txt file


%% Inputs :
% store : Flag it to 1 to save in the same directory

%% Outputs :
% data : raw structure of data
% merged : Merged dataset

%%
% edited by Hooman Sedghamiz
% May 2015
% Keywords: FACIALIS, EMG
%% Algorithm is based on the following paper :
% H. Sedghamiz and Daniele Santonocito,'Unsupervised Detection and
% Classification of Motor Unit Action Potentials in Intramuscular 
% Electromyography Signals', The 5th IEEE International Conference on
% E-Health and Bioengineering - EHB 2015, At Iasi-Romania.
%% Author: 
% Hooman Sedghamiz
% June 2015, Linkoping University
% Please cite the paper if any of the methods were helpfull
%% Initialize

C_p = pwd;
if nargin < 3
    inverse = 1;
    if nargin < 2
    store = 1;
        if nargin < 1
            [FileName,PathName] = uigetfile('*.txt',...
                'Please select the export text file');
            cd(PathName);
        end
    end
end


fid = fopen(FileName, 'r');
channelnames = [];
trials = 0;
st  = '        ';                        % initialize some variables
et  = '        ';
temp1 = 't';                             % for tracking the channels
data = struct('MittelungsDaten',[],'Block',[],'Startzeit',[],'Endzeit',[], ...
    'Referenzeingang',[],'AktiverEingang',[],'Reizpegel',[],'LongTraceDaten',[]); % create struct
remove_coma =[];
      


%% Start Line by Line
while 1
   str = fgetl(fid);    
   % read line from export file
   if (str == -1), break, end;                        % exit while loop if we can't read more lines from the file
   str = str(2:2:end);                                % remove unicode? part
   if (isempty(strfind(str, 'Untersuchungen')) == 0)  %Check for the number of channels extracted
        a = strfind(str, '=');
        nCh=str(a(1)+1);              % extract number
        disp(nCh);
        b = strfind(str, '(');
        if ~isempty(b)
         for i = 1:str2num(nCh)
            channelnames(i,:) = str(b(1)+2+(5*(i-1)):b(1)+4+(5*(i-1)));
         end
        else
         for i = 1:str2num(nCh)
            channelnames(i,:) = mat2str(i);
         end
         
        end
   end
  
   if (isempty(strfind(str, '; Exportdatei')) == 0)   %check for movement during acquistion
       b = strfind(str, '=');
       measname=str(b+1:end);
   end
   
   if (isempty(strfind(str, 'Kurvendaten')) == 0)     % check for block number
       a = strfind(str, '.');                         % search delimiters of code
       bn = str2num(str(a(2)+1:a(3)-1));              % extract number
   end
   if (isempty(strfind(str, 'Startzeit')) == 0)       % check for start time of block
       a = strfind(str, ':');                         % search delimiters of code
       st = str(a(1)-2:a(2)+2);                       % extract time
   end
   if (isempty(strfind(str, 'Endzeit')) == 0)         % check for end time of block
       a = strfind(str, ':');                         % search delimiters of code
       et = str(a(1)-2:a(2)+2);                       % extract time
   end
   
   if (isempty(strfind(str, 'ADC-E')) == 0)           % FOR ADC converted
   remove_coma = 1;
   end
%% Mitelungs-Daten
   if length(str)>15 && strcmp(str(1:16), 'Mittelungs-Daten')
      x = 1;
      trials = trials + 1;
      formatSpec = 'Trial %d...\n';
      fprintf(formatSpec,trials);
      pos1 = strfind(str,'<');
      pos = strfind(str,'>');
      num_sample = str2num(str(pos1+1:pos-1)); % number of recorded samples
      %data(end).MittelungsDaten = zeros(num_sample,1); % count number of datasets
      data(trials).MittelungsDaten = NaN(num_sample,1);
      str = str(pos+2:end); % jump behind '='
    while x <= num_sample
        A = isstrprop(str, 'digit');
     if ~isempty(find(A,1))   
                      
      slash = strfind(str,'/');
      if slash
          str(slash) = ',';
      else
          str = strcat(str,',');
      end
      
   
      Dummy = strfind(str,','); 
      if isempty(remove_coma)
      str(Dummy(1:2:end)) = '.';
      ind_end = Dummy(2:2:end); % end of each number
      else
      ind_end = Dummy;
      end
      str(ind_end) = ' ';
      old_x = x;  
      x = x + length(ind_end);
      data(trials).MittelungsDaten(old_x : x-1,1) = strread(str, '%f');  % init new data set and do pre-init memory
      data(trials).Block = bn;                           % save block number
      data(trials).Startzeit = st;                       % save start time
      data(trials).Endzeit = et;                         % end start time
      data(trials).titles = channelnames;
      data(trials).measname = measname;                  % get real new line  
      str = fgetl(fid);
      str = str(2:2:end);                             % get rid of unicode
     else
      str = fgetl(fid);
      str = str(2:2:end);   
     end  
    end
 
   elseif length(str) > 10 && strcmp(str(1:10), 'Reizpegel=')
            str = strrep(str,',','.');                      % simply convert to US numeric standard
            data(trials).Reizpegel = str2num(str(11:end-2));   % remove 'mA' and convert to number
            
   elseif length(str)>16 && strcmp(str(1:16), 'Referenzeingang=')
                    data(trials).Referenzeingang = str(17:end);
                    temp = {str(17:end)};
                  
                    if ~isempty(temp)&& ~isempty(data(trials).MittelungsDaten(:,1))
                        if ~isempty(strfind(temp,'-'))
                          temp = strrep(temp,'-',''); 
                        end
                        if ~isempty(strfind(temp,'+'))
                          temp = strrep(temp,'+','');  
                        end
                        
                       
                       tr = isempty(strfind(temp1,char(temp(:))));
                       if tr
                          merged.(char(temp(:)))=[]; 
                          temp1= strcat(temp1,char(temp(:))); 
                       end
                       
                        % Inverse the signal if its saved upside down
                    if inverse                      
                     merged.(char(temp(:))) = [merged.(char(temp(:)));data(trials).MittelungsDaten(end:-1:1)];
                    else
                     merged.(char(temp(:))) = [merged.(char(temp(:)));data(trials).MittelungsDaten(:,1)]; 
                    end
                    
                    end
   elseif length(str)>16 && strcmp(str(1:16), 'Aktiver Eingang=')
                     data(trials).AktiverEingang = str(17:end);                   
   elseif length(str)>24 && strcmp(str(1:24), 'Mittelungszeitbasis(ms)=')
                     data(trials).Mittelungszeitbasis = str(25:end);
   elseif length(str)>19 && strcmp(str(1:19), 'Zeit / Einheit(ms)=')
                     data(trials).Mittelungszeitbasis = str(20:end);
   elseif length(str)>19 && strcmp(str(1:19), 'Probennahmefrequenz')
                                % search delimiters of code
       sr = str2num(str(26:end));
       
        data(trials).samplerate = sr(1)*1000;
       
   end

end % while loop to infinity ;)
fclose(fid);

%% reverse the signal
if ~isempty(merged)
   fnames = fieldnames(merged);
  if inverse 
        for i = 1:length(fnames)
        tmp = fnames{i,1};
        merged.(tmp)= merged.(tmp)(end:-1:1); 
        end
  end
  
 if store
   save([FileName(1:(end-3)) 'mat'],'merged');
   names = fieldnames(merged);
   aud = zeros(length(merged.(names{1,1})),length(names));
   Fs = data(trials).samplerate;
   Fs = Fs/2;
   %gain = [5 8 2 2 2];
   gain = [20 20 20 20 20];
  for i = 1:length(names)
    aud(1:length(merged.(names{i,1})),i) =...
        detrend(merged.(names{i,1})); 
    aud(:,i) = (aud(:,i)/std(aud(:,i)))*1/gain(i);
  end
  audiowrite([FileName(1:(end-3)) 'wav'],aud,Fs);
 end
 
else
 error('Wrong File!')   
    
end
cd(C_p);
fprintf('Export Successfully Done!');
data = data(2:end); % this is faster than checking everytime for first dataset in while loop