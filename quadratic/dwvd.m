function d = dwvd(f);
%DWVD discrete Wigner-Ville distribution
%   Usage W = dwvd(f);
%
%   Input parameters:
%         f      : Input vector
%
%   Output parameters:
%         d      : discrete Wigner-Ville distribution
%
% `dwvd(f)` computes the discrete Wigner-Ville distribution of f. The discrete
% Wigner-Ville distribution is computed by
%
% .. math:: W\left( n+1,k+1 \right)\; =\; 2\sum_{m=0}^{L-1}{R\left( n+1,m+1 \right)e^{-i2\pi mk/L}}
%
% where $R(n,m)$ is given by
%
% .. math:: R\left( m,n \right)\; =\; z\left( n+m \right)\overline{z\left( n-m \right)}
%
% with $m \in {-L/2,\ldots, L/2 - 1} and $z$ as analytical representation of $f$.

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

R = comp_instcm(z,z,Ls);

d = 2*(fft(R));
