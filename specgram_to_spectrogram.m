function [matrix] = specgram_to_spectrogram(song,Fs,nfft)
% Notes on translating specgram (which is depreciating) to spectrogram for
% future code wranglers. Please see M file itself for details. Otherwise,
% this program will take the exact inputs that you used to use for specgram
% and use spectrogram to create the graph. This will be useful as specgram
% has been depreciated for approximately five years now.
%
%	Erin M Giglio, 12/14/2017.
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


% Setting defaults for arguments. Note this program is set to default to
% the maximum RX8 setting of sample rate.
if nargin<3
    nfft = 512;
end

if nargin<2
    Fs = 97656.25;
end

% These, of course, are the default values used by spectrogram...
window = hanning(nfft);
noverlap = length(window)/2;

% And here is the correct syntax for spectrogram vs specgram. Voila! If
% specgram is ever depreciated, simply do a find and replace all for uses
% of "specgram" with this program and everything should work fine again.
matrix = spectrogram(song,window,noverlap,nfft,Fs,'yaxis');
spectrogram(song,window,noverlap,nfft,Fs,'yaxis');
colormap(jet(20))
colorbar('off')
caxis([-180 -20])
