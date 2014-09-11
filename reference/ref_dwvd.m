function W=ref_dwvd(f)
%REF_DWVD  Reference Discrete Wigner-Ville distribution
%   Usage:  W=ref_dwvd(f)
%
%   REF_DWVD(f) computes the discrete Wigner-Ville distribution of f.
%   The DWVD is computed as the matrix product of the instantaneous 
%   autocorrelation matrix R and the Fourier matrix F.

% AUTHOR: Jordy van Velthoven


L = length(f);
H = floor(L/2);
R = zeros(L,L);
W = zeros(L,L);

% Compute the analytic representation of f
if isreal(f)
  z = fft(f);
  z(2:L-H) = 2*z(2:L-H);
  z(H+2:L) = 0;
  z = ifft(z);
else
  z = f;
end

% Compute instantaneous autocorrelation matrix R
for l = 0 : L-1;
  for m = -min([L-l, l, round(L/2)-1]) : min([L-l, l, round(L/2)-1]);
    R(mod(L+m,L)+1, l+1) =  z(mod(l+m, L)+1).*conj(z(mod(l-m, L)+1));
  end
end

% Compute the Discrete Wigner-Ville distribution W
for hh=0:L-1
  for ii=0:L-1
    for jj = 0:L-1
      W(hh+1, ii+1) = W(hh+1, ii+1) + R(jj+1, ii+1) .* exp(-2*pi*i*hh*jj/L);
    end
  end
end

W = 2*W;