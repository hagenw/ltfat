function r = drd(f);
%DRD discrete Rihaczek distribution
%   Usage W = drd(f);
%
%   Input parameters:
%         f      : Input signal
%
%   Output parameters:
%         d      : discrete Rihaczek distribution
%
% `drd(f)` computes a discrete discrete Rihaczek distribution.
% The discrete Rihaczek distribution is given by
%
% .. math:: r\left( l,\; k \right)\; =\; \sum_{l\; =\; 0}^{L\; -\; 1}{f\left( l \right)\overline{f\left( l\; -\; h \right)}e^{-2\pi ikh/L}}
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DRD');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

c = comp_dgt_long(f, f, 1, Ls);

r = dsft(c);