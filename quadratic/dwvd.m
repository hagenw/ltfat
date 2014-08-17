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
% `dqtfd(f, q)` computes a discrete Wigner-Ville distribution. The discrete
% Wigner-Ville distribution is computed by
%
% .. math:: w\left( l+1,\; k+1 \right)\; =\; 2 \sum_{\left| m\; <\; L/2 \right|}^{}{z\left( l+ 1 + m \right) \overline{z\left( l - m + 1 \right)}e^{-i2\pi km/L}}
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DWVD');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

if isreal(f)
 z = comp_anarep(f, Ls);
else
 z = f;
endif;

ia = comp_iaf(z, Ls);

d = 2*(fft(ia));
