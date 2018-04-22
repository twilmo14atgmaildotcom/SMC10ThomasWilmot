%% ------------------------------------------------------------------------
%% the timer callback function definition
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
function plotMarker(...
    obj, ...            % refers to the object that called this function (necessary parameter for all callback functions)
    eventdata, ...      % this parameter is not used but is necessary for all callback functions
    player, ...         % we pass the audioplayer object to the callback function
    figHandle, ...      % pass the figure handle also to the callback function
    plotdata)           % finally, we pass the data necessary to draw the new marker

% check if sound is playing, then only plot new marker
if strcmp(player.Running, 'on')
    
    % get the handle of current marker and delete the marker
    hMarker = findobj(figHandle, 'Color', 'r');
    delete(hMarker);
    
    % get the currently playing sample
    x = player.CurrentSample;
    
    % plot the new marker
    plot(repmat(x, size(plotdata)), plotdata, 'r');

end
