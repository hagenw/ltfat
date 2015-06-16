function p = choiwilliamsdist(f, s);
%CHOIWILLIAMSDIST Choi-Williams distribution
%   Usage p = choiwilliamsdist(f);
%
%   Input parameters:
%         f      : Input vector
%         s      : sigma
%
%   Output parameters:
%         p      : Choi-Williams distribution
%
% `choiwilliamsdist(f)` computes a Choi-Williams distribution $c$ with respect to $s$. 
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'CHOIWILLIAMSDIST');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

for n = 1 : (Ls/2 -1)
  for m = 0 : (Ls/2 - 1)
      c(m+1,n+1) = exp(-(s*m^2)/(4*n^2));
  end
end

c(1, 1) = 1;

c = normalize(c, '1', 'dim', 1);

c = [fliplr(c(:,2:Ls/2)) c]; 
c = [flipud(c(2:Ls/2,:)); c];
c = [zeros(length(c), 1) c; zeros(1, Ls)]; 

c = fftshift(c);

p = comp_quadratictfdist(f, c);

