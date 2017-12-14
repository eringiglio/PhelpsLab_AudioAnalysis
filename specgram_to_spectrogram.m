function [song,window,noverlap,nfft,Fs] = specgram_to_spectrogram(song,nfft,Fs)
% Notes on translating specgram (which is depreciating) to spectrogram for
% future code wranglers. Please see M file itself for details. Otherwise,
% this program will take the exact inputs that you used to use for specgram
% and use spectrogram to create the graph. This will be useful as specgram
% has been depreciated for approximately five years now. 
%
% We've historically used specgram with three inputs, like so:
%     specgram(songs, 512, samp_freq);
%     
%     That's no good with spectrogram, though, and the reason for that is the 
%     way each program interprets 3-argument inputs. For spectrogram, unlike specgram,
%     we need to specify the window and overlap. Specgram used to do that for us--
%     at least, it would as long as we gave it a sampling frequency and the NFFT.

%     Now what we need to do is manually specify those. We can do that like
%     so...


% I do need you to pass all three arguments, so if there are fewer, prompt
% user to enter all.
if nargin<3                
    error('Error: Please submit all three of the arguments you would previously have passed to specgram.')
end
    
% These, of course, are the default values used by spectrogram...
window = hanning(nfft);
noverlap = length(window)/2;

% And here is the correct syntax for spectrogram vs specgram. Voila! If
% specgram is ever depreciated, simply do a find and replace all for uses
% of "specgram" with this program and everything should work fine again.
spectrogram(song,window,noverlap,nfft,Fs,'yaxis');
caxis([-180 -20])