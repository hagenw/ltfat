function y = dfft(f,alpha,p)
%DFFT  Discrete fractional Fourier transform
%   Usage: y=dfft(f,a,p);
% 
%   DFFT(f,alpha) will compute the discrete fractional Fourier transform
%   of order alpha applied to the signal f.
%
%   The code for this file was originally published on
%   http://nalag.cs.kuleuven.be/research/software/FRFT/
%
  
N = length(f);

even = ~rem(N,2);

f = f(:);

if (nargin == 2)
  p = round(N/2);
end;

p = min(max(2,p),N-1);

% Get the eigenvectors and eigenvalues
E = hermbasis2(N,p);
V = exp(-j*pi/2*alpha*([0:N-2 N-1+even])).';

y = E*(V .*(E'*f));

