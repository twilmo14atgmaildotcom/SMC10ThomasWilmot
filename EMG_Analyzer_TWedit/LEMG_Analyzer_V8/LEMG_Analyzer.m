function varargout = LEMG_Analyzer(varargin)
% LEMG_ANALYZER MATLAB code for LEMG_Analyzer.fig
%% GUI for interactive EMG MUAP classification
%% This is the main function of the Toolbox

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
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LEMG_Analyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @LEMG_Analyzer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before LEMG_Analyzer is made visible.
function LEMG_Analyzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LEMG_Analyzer (see VARARGIN)

    uiwait(msgbox({'Welcome to LEMG_Analyzer V.1!',' ',...
    'LEMG_Analyzer uses advanced Pattern Recognition techniques to',...
    'automatically recognize MUAPs and Classify Them.',...
    ' ',' ',' ',...
    'Author: Hooman Sedghamiz',' ',...
    ' ','Just for Non-commercial use!'}));

%%%% Include required libraries 
%%%%% set the environment


% Initialze the main struct data
clearvars -global;
reset_all(hObject, eventdata, handles); 

% Choose default command line output for LEMG_Analyzer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LEMG_Analyzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LEMG_Analyzer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global data;
data.C = get(handles.slider1,'Value');
set(handles.text1,'string',mat2str(data.C));
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global data;

contents = cellstr(get(hObject,'String'));
state = contents{get(hObject,'Value')};
ind = str2double(state(end));
axes(handles.axes2);
N = allchild(handles.axes2);

if length(N) > 1
 delete(N(1));
 hold on,
 TP = detrend(data.sig(ind,:));
 TP = TP/max(TP);
 plot(data.tAxis,TP,'r','Linewidth',1.5); 
else
 hold on,
 TP = detrend(data.sig(ind,:));
 TP = TP/max(TP);
 plot(data.tAxis,TP,'r','Linewidth',1.5);
end





% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on slider1 and none of its controls.
function slider1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global data;
state = get(hObject,'Value');
data.PsC_TH = state;
set(handles.text2,'string',mat2str(state));


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Classifies MUAPs
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
set(handles.pushbutton1,'string','Processing...');
set(handles.pushbutton1,'Enable','off');
set(handles.pushbutton1,'BackgroundColor','r');
set(handles.popupmenu3,'Enable','off'); 
pause(0.01);
[Index,loc,final_temps] = TK_filter(data.filtered,data.Fs,...
    data.C,data.PsC_TH,0);
set(handles.pushbutton1,'string','Start Clustering!');
set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton1,'BackgroundColor', [0.9 0.9 0.9]);

% new plot
cla(handles.axes1);
axes(handles.axes1);
handles.axes1.ColorOrder = handles.axes1.ColorOrder(1,:);
%%% axes lims
if data.mind < 0
    Lmm = 1.1*data.mind;
else
    Lmm = 0.9*data.mind;
end
if data.maxd < 0
    Lmx = 0.9*data.maxd;
else
    Lmx = 1.1*data.maxd;
end
plot(data.tAxis,data.filtered);
grid on;
grid minor;
ylim([Lmm Lmx]);
hold on,
%mag = max(data.filtered);
X_vert = [data.P_bu(1) data.P_bu(2) data.P_bu(2) data.P_bu(1)];
%Y_vert = [mag mag -mag -mag];
Y_vert = [Lmx Lmx Lmm Lmm];
data.P_H = patch(X_vert,Y_vert,[0.5 0.5 0.5]); 
set(data.P_H, 'FaceAlpha',0.3,'EdgeColor','c');
% make a dummy data.selection
data.selection_p = [];

% rest of plots
 if (~isempty(Index) && ~isempty(loc) && ~isempty(final_temps))   
    axes(handles.axes3);
    cla;
    names = fieldnames(final_temps);
    data.c_color = hsv(length(names));
    for i = 1 : length(names)
    plot((final_temps.(names{i}))','color',data.c_color(i,:)); 
    hold on,
    end
    set(handles.axes3.YLabel,'string','Normalized(Arbitrary)');
    set(handles.axes3.Title,'string','Extracted Templates');
    set(handles.axes3.XLabel,'string','Samples(20msec)');
    data.processed_flag = 1;
    data.Index = Index;
    data.loc = loc;
    data.final_temps = final_temps;
    names{end+1} = 'ALL';
    names{end+1} = 'Unclassified OR Noise';
    if max(loc)~= -1
    set(handles.popupmenu3,'Enable','on');             %Enable pop up menu
    set(handles.popupmenu3,'string',names);
    set(handles.popupmenu3,'value',max(loc)+1);
    set(handles.uipushtool4,'Enable','on');
    else
        return; % just detected noise
    end
   
 else
    data.processed_flag = 0;
 end

% --------------------------------------------------------------------
%%% Open File and loading button
function  uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;

if ~isempty(data.old_pn)
[filename, pathname] = ...
   uigetfile({'*.mat;*.dat;*.txt;*.wav',...
 'Supported Files (*.mat,*.dat,*.txt,*.wav)';},...
  'Please Select a Measurement File. Supported Formats: .dat, .txt, .mat',...
  data.old_pn);
else
   [filename, pathname] = ...
   uigetfile({'*.mat;*.dat;*.txt;*.wav',...
 'Supported Files (*.mat,*.dat,*.txt,*.wav)';},...
  'Please Select a Measurement File. Supported Formats: .dat, .txt, .mat');
end
reset_all(hObject, eventdata, handles);
set(handles.popupmenu1,'value',1);
set(handles.popupmenu2,'value',1);
data.sig = [];
data.processed_flag = 0;
data.playflag = 1;
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);

if ~(filename)
   return; 
end

data.old_pn = pathname;
set(handles.figure1,'Name',strcat('EMG Analyzer ::',filename));

%%%importing
%-----------------------
importing_f(filename,pathname);
%-----------------------
%%% end importing

%%% Prepare first plots
%-----------------------
prepare_first_p(handles)
%-----------------------
%%% end prepare of the first channels
%%% save max of sig for plot purpose
data.maxd = max(data.filtered);
data.mind = min(data.filtered);
%%% Set channels
Ch_names = cell(size(data.sig,1),1);
Ch_audio = cell(size(data.sig,1),1);
for i = 1 : size(data.sig,1)
    Ch_names{i} = strcat('CH',mat2str(i));
    Ch_audio{i} = strcat('Play CH',mat2str(i));
end

%%% Enable buttonfcdwn
% Enable the buttonfcndown for axes 1 and 2
set(data.emg_h ,'buttondownfcn',@place_b);

%set(B,'HitTest','off');% makes all the childs sensitive to click
if ~isempty(data.ch2_ax)
set(data.ch2_ax ,'buttondownfcn',@place_b);
end
%%%

% enable buttons 
set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton1,'string','Start Clustering!');
set(handles.pushbutton3,'Enable','on');
set(handles.pushbutton3,'string','Play Audio!');
set(handles.slider1,'Enable','on');
set(handles.slider2,'Enable','on');
set(handles.popupmenu1,'Enable','on');
set(handles.pushbutton4,'Enable','on');
set(handles.pushbutton4,'string','Optimize TH!');
set(handles.popupmenu3,'Enable','off');
set(handles.uipushtool4,'Enable','off');
set(handles.popupmenu2,'Enable','on');
set(handles.popupmenu1,'string',Ch_names);
set(handles.popupmenu2,'string',Ch_audio);
set(handles.pushbutton5,'string','Stop!');

% Toolbar
set(handles.uitoggletool5,'Enable','on');







% --- Plays the Audio in .
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;

%%%%% using audioplayer obj
frameRate = 25; 
frameT = 1/frameRate;
if data.playflag == 1
mag = (1.02*max(data.toplay));
else
TP = data.toplay/max(data.toplay);
mag = (1.02*max(TP));
end
state = get(handles.pushbutton3,'string');
if length(handles.axes4.Children) > 1
    delete(handles.axes4.Children(1:end-1));
end
axes(handles.(strcat('axes',mat2str(data.playflag))));
%%%%reading using audioplayer obj
  if strcmp(state,'Continue')      
    set(handles.pushbutton3,'string','Pause');
    resume(data.player);
  elseif strcmp(state,'Pause')  
    set(handles.pushbutton3,'string','Continue');
    pause(data.player);
  elseif strcmp(state,'Play Audio!')
    data.player = audioplayer(data.toplay, data.Fs);
    data.mousclick = 0; % offset for playing
    set(handles.pushbutton3,'string','Pause');
    set(handles.pushbutton5,'Enable','on');
    set(handles.popupmenu2,'Enable','off');
    set(handles.popupmenu1,'Enable','off');%overlay selection
    ylim([-mag mag]);
    playHeadLoc = (data.player.CurrentSample/data.Fs);
    hold on;
    if isempty(data.ax)
    data.ax = plot([playHeadLoc playHeadLoc],...
        [-mag mag], 'k', 'LineWidth', 2,'LineStyle','-.');
    end
    data.player.TimerFcn = {@apCallback,handles};
    data.player.TimerPeriod = frameT;
    play(data.player);
  end
  
 
  



% --- Selects the signal to be played and plots it
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
% 
global data;
contents = cellstr(get(hObject,'String'));
state = contents{get(hObject,'Value')}; 
ind = str2double(state(end));

if strcmp(state(1:end),'Play CH1')
    data.toplay = data.filtered;
    data.playflag = 1;
else
    data.toplay = data.sig(ind,:);
    data.playflag = 2;   
    %%%%%%plotting
    cla(handles.axes2); 
    axes(handles.axes2);
    TP = detrend(data.sig(ind,:));
    TP = TP/max(TP);
    ch2_ax = plot(data.tAxis,TP);
    axis tight;
    grid on;
    grid minor;
%    mag = (1.02*max(data.sig(ind,:)));
%    ylim([-mag mag]);
   set(handles.axes2.YLabel,'string','Normalized to 1(Arbitrary)');
   set(handles.axes2.Title,'string',strcat('Unfiltered CH',mat2str(ind)));
   set(handles.axes2.XLabel,'string','Time(Sec)');
   set(ch2_ax ,'buttondownfcn',@place_b);
    
end




% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global data;
patch_pos = get(hObject,'Value');
%data.P_H.XData = data.P_H.XData(:) + patch_pos;
data.P_H.XData(1) = patch_pos;
data.P_H.XData(4) = patch_pos;
data.P_H.XData(2) = data.P_H.XData(1) + data.Border - 1/data.Fs;
data.P_H.XData(3) = data.P_H.XData(2);
data.P_bu = data.P_H.XData(1:2);
axes(handles.axes4);
border = data.P_H.XData(1:2);
x =border(1):1/data.Fs:border(2);
yborder = round(x.*data.Fs);
x = 1/data.Fs : 1/data.Fs : data.Border;
pl = data.filtered(yborder);
plot(x,pl);

if data.mind < 0
    Lmm = 1.1*data.mind;
else
    Lmm = 0.9*data.mind;
end
if data.maxd < 0
    Lmx = 0.9*data.maxd;
else
    Lmx = 1.1*data.maxd;
end

grid on;
grid minor;
axis tight;
set(handles.axes4.YLabel,'string','Normalized(Arbitrary)');
%set(handles.axes4.Title,'string','Zoomed View');
set(handles.axes4.XLabel,'string','Time(200 msec)');
f_p = get(handles.popupmenu3,'Value');
ylim([Lmm Lmx]);
if data.processed_flag
    A = and((data.Index >= yborder(1)),(data.Index <= yborder(end)));
    Ind = data.Index(A);
    loc = data.loc(A);
    title(strcat('Number of Crossings =',mat2str(length(Ind))));
  if ~isempty(Ind)
    if f_p < (max(data.loc) + 1)
    A = (loc == f_p);
    Ind = Ind(A);
    loc = loc(A);
    elseif f_p == (max(data.loc) + 1)
    A = (loc ~= -1);
    Ind = Ind(A);
    loc = loc(A);
    else 
    A = (loc == -1);
    Ind = Ind(A);
    loc = loc(A);    
    end
   %%% 
   if ~isempty(Ind) 
     begin_s = yborder(1) - 1;    
     Ind = Ind - begin_s;
       for i = 1 : length(Ind)
        text(Ind(i)/data.Fs,pl(Ind(i)),mat2str(loc(i)));
       end   
   end
  end
end

 



% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Optimizes the threshold
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
set(handles.pushbutton4,'string','Processing...');
set(handles.pushbutton4,'BackgroundColor','r');
set(handles.pushbutton4,'Enable','off');
pause(0.01);
if length(data.filtered) > round(6*data.Fs)
    if length(data.filtered) > round(13*data.Fs)%if more than 13 sec
      optsig = data.filtered(round(length(data.filtered)/2)...
          -round(6*data.Fs):round(length(data.filtered)/2));  
    else
      optsig = data.filtered(1:round(6*data.Fs));
    end
else
     optsig = data.filtered(:);
end

minl = get(handles.slider1,'Min'); % default value
maxl = get(handles.slider1,'Max');
step = get(handles.slider1,'SliderStep');
step = step(1)*(maxl - minl);
vector_o = (minl:step:maxl);
data.C = optimize_C(optsig,data.Fs,vector_o);
set(handles.pushbutton4,'BackgroundColor', [0.9 0.9 0.9]);
set(handles.pushbutton4,'string','Optimize TH!');
set(handles.pushbutton4,'Enable','on');
set(handles.slider1,'Value',data.C);
set(handles.text1,'string',mat2str(data.C));


% --- plots templates.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
global data;
state = get(hObject,'Value');
cla(handles.axes3);
cla(handles.axes1);
axes(handles.axes1);
if data.mind < 0
    Lmm = 1.1*data.mind;
else
    Lmm = 0.9*data.mind;
end
if data.maxd < 0
    Lmx = 0.9*data.maxd;
else
    Lmx = 1.1*data.maxd;
end
plot(data.tAxis,data.filtered);
grid on;
grid minor;
hold on,
%mag = max(data.filtered);
X_vert = [data.P_bu(1) data.P_bu(2) data.P_bu(2) data.P_bu(1)];
%Y_vert = [mag mag -mag -mag];
Y_vert = [Lmx Lmx Lmm Lmm];
data.P_H = patch(X_vert,Y_vert,[0.5 0.5 0.5]); 
set(data.P_H, 'FaceAlpha',0.3,'EdgeColor','c');
switch state 
    case (max(data.loc) + 2)
       % plot noise
       axes(handles.axes1);
       hold on,
       A = (data.loc == -1);
       Index = data.Index(A);
       Index_t = Index./data.Fs;
       line(repmat(Index_t,[2 1]),...
        repmat([0; max(data.filtered)],size(Index_t)),...
        'LineWidth',0.5,'LineStyle','-.','Color','r');
       hold on,
       scatter(Index_t,ones(1,length(Index_t)).*max(data.filtered),...
           'filled','MarkerFaceColor','r');
    case (max(data.loc) + 1)
       % plot all templates
       names = fieldnames(data.final_temps);
       axes(handles.axes3);
       for i = 1 : length(names)
       plot((data.final_temps.(names{i}))','color',data.c_color(i,:)); 
       hold on,
       end
    
       axes(handles.axes1);
       for i = 1 :length(names)
       A = (data.loc == i);
       Index = data.Index(A); 
       Index_t = Index./data.Fs;
       line(repmat(Index_t,[2 1]),...
       repmat([0; max(data.filtered)],size(Index_t)),...
        'LineWidth',0.5,'LineStyle','-.','Color',data.c_color(i,:));
        hold on,
        scatter(Index_t,ones(1,length(Index_t)).*max(data.filtered),...
        'filled','MarkerFaceColor',data.c_color(i,:));    
       end
   
    otherwise
    % plot(specific template)
    axes(handles.axes3);
    plot(data.final_temps.(strcat('Template',mat2str(state)))');
    hold on,
    plot(median(data.final_temps.(strcat('Template',mat2str(state)))),...
        'r','LineWidth',3);
    axes(handles.axes1);
    hold on,
    A = (data.loc == state);
    Index = data.Index(A);
    Index_t = Index./data.Fs;
    line(repmat(Index_t,[2 1]),...
        repmat([0; max(data.filtered)],size(Index_t)),...
        'LineWidth',0.5,'LineStyle','-.','Color','r');
    hold on,
    scatter(Index_t,ones(1,length(Index_t)).*max(data.filtered),...
        'r','filled');
end




% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% to save the results
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
pn1 = uigetdir(data.pn,...
    'Please Select The Folder you would like to save the results');

if pn1 ~= 0
%%% Compute approximate quality
% SNR
    ind = (data.loc==-1);
    S = data.loc(~ind);
    Q = (length(S)/length(data.loc))*100;
%%% 
name = fieldnames(data.final_temps);
amps = NaN(length(name)+3,1);
fire_rate = NaN(length(name)+3,1);
Nr = NaN(length(name)+3,1);
Quality = NaN(length(name)+3,1);
Quality(1) = Q;

H = figure;
subplot(2,2,1);
cl = hsv(length(name));
for i = 1 : length(name)
    m = median(data.final_temps.(name{i}));
    B = (data.Index(data.loc==i));
    [amp_m,loc_m] = max(abs(m));
    if m(loc_m) < 0
       amp_m = -amp_m; 
    end
    plot(m,'color',cl(i,:),'LineWidth',3);
    hold on,
    amps(i) = amp_m;
    fire_rate(i) = 1/(mean(diff(B))/data.Fs);
    Nr(i) = size(data.final_temps.(name{i}),1);
end
   title('Extracted Templates');
   grid on;
   name{i+1} = 'Total(Classified)';
   name{i+2} = 'Total(Detected)';
   name{i+3} = 'Total(Unclassified)';
   Nr(i+1) = sum(Nr(1:i));
   Nr(i+2) = length(data.loc);
   Nr(i+3) = length(data.loc(data.loc == -1));
   T = table(Nr,amps,fire_rate,Quality,'RowNames',name);
   writetable(T,fullfile(pn1, 'Results.csv'),'Delimiter',...
       '\t','WriteRowNames',true); 


   %%% Rest of plot
   subplot(2,2,2);bar(Nr);
   title('Number of Spikes')
   set(gca,'xtickLabel',name,'FontSize',7,...
    'FontAngle','italic',...
    'FontWeight','bold');

   subplot(2,2,3);bar(fire_rate(1:end-3));
   title('Firing Rate Info')
   set(gca,'xtickLabel',name(1:end-3),'FontSize',7,...
    'FontAngle','italic',...
    'FontWeight','bold');

  subplot(2,2,4);bar(amps(1:end-3));
  title('Mean Peak Amplitude of MUAP');
  set(gca,'xtickLabel',name(1:end-3),'FontSize',7,...
    'FontAngle','italic',...
    'FontWeight','bold');
  set(H,'units','normalized','outerposition',[0 0 1 1]);
  saveas(H,fullfile(pn1, 'Results.png')); 
else
 return;       
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
stop(data.player);
set(handles.pushbutton3,'string','Play Audio!');
set(handles.pushbutton5,'Enable','off');
set(handles.popupmenu2,'Enable','on');%enable popoup for audio selection
set(handles.popupmenu1,'Enable','on');%overlay selection
delete(data.ax);
data.ax = [];


function place_b(hObject, eventdata)
global data;
   handles = guidata(hObject);
   axesHandle = get(hObject,'Parent');
   
   if axesHandle  == handles.axes1
    P = get(axesHandle, 'CurrentPoint');
    if (~isempty(data.ax)) && (data.playflag == 1)
    set(data.ax, 'Xdata', [P(1,1) P(1,1)]);
    currentsample = round(P(1,1)*data.Fs); 
    data.player = audioplayer(data.toplay(currentsample :end), data.Fs);
    data.player.TimerFcn = {@apCallback,handles};
    data.player.TimerPeriod = 1/25;
    data.mousclick = P(1,1);
    set(handles.pushbutton3,'string','Continue');
    end
  elseif axesHandle == handles.axes2
    P = get(axesHandle, 'CurrentPoint');
    if (~isempty(data.ax)) && (data.playflag ~= 1)
    set(data.ax, 'Xdata', [P(1,1) P(1,1)]);
    currentsample = round(P(1,1)*data.Fs); 
    data.player = audioplayer(data.toplay(currentsample :end), data.Fs);
    data.player.TimerFcn = {@apCallback,handles};
    data.player.TimerPeriod = 1/25;
    data.mousclick = P(1,1);
    set(handles.pushbutton3,'string','Continue');
    end
  end

  
function reset_all(hObject, eventdata, handles)
%%% resets datasets on each start
global data;
data = [];
data.C = 0.1;     % default threshold
data.playflag = 1;  % locations of played signal
data.PsC_TH = 0.1;   % default value
data.processed_flag = 0;  % shows if any decomposition is performed
data.P_H = [];
data.pn = [];
data.maxd = [];      % holds the maximum of the signal for plotting purpose
data.mind = [];
data.ax = []; %to hold pointer for audio play
data.old_pn = []; %holding old directory
data.selection_flag = 0; %shows if we are in selection mode
data.selection_p = []; %handle to  select an area
% Initializing the Button states
 set(handles.text1,'string',mat2str(data.C));
 set(handles.text2,'string',mat2str(data.PsC_TH));
 
 set(handles.pushbutton1,'Enable','off');
 set(handles.pushbutton1,'string','Load Data First!');
 
 set(handles.pushbutton3,'Enable','off');
 set(handles.pushbutton3,'string','Load Data First!');
 
 set(handles.pushbutton4,'Enable','off');
 set(handles.pushbutton4,'string','Load Data First!');
  
  
 set(handles.slider1,'Enable','off');
 set(handles.slider2,'Enable','off');
 set(handles.popupmenu1,'Enable','off');
 set(handles.popupmenu2,'Enable','off');
 set(handles.popupmenu3,'Enable','off');
 set(handles.uipushtool4,'Enable','off');
 set(handles.pushbutton5,'Enable','off');
 
 
 %%%%%Toolbar
set(handles.uitoggletool5,'Enable','off');
set(handles.expand,'Enable','off');
set(handles.shrink,'Enable','off');
 
 
 % Slider1 initialize holding threshold
set(handles.slider1,'Value',0.1); % default value
set(handles.slider1,'Min',-0.25); % default value
set(handles.slider1,'Max',0.25); % default value
sliderStep = [0.05, 0.05] / (0.25 - (-0.25));
set(handles.slider1,'SliderStep',sliderStep); % default value

set(handles.slider2,'Value',0.1); % default value
set(handles.slider2,'Min',0.05); % default value
set(handles.slider2,'Max',0.7); % default value
sliderStep = [0.01, 0.01] / (0.7 - 0.05);
set(handles.slider2,'SliderStep',sliderStep); % default value


% --------------------------------------------------------------------
function uitoggletool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data;
state = get(hObject,'State');
          if strcmp(state,'on') ;
           waitforbuttonpress;
           point1 = get(handles.axes1,'CurrentPoint'); % buttondown detected
           rbbox;
           point2 = get(handles.axes1,'CurrentPoint'); % buttonup detected
           amp = point1(1,2);
           point1 = point1(1); % extract x and y
           point2 = point2(1);
           p1 = min(point1,point2);
           p2 = max(point1,point2);
           %%%% highlight the aread with a patch
           axes(handles.axes1);           
           if isempty(data.selection_p)
           hold on,
           X_vert = [p1 p2 p2 p1];
           Y_vert = [amp amp -amp -amp];
           data.selection_p = patch(X_vert,Y_vert,[0.5 0.5 0.5]); 
           set(data.selection_p, 'FaceAlpha',0.3,'EdgeColor','r'); 
           else
           data.selection_p.XData = [p1 p2 p2 p1];
           data.selection_p.YData = [amp amp -amp -amp];
           end
           set(handles.uitoggletool5,'State','off');
           set(handles.expand,'Enable','on');
          end


% --------------------------------------------------------------------
function expand_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to expand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;

if ~isempty(data.selection_p)  
    % save the old data and set the new data
    data.old = data.sig;
    border(1) = round(data.selection_p.XData(1)*data.Fs);
    border(2) = round(data.selection_p.XData(2)*data.Fs);
   if (border(2)-border(1)) > (data.Fs*data.Border)
    data.sig = data.sig(:,border(1):border(2));
    
    %%% reset all axes
    data.playflag = 1;
    cla(handles.axes1);
    cla(handles.axes2);
    %cla(handles.axes3);
    cla(handles.axes4);
    prepare_first_p(handles);
    
    
    %%% Enable buttonfcdwn
    % Enable the buttonfcndown for axes 1 and 2
    set(data.emg_h ,'buttondownfcn',@place_b);

    %set(B,'HitTest','off');% makes all the childs sensitive to click
    if ~isempty(data.ch2_ax)
    set(data.ch2_ax ,'buttondownfcn',@place_b);
    end

    set(handles.shrink,'Enable','on');
    set(handles.uitoggletool5,'Enable','off');
    set(handles.expand,'Enable','off');
    set(handles.pushbutton3,'string','Play Audio!'); 
    data.ax=[];
    data.selection_p= [];
   else
       msgbox('You cant select an area smaller than 200 msec');
   end
end


% --------------------------------------------------------------------
function shrink_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to shrink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
data.sig = data.old;


%%% reset all axes
    data.playflag = 1;
    cla(handles.axes1);
    cla(handles.axes2);
    %cla(handles.axes3);
    cla(handles.axes4);


    prepare_first_p(handles);
    %%% Enable buttonfcdwn
    % Enable the buttonfcndown for axes 1 and 2
    set(data.emg_h ,'buttondownfcn',@place_b);

    %set(B,'HitTest','off');% makes all the childs sensitive to click
    if ~isempty(data.ch2_ax)
    set(data.ch2_ax ,'buttondownfcn',@place_b);
    end

set(handles.shrink,'Enable','off');
set(handles.uitoggletool5,'Enable','on');
set(handles.pushbutton3,'string','Play Audio!'); 
data.ax=[];
data.selection_p= [];



