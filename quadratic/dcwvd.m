function d = dcwvd(f, g);
%DCWVD discrete cross Wigner-Ville distribution
%   Usage W = dwvd(f);
%
%   Input parameters:
%         f, g      : Input signals
%
%   Output parameters:
%         d      : discrete cross Wigner-Ville distribution
%
% `dcwvd(f)` computes a discrete cross Wigner-Ville distribution. The discrete
% cross Wigner-Ville distribution is computed by
%
% .. math:: w\left( l+1,\; k+1 \right)\; =\; 2 \sum_{\left| m\; <\; L/2 \right|}^{}{z_2\left( l+ 1 + m \right) \overline{z_2\left( l - m + 1 \right)}e^{-i2\pi km/L}}
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 2, 'DCWVD');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

[g,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(g,[],[],upper(mfilename));

if ~all(size(f)==size(g))
 error('%s: f and g must have the same size.', upper(mfilename));
end;

if isreal(f) || isreal(g)
 z1 = comp_anarep(f, Ls);
 z2 = comp_anarep(g, Ls);
else
 z1 = f;
 z2 = g;
end;

R = zeros(Ls,Ls);

for l = 1 : Ls
    a = min([Ls-l, l-1, round(Ls/2)-1]);
    m = -a: a;
    R(m-m(1)+1, l) =  z1(l+m).*conj(z2(l-m));
end

d = 2*(fft(R));
