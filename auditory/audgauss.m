function b=audgauss(M,fs,varargin);
%AUDGAUSS  Gammatone filter coefficients
%   Usage: b = audgauss(fc,fs,n,betamul);
%          b = audgauss(fc,fs,n);
%          b = audgauss(fc,fs);
%
%   Input parameters:
%      fc    -  center frequency in Hz.
%      fs    -  sampling rate in Hz.
%      n     -  filter order.
%      beta  -  bandwidth of the filter.
%
%   Output parameters:
%      b     -  FIR filters as columns
%
%   AUDGAUSS(fc,fs,n,betamul) computes the filter coefficients of a digital
%   FIR gammatone filter of length n with center frequency fc, 4th order
%   rising slope, sampling rate fs and bandwith determined by betamul. The
%   bandwidth _beta of each filter is determined as betamul times AUDFILTBW
%   of the center frequency of corresponding filter.
%
%   AUDGAUSS(fc,fs,n) will do the same but choose a filter bandwidth
%   according to Glasberg and Moore (1990).  betamul is choosen to be 1.0183.
%
%   AUDGAUSS(fc,fs) will do as above and choose a sufficiently long
%   filter to accurately represent the lowest subband channel.
%
%   If fc is a vector, each entry of fc is considered as one center
%   frequency, and the corresponding coefficients are returned as column
%   vectors in the output.
%
%   The inpulse response of the gammatone filter is given by
%
%M    g(t) = a*t^(n-1)*cos(2*pi*fc*t)*exp(-2*pi*beta*t)
%F  \[g(t) = at^{n-1}cos(2\pi\cdot fc\cdot t)e^{-2\pi \beta \cdot t}\]
%
%   The gammatone filters as implemented by this function generate
%   complex valued output, because the filters are modulated by the
%   exponential function. Using REAL on the output will give the
%   coefficients of the corresponding cosine modulated filters.
%
%   To create the filter coefficients of a 1-erb spaced filter bank using
%   gammatone filters use the following construction
%
%C    g = audgauss(fs,erbspacebw(flow,fhigh));
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

definput.keyvals.bw=1;

[flags,keyvals,n,bw]  = ltfatarghelper({'n','bw'},definput,varargin);


% ourbeta is used in order not to mask the beta function.

if isempty(n)
  % Calculate a good value for n
  % FIXME actually do this
  n=5000;
end;

b={};

audpoints=fftshift(freqtoerb(fs*((0:n-1)/n-.5))).';
audpoints_neg=fftshift(-freqtoerb(fs*((0:n-1)/n-.5))).';

if M==1
  delta_ch=0;
else
  delta_ch=freqtoerb(fs/2)/(M-1);
end;

for m = 0:M-1
 
if 1
  gf=exp(-pi*(audpoints-delta_ch*m).^2/bw)+...
	  exp(-pi*(audpoints_neg-delta_ch*m).^2/bw);
else
  gf =zeros(n,1);
  for kk=-1:0
     % Calculate equidistantly spaced frequency points,
     % convert them to erb-scale and shift as desired
     audpoints=(freqtoerb(fs*(kk+(0:n-1)/n))-delta_ch*m).';
     
     gpart=exp(-pi*(audpoints).^2/bw);
     % Periodize (alias) in frequency
     gf=gf+gpart;
  end;
end;

  % Convert back to time-domain
  g=ifft(gf);
    

  b{m+1}=normalize(g,'1');  
  
end;
