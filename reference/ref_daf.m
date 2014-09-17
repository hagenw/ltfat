function A=ref_daf(f)
%REF_DWVD  Reference discrete ambiguity function
%   Usage:  W=ref_daf(f)
%
%   REF_DWVD(f) computes the ambiguity function of f.

% AUTHOR: Jordy van Velthoven


L = length(f);
H = floor(L/2);
R = zeros(L,L);
A = zeros(L,L);

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

% 
for hh=0:L-1
  for ii=0:L-1
    for jj = 0:L-1
      A(hh+1, ii+1) = A(hh+1, ii+1) + R(jj+1, ii+1) .* exp(2*pi*i*hh*jj/L);
    end
  end
end

A = (2/L).*(A);