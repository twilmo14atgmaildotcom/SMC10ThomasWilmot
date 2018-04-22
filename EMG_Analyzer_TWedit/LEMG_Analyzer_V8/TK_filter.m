function [Index,loc,final_temps] = TK_filter(sig,Fs,C,PsC_TH,init,wind,gr)
%% For the visual interface Run LEMG_Analyzer.m 
%%% Function for Spike detection and Classification
% This is designed to filter out shallow peaks out of Action potentials
% with the help of Multi-dimensional TK operator. The function has several
% subroutins and uses template and label matching in order to cluster the
% action potentials in the signal. 
%% Inputs :
% Sig: EMG signal Vector
% Fs : Sampling Frequency (e.g. 2000 Hz)
% C : Threshold for the Spike Detection
% PsC_TH : Correlation Threshold, two templates are clustered in the same
% basket if their correlation score goes higher than this value
% init : Flag for filtering, leave it empty if you have no idea what this
% is
% wind: Windows length for storing the templates, it is an important factor
% for the analysis, so leave it empty if you have no idea about it.
% gr: Flags for plotting, set it 1 , if you want plots
%% Output:
% Index :Index of MUAPs clustered
% loc : location of the MUAPs in the signal
% final_temps: All the clustered Muap templates
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

% Input handling
if nargin < 7
    gr = 0;
 if nargin < 6
     wind = 0.020;     %def 10 milisec
  if nargin < 5 
     init = 1;       %flag for computing filters or not
   if nargin < 4
     PsC_TH = 0.1;                       
    if nargin < 3
      C = 0.1;                           % Default 0.6*STD(0.8-1.2)
    end
   end
  end
 end
end
%% Initialzie and highpass filter
% Detrends and band-pass filters the signal
if init
  [sig,Fs] = initialize(sig,Fs,1);
end

%% upsampling for better accuracy in Classification

upsample_flag = 0;
if (Fs < 10000) && (Fs > 4000)
   sig = resample(sig,5,1); % upsample by a factor of 3 
   Fs = 5*Fs;
   upsample_flag = 5;
elseif (Fs > 10000) && (Fs < 15000)
   sig = resample(sig,2,1); % upsample by a factor of 2 
   Fs = 2*Fs;
   upsample_flag = 2;
elseif Fs <= 3000
   sig = resample(sig,8,1);
   Fs = 8*Fs;
   upsample_flag = 8;
end


Index = [];
loc = [];
final_temps = struct;


%% MTEO
ks = [2;3;5];                        % Scales for MTEO (or 1,3,5) detection
if upsample_flag
 ks = ks.*2;                        
end
% 
%  f = (200:50:500);
%  ks = round((Fs./f)*1/2);
%  ks = unique(ks);
 
%% First Stage Spike detection
sig_TEO = MTEO(sig, ks);               % Compute MTEO
[locs,TH] = MTH(sig_TEO,ks,C,Fs);


%% Removing those peaks on begining and end of sig
A = locs > round((wind)*Fs);
locs = locs(A);
B = locs < (length(sig) - round((wind)*Fs));
locs = locs(B);
% if less than 1 spike persecond
if  isempty(locs)                %length(locs) < 100/(length(sig)/Fs)
    fprintf('No Spike Found!\n');
    return;
end

TH1 = mean(sig_TEO);                    % Threshold for features


locs_s = zeros(1,length(locs));        % for alignment
S_neighbor = round((wind/2)*Fs);       % Search Neighborhood window
                                       % Initiate original Signal
                                       
% output = runningAverage( sig,...       % Running mean with no delay
%     round(0.020*Fs), 2);         
template = zeros(length(locs),2*S_neighbor);   % storing templates
S_block = zeros(length(locs),2*S_neighbor);    % Store METO templates
features = zeros(length(locs),24);             % feature vector
window = round(0.002*Fs);                      % window to seperate spikes(def was 3.5 ms/ 2ms)

%% This loop removes the interference in the selected spikes and assigns a label to them
 for i = 1 : length(locs)
      %% Case 1      
      if   ((locs(i) - S_neighbor) >= 1)...
             && ((locs(i) + S_neighbor) <= length(sig_TEO))        
                                       % Find the Neighborhoods
       S_block(i,:) = sig_TEO((locs(i) - S_neighbor +1):(locs(i) + S_neighbor));
       [~,d] = findpeaks(abs(sig((locs(i) - S_neighbor+1):(locs(i) + S_neighbor))));
       [~,d_i] = min(abs(d-S_neighbor));
       if ~isempty(d) && ~isempty(d_i)
       locs_s(i) = locs(i)+(d(d_i)-S_neighbor);
         if locs_s(i) < S_neighbor
           locs_s(i) = locs(i);
         end
       else
           locs_s(i) = locs(i); 
       end
       template(i,:) = sig((locs_s(i) - S_neighbor+1):(locs_s(i) + S_neighbor));
       [S_block(i,:),template(i,:)] = spike_seperator(S_block(i,:),...
           template(i,:),S_neighbor,window,TH);
        features(i,:) = border_detector(S_block(i,:),template(i,:),TH,TH1);
     %% Case 2
     elseif (locs(i) - S_neighbor) < 1    
       S_block(i,1:(locs(i) + S_neighbor)) = sig_TEO(1:(locs(i) + S_neighbor));
       [~,d] = findpeaks(abs(sig(1:(locs(i) + S_neighbor))));
       [~,d_i] = min(abs(d-S_neighbor));
       if ~isempty(d) && ~isempty(d_i)
         locs_s(i) = locs(i)+(d(d_i)-S_neighbor);
         if locs_s(i) < S_neighbor
           locs_s(i) = locs(i);
         end
       else
            locs_s(i) = locs(i);
       end
       template(i,1:(locs_s(i) + S_neighbor)) = sig(1:(locs_s(i) + S_neighbor));
       [S_block(i,:),template(i,:)] = spike_seperator(S_block(i,:),...
           template(i,:),S_neighbor,window,TH);
       features(i,:) = border_detector(S_block(i,:),template(i,:),TH,TH1);
     %% Case 3                                  % Bounderies
     elseif (locs(i) + S_neighbor) > length(sig_TEO)
         
       first_half = length(sig((locs(i) - S_neighbor)+1:locs(i)));
       complete = length(sig_TEO((locs(i) - S_neighbor + 1):end));
       % locate the max in center
       S_block(i,(S_neighbor-first_half)+1:complete) =...
           sig_TEO((locs(i) - S_neighbor + 1):end);
       
       [~,d] = findpeaks(abs(sig((locs(i) - S_neighbor)+1:end)));
       [~,d_i] = min(abs(d-S_neighbor));
       if ~isempty(d) && ~isempty(d_i)
         locs_s(i) = locs(i)+(d(d_i)-S_neighbor);
         if locs_s(i) < S_neighbor
           locs_s(i) = locs(i);
         end
       else
            locs_s(i) = locs(i);
       end
       first_half = length(sig((locs_s(i) - S_neighbor)+1:locs_s(i)));
       complete = length(sig_TEO((locs_s(i) - S_neighbor + 1):end));
       template(i,(S_neighbor-first_half)+1:complete) =...
           sig((locs_s(i) - S_neighbor)+1:end);
       [S_block(i,:),template(i,:)] = spike_seperator(S_block(i,:),...
           template(i,:),S_neighbor,window,TH);                               
       features(i,:) = border_detector(S_block(i,:),template(i,:),TH,TH1);                            
      end                                                                 
 end


Index = locs;



%% Mapping features to the range of [1 9]

 map_range = [1,9];
% start from feature 6 which is period of each exterema
 for i = 6 : size(features,2)
     
    original_range(1) = min(features(:,i));
    original_range(2) = max(features(:,i));
    if ~isempty(original_range(~isnan(original_range)))
    features(:,i) = linear_map(features(:,i),original_range,map_range);
    end
    
 end
 
%% generates the initial set of labels
title  = generate_title(features);
  
%% Interference cancelation
%[y,template,Index,title] = inter_cancel(template,Index,title);
%% make templates
 uniq_c = merge_clusters(template,title,PsC_TH,Fs,length(sig));
 loc = ones(1,size(template,1)).*-1;
 to_plot = template;
 TH = PsC_TH;
 
 for i = 1 : size(uniq_c,1)
   [tmp, template] = findspikes(uniq_c(i,:), template,locs_s,Fs,TH);
   %%% removing too close MUAPs based on their firing pattern
   B = (locs_s(tmp));%to remove too close spikes
   B_i = find(tmp);
   fire_rate = diff(B);
   T_rate = fire_rate >= round(0.005*Fs);%5 milisec seperation
   B_F = [B_i(T_rate),B_i(end)];
   loc(B_F) = i;
 end
 
 
 noise_ind = find(loc == -1);
 noise = (loc == -1);
 new_sig = template(noise ,:);
 noise = locs_s(noise);
 

 if ~isempty(noise)
   TH = PsC_TH;        % 5 percent similarity (def was PsC_TH/2)
   for i = 1 : size(uniq_c,1)
    [tmp,new_sig] = findspikes(uniq_c(i,:),new_sig,noise,Fs,TH);
     loc(noise_ind(tmp)) = i;
%       A = (loc==i);
%       final_temps.(strcat('Template',mat2str(i))) = to_plot(A,:);
   end
   
 end
 
 
  %%% Double check the similarity of templates
    lag = round(0.008*Fs);                        %lag
    TH = 0.50;
  for i = 1:  size(uniq_c,1)
     if all(~isnan(uniq_c(i,:)))
       for j = 1 : size(uniq_c,1)
          if (i~=j) && (all(~isnan(uniq_c(j,:))))
             PsC_s = PsC_mex(uniq_c(i,:),uniq_c(j,:),lag);
               if  PsC_s > TH
                LG = (loc == j);
                loc(LG) = i;
                if j < max(loc)
                    rg = max(loc) - j;
                    for lk = 1:rg 
                        LG = (loc == (j+lk));
                        loc(LG) = (j + lk) - 1;
                    end
                end
                uniq_c(j,:) = NaN;
               end       
          end
       end
     end
  end  
%   %%%
% uniq_c = (uniq_c(isfinite(uniq_c(:, 1)), :)); %remove NaN
 for i = 1: max(loc)
 A = (loc==i);
   final_temps.(strcat('Template',mat2str(i))) = to_plot(A,:);
 end



 
 
 
if gr
 figure,subplot(2,2,[1,2]);plot(sig);
 cc = hsv(size(uniq_c,1));
 amps = zeros(size(uniq_c,1),1);
 fire_rate = zeros(size(uniq_c,1),1);
 for i = 1:length(loc)     
  text(Index(i),sig(Index(i)),mat2str(loc(i)));
 end
 subplot(2,2,3);
 
 for i = 1:size(uniq_c,1)
  A = (loc==i);
  B = (locs_s(A));
  A = to_plot(A,:);
  amps(i) = mean(max(A'));
  fire_rate(i) = 1/(mean(diff(B))/Fs);
  plot(A','color',cc(i,:));
  hold on
 end
subplot(2,2,4)
 bar(amps,fire_rate);
end

%%%% In case of upsampling its required to downsample everything again
if upsample_flag 
  if ~ isempty(Index)
    Index = round(Index./upsample_flag);   
    tempnames = fieldnames(final_temps);
    tempnr = length(tempnames);
   for j= 1: tempnr 
    [M,N] = size(final_temps.(tempnames{j,1}));
    ds_f = round(N/upsample_flag);
    final_temps1 = zeros(M,...
        ds_f);
    for i = 1: M
       final_temps1(i,:) = downsample(final_temps.(tempnames{j,1})(i,:),...
           upsample_flag);
    end
    
    final_temps.(tempnames{j,1}) = final_temps1;
   end
 end  
end


%% Thomas Wilmot_Save: Index, Loc and Final_Temps to Workspace
assignin('base','MUAP_label',loc);
assignin('base','MUAP_idx',Index);
assignin('base','Templates',final_temps);
% This version is edited by Thomas Michael Wilmot
% April 2018, Student of Sound and Music Computing MSc 
% at Aalborg University
end

