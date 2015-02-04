function W = dwvd(f,g);
%DWVD discrete Wigner-Ville distribution
%   Usage W = dwvd(f);
%         W = dwvd(f, g);
%
%   Input parameters:
%         f,g      : Input vector(s)
%
%   Output parameters:
%         w      : discrete Wigner-Ville distribution
%
%   `dwvd(f)` computes the discrete Wigner-Ville distribution of f. The discrete
%   Wigner-Ville distribution is computed by
%
% .. math:: W\left( n+1,k+1 \right)\; =\; \sum_{m=0}^{L-1}{R\left( n+1,m+1 \right)e^{-i2\pi mk/L}}
%
%   where $R(n,m)$ is given by
%
% .. math:: R\left( m,n \right)\; =\; z\left( n+m \right)\overline{z\left( n-m \right)}
%
%   with $m \in {-L/2,\ldots, L/2 - 1} and $z$ as analytical representation of 
%   $f$, when f is real-valued.
%
%   `dwvd(f,g)` computes the discrete cross-Wigner-Ville distribution of f and g.
%
%   **WARNING**: The quadratic time-frequency distributions are highly 
%   redundant. For an input vector of length L, the quadratic time-frequency
%   distribution will be a $L \times L$ matrix.

% AUTHOR: Jordy van Velthoven
% TESTING: TEST_DWVD
% REFERENCE: REF_DWVD

complainif_notenoughargs(nargin, 1, 'DWVD');


if (nargin == 1)

  [f,~,Lf,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));
  
  if isreal(f)
    z1 = comp_fftanalytic(f, Lf);
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
    z1 = comp_fftanalytic(f, Lf);
    z2 = comp_fftanalytic(g, Lg);
  else
    z1 = f;
    z2 = g;
  end;
end

R = comp_instcm(z1, z2, Lf);

W = fft(R);