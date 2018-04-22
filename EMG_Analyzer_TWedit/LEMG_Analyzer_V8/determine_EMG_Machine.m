function flag = determine_EMG_Machine(filename)
%% This a function to read the EMG signals from Raw exports EMG machines
%% For now Nihon Kohden and Natus (Viking) EMG machines supported
%% input:
% filename: should be the name of the txt exported file name from the
% machine

%% Automatically determines that the file belongs to which directory
% filename : should contain both filename and its path 
% Import the file binary

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
fid = fopen(filename, 'r'); 

if fid == -1
    flag = -1;
    return;
end

flag = -1;
while 0 < 1
    str = fgetl(fid);   
    if (str == -1), break, end;   
    str(ismember(str,' ')) = []; % remove spaces
    if ~isempty(strfind(str, 'MEB'))
        flag = 1;    % the machine is Nihon
        fclose(fid);
        return;
    end
    if ~isempty(strfind(str(1:2:end), 'Synergy'))
        flag = 2;    % the machine is Natus
        fclose(fid);
        return;
    end
end

fclose(fid);
end