function d = dcaf(f, g);
%DCAF discrete cross ambiguity function
%   Usage W = dwvd(f);
%
%   Input parameters:
%         f, g      : Input signals
%
%   Output parameters:
%         d      : discrete cross ambiguity function
%
% `dcaf(f)` computes a discrete cross ambiguity function. %
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 2, 'DCAF');

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
endif;

R = zeros(Ls,Ls);

for l = 1 : Ls
    a = min([Ls-l, l-1, round(Ls/2)-1]);
    m = -a: a;
    R(m-m(1)+1, l) =  z1(l+m).*conj(z2(l-m));
end


d = 2*(ifft(R));
