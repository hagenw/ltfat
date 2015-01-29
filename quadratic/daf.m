function A = daf(f,g);
%DAF discrete ambiguity function
%   Usage A = daf(f);
%         A = daf(f,g);
%
%   Input parameters:
%         f,g      : Input vector(s).
%
%   Output parameters:
%         A      : discrete ambiguity function
%
% `daf(f)` computes the discrete (symmetric) ambiguity function of f. The discrete
% ambiguity function as the two-dimensional Fourier transform of the discrete 
% Wigner distribution.
%

% AUTHOR: Jordy van Velthoven
% TESTING: TEST_DAF
% REFERENCE: REF_DAF

complainif_notenoughargs(nargin, 1, 'DAF');

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

A = fftshift(fft2(fft(R)));