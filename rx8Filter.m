function y = rx8Filter(x)
%rx8Filter Filters input x and returns output y.

% This function exists in order to filter songs recorded on the RX8 with a
% sampling frequency (Fs) of 97656.25. All recording from frequencies below
% ~7500 Hz are removed (at about 0.75 x 10^4 on a usual spectrogram), which
% makes the recording cleaner and in particular aids in identification of
% songs on an oscillogram. 

% To generate this code, use the DSP system toolbox and select a
% Butterworth Highpass filter. 

% Erin Giglio, 4/22/19.

% MATLAB Code
% Generated by MATLAB(R) 9.6 and DSP System Toolbox 9.8.
% Generated on: 22-Apr-2019 11:23:30

%#codegen

% To generate C/C++ code from this function use the codegen command.
% Type 'help codegen' for more information.

persistent Hd;

if isempty(Hd)
    
    % The following code was used to design the filter coefficients:
    %
    % N    = 10;        % Order
    % F3dB = 7500;      % 3-dB Frequency
    % Fs   = 97656.25;  % Sampling Frequency
    %
    % h = fdesign.highpass('n,f3db', N, F3dB, Fs);
    %
    % Hd = design(h, 'butter', ...
    %     'SystemObject', true);
    
    Hd = dsp.BiquadFilter( ...
        'Structure', 'Direct form II', ...
        'SOSMatrix', [1 -2 1 1 -1.65172867773102 0.864642639635419; 1 -2 1 1 ...
        -1.46334820545312 0.651979224741776; 1 -2 1 1 -1.33393376011079 ...
        0.505882776684966; 1 -2 1 1 -1.25339863562133 0.414966375501158; 1 -2 1 ...
        1 -1.21483895237904 0.371436205859031], ...
        'ScaleValues', [0.87909282934161; 0.778831857548723; ...
        0.709954134198938; 0.667091252780621; 0.646568789559519; 1]);
end

s = double(x);
y = step(Hd,s);

