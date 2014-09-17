function A = daf(f);
%DAF discrete ambiguity function
%   Usage A = daf(f);
%
%   Input parameters:
%         f      : Input vector.
%
%   Output parameters:
%         A      : discrete ambiguity function
%
% `daf(f)` computes the discrete ambiguity function of f. The discrete
% ambiguity function is computed by
%
% .. math:: A\left( v+1,m+1 \right)\; =\; \frac{2}{L}\sum_{m=0}^{L-1}{R\left( n+1,m+1 \right)e^{i2\pi nv/L}}
%
% with $m \in {-L/2,\ldots, L/2 - 1} and $z$ as the analytical representation of $f$.

% AUTHOR: Jordy van Velthoven
% TESTING: TEST_DAF
% REFERENCE: REF_DAF

complainif_notenoughargs(nargin, 1, 'DAF');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

if isreal(f)
 z = comp_anarep(f, Ls);
else
 z = f;
end;

ia = comp_iaf(z, Ls);

A = 2*ifft(ia);