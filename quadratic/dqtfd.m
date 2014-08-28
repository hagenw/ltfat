function p = dqtfd(f, q);
%DQTFD discrete quadratic time-frequency distribution
%   Usage p = dqtfd(f);
%
%   Input parameters:
%         f      : Input signal
%	  q	 : Kernel
%
%   Output parameters:
%         p      : discrete quadratic time-frequency distribution
%
% `dqtfd(f, q)` computes a discrete quadratic time-frequency distribution. A
% discrete quadratic time-frequency distribution with kernel q(p,m) is computed 
% by
%
% .. math:: p\left( l+1,\; k+1 \right)\; =\; 2 \sum_{\left| m\; <\; L/2 \right|}^{} \sum_{\left| h\; <\; L/2 \right|}^{} q(h, m) {z\left( l+ 1 + m -h \right) \overline{z\left( l - m + 1 -h\right)}e^{-i2\pi km/L}}
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 2, 'DQTFD');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

p = comp_dqtfd(f, q, Ls);