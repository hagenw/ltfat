function [g,fc]=erbgauss(M,fs,varargin);
%ERBGAUSS  Gammatone filter coefficients
%   Usage: g = erbgauss(fc,fs,n,bw);
%          g = erbgauss(fc,fs,n);
%          g = erbgauss(fc,fs);
%
%   Input parameters:
%      M     -  Number of channels
%      fs    -  sampling rate in Hz.
%      n     -  filter order.
%      bw    -  bandwidth of the filters in Erb.
%
%   Output parameters:
%      g     -  FIR filters as columns
%
%   ERBGAUSS(M,fs,n,bw) computes Gaussian filters placed on the
%   Erb-scale. M filters is computed with center frequencies
%   equidistantly spaced on the Erb-scale, lowest and highest center
%   frequencies are 0 and the Nyquest frequency. The bandwidth of each
%   filter measured in Erbs is determined by bw, and the length of each
%   filter in time (measured in samples) is given by n.
%
%   ERBGAUSS(fc,fs,n) will do the same but choose a filter bandwidth
%   based on the number of channels.
%
%   ERBGAUSS(fc,fs) will do as above and choose a sufficiently long
%   filter to accurately represent the lowest subband channel.
%
%   See also: erbspace, audspace, audfiltbw
%
%   Demos: demo_auditoryfilterbank
%  
%R  aertsen1980strI glasberg1990daf
  
%   AUTHOR : Peter L. Soendergaard

% ------ Checking of input parameters ---------

if nargin<2
  error('Too few input arguments.');
end;

if ~isnumeric(fs) || ~isscalar(fs) || fs<=0
  error('%s: fs must be a positive scalar.',upper(mfilename));
end;


definput.import={'normalize'};
definput.importdefaults={'null'};
definput.flags.real={'complex','real'};
definput.keyvals.n=[];

definput.keyvals.bw=freqtoerb(fs/2)/(M-1);

[flags,keyvals,n,bw]  = ltfatarghelper({'n','bw'},definput,varargin);


% ourbeta is used in order not to mask the beta function.

if isempty(n)
  % Calculate a good value for n
  % FIXME actually do this
  n=5000;
end;

g={};

% Compute the values in Erb of the channel frequencies of an FFT of
% length n.
audpoints   = freqtoerb(modcent(fs*(0:n-1)/n,fs)).';

% This one is necessary to represent the highest frequency filters, which
% overlap into the negative frequencies.
audpoints_p = 2*freqtoerb(fs/2)+audpoints;

if M==1
  delta_ch=0;
else
  delta_ch=freqtoerb(fs/2)/(M-1);
end;

for m = 0:M-1
   
  gf=exp(-pi*(audpoints-delta_ch*m).^2/bw)+exp(-pi*(audpoints_p-delta_ch*m).^2/bw);

  % Convert back to time-domain
  gf=ifft(gf);    

  g{m+1}=normalize(gf,'1');  
  
end;

fc=erbspace(0,fs/2,M);
