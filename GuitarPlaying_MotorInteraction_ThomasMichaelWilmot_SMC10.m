%% Guitar Playing and Motor Interaction 
% Thomas Michael Wilmot 
% Student of Sound and Music Computing MSc at Aalborg Univeristy
% Last updated: 22/04/18
% 
% This script is used to analyse electromyoneurograms recorded when a
% subject performed the simplified motion components that combine to create
% the strumming motion used in guitar playing.
%
% For more information contact: twilmo14@student.aau.dk

%% Import Data

load('DelsysData_Thomas_Wilmot_SMC10');

%% Calculate RMS muscle activity per muscle

% Flexor C Radialis

% Extensor C Ulnaris

% Extensor C Radialis

%% Create labelled time windows from EMG and IMU data

% Normalise motion data (max and min values are given by Delsys)

% Rest position (minimum muscle activity)

% Held pose position (prolonged muscle activity)

% Onsets of motion (IMU) 

% Offsets of motion (IMU)

% Start of contraction (EMG)

% End of contraction (EMG)

% Percentage muscle strength used (3EMG)

% Weight used during motion (none, 1kg or 2kg)

%% Save EMG data separately

%% Run EMG decomposition (LEMG_Analyzer.m)

%% Reference EMG data (if required)

%% Score spikes within time windows according to muscle and motion data

%% Compare spike counts from similar motions over increased weight applied during motion

%% Plot results