function [S_block,template] = spike_seperator(S_block,template,S_neighbor,window,TH)
%% spike_seperator
% Divides the Spike in two sections
% Removes the second pulse superimposed if it is far enough from another 
% Spike
% 
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

%% First Part
       [amp_M1,Maxima1] = findpeaks(S_block(1,1:S_neighbor));
             
       if ~isempty(Maxima1)
        Dist_m = (S_neighbor - Maxima1) >= window;%round(0.002*Fs)
        Dist_a = (amp_M1 >= TH);
        final = and(Dist_m,Dist_a);
        Maxima1 = Maxima1(final);
     
         if ~isempty(Maxima1)
           Maxima1 = Maxima1(end);        %closest to peak
           inverted = 1.01*max(S_block(1,Maxima1:S_neighbor))...
             - S_block(1,Maxima1:S_neighbor);
           [~,Minima1] = findpeaks(inverted);
           if numel(Minima1)
           Minima1 = Minima1(1);
           Minima1 = Maxima1 + Minima1;
           S_block(1,1:Minima1) = 0; % make the uncorrelated zero
           template(1,1:Minima1) = 0;
           end
         else
           S_block(1,:) = S_block(1,:); %do nothing
           template(1,:) = template(1,:);
         end
        
       else
           S_block(1,:) = S_block(1,:);
           template(1,:) = template(1,:);
       end   
       
       %% 2nd Part
       
       [amp_M2,Maxima2] = findpeaks(S_block(1,S_neighbor:end));
        if ~isempty(Maxima2)
        Dist_m = (Maxima2 >= window);
        Dist_a = (amp_M2 >= TH);
        final = and(Dist_m,Dist_a);
        Maxima2 = Maxima2(final);
   
         if ~isempty(Maxima2)
           Maxima2 = Maxima2(1);        %closest to peak
           inverted = 1.01*max(S_block(1,S_neighbor:S_neighbor+Maxima2))...
             - S_block(1,S_neighbor:S_neighbor+Maxima2);
           [~,Minima2] = findpeaks(inverted);
           if numel(Minima2)
           Minima2 = Minima2(end);
           Minima2 = S_neighbor - Minima2;
           S_block(1,end-Minima2:end) = 0; % make the uncorrelated zero
           template(1,end-Minima2:end) = 0;
           end
         else
           S_block(1,:) = S_block(1,:);
           template(1,:) = template(1,:);
         end
        
        else
           S_block(1,:) = S_block(1,:);
           template(1,:) = template(1,:);
        end 
       

end




