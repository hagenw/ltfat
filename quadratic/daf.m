function A = daf(f, g);
%DAF discrete ambiguity function
%   Usage A = daf(f);
%         A = daf(f, g);
%
%   Input parameters:
%         f, g      : Input vector(s).
%
%   Output parameters:
%         A      : discrete ambiguity function
%
% `daf(f)` computes the discrete  ambiguity function of f. The discrete
% ambiguity function is computed by
%
% .. math:: A\left( v+1,m+1 \right)\; =\; L^{-1}\sum_{m=0}^{L-1}{R\left( n+1,m+1 \right)e^{i2\pi nv/L}}
%
% where $R(n,m)$ is given by
%
% .. math:: R\left( m,n \right)\; =\; z\left( n+m \right)\overline{z\left( n-m \right)}
%
% with $m \in {-L/2,\ldots, L/2 - 1} and $z$ as the analytical representation of $f$ when f is real-valued.
%
% `daf(f,g)` computes the discrete cross-ambiguity function of f and g.

% AUTHOR: Jordy van Velthoven
% TESTING: TEST_DAF
% REFERENCE: REF_DAF

complainif_notenoughargs(nargin, 1, 'DAF');

if (nargin == 1)

  [f,~,Lf,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));
  
  if isreal(f)
    z1 = comp_analytic(f, Lf);
    z2 = z1;
  else
    z1 = f;
    z2 = z1;
  end
 
elseif (nargin == 2)
  [f,~,Lf,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));
  [g,~,Lg,W,~,permutedsize,order]=assert_sigreshape_pre(g,[],[],upper(mfilename));

  if ~all(size(f)==size(g))
  	error('%s: f and g must have the same length.', upper(mfilename));
  end;
  
  if isreal(f) || isreal(g)
    z1 = comp_analytic(f, Lf);
    z2 = comp_analytic(g, Lg);
  else
    z1 = f;
    z2 = g;
  end;
end

R = comp_instcm(z1, z2, Lf);


A = ifft(R);