function R = iaf(f);
%IAF Instantaneous autocorrelation function
%   Usage R = iaf(f);
%
%   Input parameters:
%         f      : Input signal.
%
%   Output parameters:
%         R      : Instantaneous autocorrelation.
%
% `iaf(f)` computes the instantaneous autocorrelation function. The instantaneous
% autocorrelation function is given by
% 
% .. math:: math:: r(l+1, m+1) = \sum_{l=0}^{L-1} f(l+m+1)\overline{f(l-m+1)}
%
% For an input signal of length L the instantaneous autocorrelation is a L x L
% matrix in which the column represents the translation and each row the time index.
% 
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'iaf');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

R = comp_iaf(f, Ls);
