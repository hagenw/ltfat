function A = daf(f);
%DAF discrete ambiguity function
%   Usage W = daf(f);
%
%   Input parameters:
%         f      : Input signal.
%
%   Output parameters:
%         R      : discrete ambiguity function
%
% `daf(f)` computes the discrete ambiguity function. The discrete
% ambiguity function is computed by
%
% .. math:: w\left( l+1,\; k+1 \right)\; = \; 2 \sum_{\left| l\; <\; L/2 \right|}^{}{z\left( l + m + 1\right) \overline{z\left( l - m + 1 \right)}e^{-i2\pi kl/L}}
%
% 

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DAF');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

if isreal(f)
 z = comp_anarep(f, Ls);
else
 z = f;
end;

ia = comp_iaf(z, Ls);

A = 2*ifft(ia);