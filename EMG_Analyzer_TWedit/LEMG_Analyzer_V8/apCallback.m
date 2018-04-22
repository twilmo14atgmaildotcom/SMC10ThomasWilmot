function apCallback(obj,eventdata,handles)
%% Function for continues Plug and Play
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

  if strcmp(data.player.Running, 'on')
    newPlayHeadLoc = data.player.CurrentSample/data.Fs + data.mousclick;
    
    if data.player.CurrentSample == 1
        set(handles.pushbutton3,'string','Play Audio!'); 
    end
    if newPlayHeadLoc >= (data.durT - data.player.TimerPeriod)
       set(handles.pushbutton3,'string','Play Audio!'); 
       set(handles.popupmenu2,'Enable','on');
       set(handles.pushbutton5,'Enable','off');
       set(handles.popupmenu1,'Enable','on');
       data.mousclick = 0;
    delete(data.ax);
    data.ax = [];
    else
        if ~isempty(data.ax);
        set(data.ax, 'Xdata', [newPlayHeadLoc newPlayHeadLoc]);
        end
        
    end
    
    if newPlayHeadLoc >= data.Border
       t = 1/data.Fs:1/data.Fs:data.Border;
       sig = data.filtered(round(newPlayHeadLoc*data.Fs) -...
           round(data.Border*data.Fs) + 1:round(newPlayHeadLoc*data.Fs));
       set(handles.axes4.Children,'XData',t);
       set(handles.axes4.Children,'YData',sig);

       
    end
    
 
  end
  
end

