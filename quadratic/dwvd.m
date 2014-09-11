function d = dwvd(f);
%DWVD discrete Wigner-Ville distribution
%   Usage W = dwvd(f);
%
%   Input parameters:
%         f      : Input signal
%
%   Output parameters:
%         d      : discrete Wigner-Ville distribution
%
% `dwvd(f)` computes the discrete Wigner-Ville distribution of f. The discrete
% Wigner-Ville distribution is computed by
%
% .. math:: w\left( n+1,k+1 \right)\; =\; 2\sum_{m=0}^{L-1}{r\left( n+1,m+1 \right)e^{-i2\pi mk/L}}
%
% where $r(n,m)$ is given by
%
% .. math:: r\left( m,n \right)\; =\; f\left( n+m \right)\overline{f\left( n-m \right)}
%
% with $m \in {-L/2,\ldots, L/2 -1}. 

% AUTHOR: Jordy van Velthoven
% TESTING: TEST_DWVD
% REFERENCE: REF_DWVD

complainif_notenoughargs(nargin, 1, 'DWVD');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

if isreal(f)
 z = comp_anarep(f, Ls);
else
 z = f;
end;

ia = comp_iaf(z, Ls);

d = 2*(fft(ia));
