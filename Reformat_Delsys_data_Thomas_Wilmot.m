%% Delsys data reformatting by Thomas Michael Wilmot
% Last updated: 22/04/18
% for more information contact: twilmo14@student.aau.dk
% This script is designed to import and synchronise data from the Delsys
% trigno system into matlab. Note that this script will need editted if
% input data has multiple different recording lengths.

clear all;
close all;
clc;

%% Go to data folder

% Change directory
cd('C:\Users\Thomas\Documents\GitHub\SMC10_ThomasWilmot\SMC10ThomasWilmot\Delsysdata210318\TomSimpleMotionDelsys_210318');

%% Import data

% Create list of files in current folder
Dir_cf=dir('*.xls'); %enter target file format between brackets

% Import data as tables
for i=1:length(Dir_cf)
    fileName=Dir_cf(i).name;
    tabNames{i}=cell2mat(extractBetween(fileName,'TomMotionSimple_210318_','_Rep')); %Create variable names from recorded data
    assignin('base', tabNames{i}, readtable(fileName)); %Create tables from recorded data
    s1=tabNames{i};
    s2='.Properties.VariableNames';
    c1{i}=strcat(s1,s2);
    s3='=erase(' ;
    s4=',' ;
    c2{i}=strcat(c1{i},s3,c1{i},s4,');');
end
clear('i','tabNames','fileName','Dir_cf','s2','s1','c1','s3','s4'); %Remove unwanted variables from workspace
clc;

%% Remove errors such as unwanted '_' from variable names in tables

c2'
% select and copy ouput into new temporary script > use find all (crtl+f) /replace
% all functions to remove '{','}',' ',... punctuation etc > insert any error
% characters that appear in the variable names before the bracket in ',);'
%The resulting code should look similar to the following lines
RadialDeviation_1kg.Properties.VariableNames=erase(RadialDeviation_1kg.Properties.VariableNames,'_');
RadialDeviation_2kg.Properties.VariableNames=erase(RadialDeviation_2kg.Properties.VariableNames,'_');
RadialDeviation.Properties.VariableNames=erase(RadialDeviation.Properties.VariableNames,'_');
UlnarDeviation.Properties.VariableNames=erase(UlnarDeviation.Properties.VariableNames,'_');
WristExtension_1kg.Properties.VariableNames=erase(WristExtension_1kg.Properties.VariableNames,'_');
WristExtension_2kg.Properties.VariableNames=erase(WristExtension_2kg.Properties.VariableNames,'_');
WristExtension.Properties.VariableNames=erase(WristExtension.Properties.VariableNames,'_');
WristFlexion_1kg.Properties.VariableNames=erase(WristFlexion_1kg.Properties.VariableNames,'_');
WristFlexion_2kg.Properties.VariableNames=erase(WristFlexion_2kg.Properties.VariableNames,'_');
WristFlexion.Properties.VariableNames=erase(WristFlexion.Properties.VariableNames,'_');

clear('c2','ans');
clc;

%% Convert table data into structured arrays

% Create index of workspace
zworksp_idx= evalin('base','whos');

% Use 'table2struct' function on all tables to convert them to structured
% arrays

for idx_var=1:length(zworksp_idx)
    name_var=(zworksp_idx(idx_var).name);
    curr_var=eval(name_var);
    curr_var2=table2struct(curr_var);
    assignin('base',(zworksp_idx(idx_var).name),curr_var2);
end

clear('curr_var', 'name_var', 'idx_var', 'curr_var2');% Remove unwanted variables from workspace
clc;

%% Convert structured arrays into matrices

% Sampling Frequency per sensor type as given by Delsys
fs_EMG=1111.111;
fs_ACC=148.148148;
fs_GYRO=148.148148;
fs_MAG=74.074074; %Note Xs time stamp for Mag is double actual time

% Get indices for Time, EMG, Mag, Acc and Gyro channels
for idx_var=1:length(zworksp_idx)
    name_var=(zworksp_idx(idx_var).name);
    curr_var=eval(name_var);
    columnName=fieldnames(curr_var(idx_var));
    idx_Time=find(contains(columnName,'Xs')==1);%edit left hand expression if recordings are different lengths
    idx_EMG=find(contains(columnName,'EMG')==1);%edit left hand expression if recordings are different lengths
    idx_Acc=find(contains(columnName,'ACC')==1);%edit left hand expression if recordings are different lengths
    idx_Mag=find(contains(columnName,'Mag')==1);%edit left hand expression if recordings are different lengths
    idx_Gyro=find(contains(columnName,'Gyro')==1);%edit left hand expression if recordings are different lengths
    % Edit the names and search terms below to match the given sensor names
    idx_DORSUM=find(contains(columnName,'DORSUM')==1);%edit left hand expression if recordings are different lengths
    idx_FLXCRAD=find(contains(columnName,'FLXCRAD')==1);%edit left hand expression if recordings are different lengths
    idx_EXTCRAD=find(contains(columnName,'EXTCRAD')==1);%edit left hand expression if recordings are different lengths
    idx_EXTCULN=find(contains(columnName,'EXTCULN')==1);%edit left hand expression if recordings are different lengths
    idx_NRVANTOUT=find(contains(columnName,'NRVANTOUT')==1);%edit left hand expression if recordings are different lengths
    idx_NRVANTINT=find(contains(columnName,'NRVANTINT')==1);%edit left hand expression if recordings are different lengths
    idx_NRVPOSTINT=find(contains(columnName,'NRVPOSTINT')==1);%edit left hand expression if recordings are different lengths
    idx_NRVPOSTOUT=find(contains(columnName,'NRVPOSTOUT')==1);%edit left hand expression if recordings are different lengths
end
clear('name_var', 'idx_var', 'curr_var','columnName');

% Convert Structured Arrays to Matrices
for idx_var=1:length(zworksp_idx)
    name_var=(zworksp_idx(idx_var).name);
    curr_var=eval(name_var);
    curr_var2=struct2cell(curr_var);
    curr_var3=cell2mat(curr_var2);
    assignin('base',(zworksp_idx(idx_var).name),curr_var3);
end
clear('name_var', 'idx_var', 'curr_var','idx_chan', 'curr_var2', 'curr_var3')

%Correct Time stamp on Magnetometer, Accelerometer and Gyroscope
for idx_var=1:length(zworksp_idx)
    name_var=(zworksp_idx(idx_var).name);
    curr_var=eval(name_var);
    curr_var([idx_Acc idx_Mag idx_Gyro]-1,:)=(curr_var([idx_Acc idx_Mag idx_Gyro]-1,:))/2;
    assignin('base',(zworksp_idx(idx_var).name),curr_var);
end
clear('name_var', 'idx_var', 'curr_var','idx_chan', 'curr_var2', 'curr_var3')

% Check maximum time and number of samples per recording
for idx_var=1:length(zworksp_idx)
    name_var=(zworksp_idx(idx_var).name);
    curr_var=eval(name_var);
    [mx_Time  idx_mxTime]= max(curr_var(idx_Time,:)');%edit left hand expression if recordings are different lengths
end
clear('name_var', 'idx_var', 'curr_var');

% Check requested recording length in HPF files and compare to data
n_rs=33333; % Number of requested samples. (30 seconds)
ts=length(eval(zworksp_idx(1).name)); % Actual recording lenght in samples

% Create new matrices per sensor per recording

%% Synchronise data channels from IMU with EMG


% Upsample and crop IMU data in order to synchronise it with EMG data
for idx_var=1:length(zworksp_idx)
    name_var=(zworksp_idx(idx_var).name);
    curr_var=eval(name_var);
    reSmpf=round(fs_EMG/fs_ACC,1);%resample factor=7.5
    reSmpf=2*reSmpf; %Note this has to be integer and therefore the EMG data now must also be resampled by 2
    [M N]=size(curr_var);
    curr_var2=zeros(M,N*(2*reSmpf)); %Create empty matrix to hold larger dataset
    for idx_1=1:length(idx_Acc);
        curr_var2(idx_Acc(idx_1),1:length(curr_var(idx_Acc(idx_1),:))*reSmpf)=interp(curr_var(idx_Acc(idx_1),:),reSmpf); %resample ACC
        %curr_var2(idx_Acc(idx_1)-1,1:length(curr_var(idx_Acc(idx_1),:))*reSmpf)=interp(curr_var(idx_Acc(idx_1)-1,:),reSmpf); %resample ACC Time Stamp
    end
    clear('idx_1');
    for idx_1=1:length(idx_Gyro);
        curr_var2(idx_Gyro(idx_1),1:length(curr_var(idx_Gyro(idx_1),:))*reSmpf)=interp(curr_var(idx_Gyro(idx_1),:),reSmpf); %resample Gyro
        %curr_var2(idx_Gyro(idx_1)-1,1:length(curr_var(idx_Gyro(idx_1),:))*reSmpf)=interp(curr_var(idx_Gyro(idx_1)-1,:),reSmpf); %resample Gyro Time Stamp
    end
    clear('idx_1');
    for idx_1=1:length(idx_EMG);
        curr_var2(idx_EMG(idx_1),1:length(curr_var(idx_EMG(idx_1),:))*2)=interp(curr_var(idx_EMG(idx_1),:),2); %resample EMG
        %curr_var2(idx_EMG(idx_1)-1,1:length(curr_var(idx_EMG(idx_1),:))*2)=interp(curr_var(idx_EMG(idx_1)-1,:),2); %resample EMG Time Stamp
    end
    clear('idx_1');
    for idx_1=1:length(idx_Mag);
        curr_var2(idx_Mag(idx_1),1:length(curr_var(idx_Mag(idx_1),:))*reSmpf*2)=interp(curr_var(idx_Mag(idx_1),:),reSmpf*2); %resample Mag
        % curr_var2(idx_Mag(idx_1)-1,1:length(curr_var(idx_Mag(idx_1),:))*reSmpf*2)=interp(curr_var(idx_Mag(idx_1)-1,:),reSmpf*2); %resample Mag Time Stamp
    end
    clear('idx_1');
    assignin('base',(zworksp_idx(idx_var).name),curr_var2(:,1:n_rs*2));
end
clear('name_var', 'idx_var', 'curr_var','reSmpf');

%% Remove time stamp data from matrices

%this step is performed due to an error during interpolation and because it
%is not necessary
for idx_var=1:length(zworksp_idx)
    name_var=(zworksp_idx(idx_var).name);
    curr_var=eval(name_var);
    curr_var(idx_Time,:)=[];
    assignin('base',(zworksp_idx(idx_var).name),curr_var);
end
clear('name_var', 'idx_var', 'curr_var','idx_chan', 'curr_var2', 'curr_var3')

fs_all=fs_EMG*2; %new sample frequency for all sensors

clear('fs_ACC', 'fs_EMG', 'fs_GYRO', 'fs_MAG', 'idx_Time', 'M','mx_Time', 'N', 'n_rs', 'ts', 'idx_mxTime');

%% Store reformatted data

%Save entire workspace
save('DelsysData_Thomas_Wilmot_SMC10') %Chose filename between brackets

% %Save individual variables
% for idx_var=1:length(zworksp_idx)
%     name_var=(zworksp_idx(idx_var).name);
%     save(name_var,name_var);
% end
% clear('name_var', 'idx_var', 'curr_var','idx_chan', 'curr_var2', 'curr_var3')