function [g]=linloggauss(fc,fs,C1,C2,varargin);
%LINLOGGAUSS  Gaussian function on a linlog scale
%   Usage: g = linloggauss(fc,fs,n,bw);
%          g = linloggauss(fc,fs,n);
%          g = linloggauss(fc,fs);
%
%   Input parameters:
%      fc    -  Centre frequencies
%      fs    -  sampling rate in Hz.
%      n     -  filter order.
%      bw    -  bandwidth of the filters.
%
%   Output parameters:
%      g     -  FIR filters as columns
%
%   LINLOGGAUSS(fc,fs,n,bw) computes filters with have a Gaussian shape
%   on a frequency scale.  The default is to use the Erb-scale. The
%   bandwidth of each filter is given by bw units on the corresponding
%   scale, and the length of each filter in time (measured in samples) is
%   given by n.
%
%   LINLOGGAUSS(fc,fs,n) will do the same but choose a filter bandwidth
%   of 1 on the frequency scale.
%
%   LINLOGGAUSS(fc,fs) will do as above and choose a sufficiently long
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
definput.keyvals.corner=[];
definput.flags.cornertype={'soft','hard'};

definput.keyvals.bw=[];

[flags,kv,n,bw]  = ltfatarghelper({'n','bw'},definput,varargin);

M=length(fc);

if isempty(n)
  % Calculate a good value for n
  % FIXME actually do this
  n=5000;
end;

if isempty(bw)
  min_max = linlog([min(fc),max(fc)],C1,'argimport',flags,kv);
  bw=(min_max(2)-min_max(1))/(M-1);
end;

g={};

% Compute the values in Aud of the channel frequencies of an FFT of
% length n.
audpoints   = linlog(modcent(fs*(0:n-1)/n,fs),C1,'argimport',flags,kv).';

% This one is necessary to represent the highest frequency filters, which
% overlap into the negative frequencies.
audpoints_p = 2*linlog(fs/2,C1,'argimport',flags,kv)+audpoints;

fc_scale = linlog(fc,C1,'argimport',flags,kv);

for m = 1:M
  gf = exp(-pi*(audpoints-fc_scale(m)).^2/bw) ...
      +exp(-pi*(audpoints_p-fc_scale(m)).^2/bw);

  % Convert back to time-domain
  gf=ifft(gf);    

  g{m}=normalize(gf,'1');  
  
end;
