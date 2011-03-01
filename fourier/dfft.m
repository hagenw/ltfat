function y = dfft(f,alpha,varargin)
%DFFT  Discrete fractional Fourier transform
%   Usage: y=dfft(f,a,p);
% 
%   DFFT(f,alpha) will compute the discrete fractional Fourier transform
%   of order alpha applied to the signal f.
%
%   The code for this file was originally published on
%   http://nalag.cs.kuleuven.be/research/software/FRFT/
%
%R   bultheel2004computation  
  
%   AUTHOR : A. Bultheel
%   TESTING: TEST_DFFT
%   REFERENCE: OK
  
if nargin<2
  error('%s: Too few input parameters.',upper(mfilename));
end;

N = length(f);

definput.keyvals.p=round(N/2);
definput.flags.center={'start','middle'};
[flags,kv]=ltfatarghelper({},definput,varargin);

  

even = ~rem(N,2);

f = f(:);

if flags.do_middle
  f=fftshift(f);
end;

% Get the eigenvectors and eigenvalues
E = hermbasis(N,kv.p);
V = exp(-j*pi/2*alpha*([0:N-2 N-1+even])).';

y = E*(V .*(E'*f));

if flags.do_middle
  y=ifftshift(y);
end;