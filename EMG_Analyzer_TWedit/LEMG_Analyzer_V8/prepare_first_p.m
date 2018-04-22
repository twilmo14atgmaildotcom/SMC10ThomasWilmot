function prepare_first_p(handles)
%% Set of preprations for the functions in the GUI
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

global data;

%%% preparing first plots
data.filtered = initialize(data.sig(1,:),data.Fs,1);


% Time axis
data.durT = length(data.sig(1,:))/data.Fs;
data.tAxis = 1/data.Fs:1/data.Fs:data.durT;

%%% Plot initial signal
axes(handles.axes1);
mag = (1.02*max(data.filtered));
ylim([-mag mag]);
data.emg_h = plot(data.tAxis,data.filtered);
axis tight;
data.Filt_flag = 1;  % current plot 
set(handles.axes1.YLabel,'string','Normalized(Arbitrary)');
set(handles.axes1.Title,'string','Filtered EMG Channel');
set(handles.axes1.XLabel,'string','Time(Sec)');
grid on;



%%% Plot zoomed in version of channel 1
axes(handles.axes4);
Border = round(data.Fs/5); %200msec window

 if length(data.filtered(1:Border)) >= Border
  mag1 = (1.02*max(data.filtered(1:Border))); % plot(1 sec)
  ylim([-mag1 mag1]);
  plot(data.tAxis(1:Border),data.filtered(1:Border));
 else
   plot(data.tAxis,data.filtered);
 end

set(handles.axes4.YLabel,'string','Normalized(Arbitrary)');
set(handles.axes4.Title,'string','Zoomed View');
set(handles.axes4.XLabel,'string','Time(200 msec)');
grid on;

data.Border = Border/data.Fs;
%%% plot a patch
axes(handles.axes1);
hold on,
X_vert = [data.tAxis(1) data.tAxis(Border) data.tAxis(Border) data.tAxis(1)];
Y_vert = [mag mag -mag -mag];
h = patch(X_vert,Y_vert,[0.5 0.5 0.5]); 
set(h, 'FaceAlpha',0.3,'EdgeColor','c');
data.P_H = h;
data.P_bu = h.XData(1:2);

%%% Plot reference signal
if size(data.sig,1) > 1
 axes(handles.axes2);
 data.ch2_ax = plot(data.tAxis,data.sig(2,:)/max(data.sig(2,:)));
 axis tight;
 set(handles.axes2.YLabel,'string','Normalized(Arbitrary)');
 set(handles.axes2.Title,'string','Ref(ChestBelt) OR Microphone');
 set(handles.axes2.XLabel,'string','Time(Sec)');
 grid on;
else
 data.ch2_ax = [];
end

%%% Initialize player data
data.toplay = data.filtered;


% Slider for panning
set(handles.slider5,'Min',data.tAxis(1)); % default value
set(handles.slider5,'SliderStep',[20/data.Fs;20/data.Fs]); % default value
set(handles.slider5,'Max',...
    data.tAxis(end)- 20/data.Fs - data.Border); % default value
set(handles.slider5,'value',data.tAxis(1));
set(handles.slider5,'Enable','on');