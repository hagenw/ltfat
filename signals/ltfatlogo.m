function [s,fs]=ltfatlogo()
%LTFATLOGO  Load the 'ltfatlogo' test signal
%   Usage:  s=ltfatlogo;
%
%   `ltfatlogo` loads the 'ltfatlogo' signal. This is a sound synthezised
%   from an artificial spectrogram of the word 'LTFAT'. See the help of
%   |ltfattext|_.
%
%   `[sig,fs]=ltfatlogo` additionally returns the sampling frequency *fs*.
%
%   The signal is 7200 samples long and recorded at 8 kHz. It has been
%   scaled to not produce any clipping.
%
%   Examples:
%   ---------
%
%   To produce a spectrogram of the logo, use:::
%
%     c=dgtreal(ltfatlogo,'gauss',8,800);
%     plotdgtreal(c,8,800,8000,90);
%
%   See also: ltfattext
%
%   Demos: demo_isgram

%   AUTHOR : Peter L. Søndergaard
%   TESTING: TEST_SIGNALS
%   REFERENCE: OK
  
if nargin>0
  error('This function does not take input arguments.')
end;

f=mfilename('fullpath');

s = wavread([f,'.wav']);
fs=8000;
