function p = dwvd(f);
%DWVD discrete Wigner-Ville distribution
%
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DWVD');

L = length(f);

W = zeros(L,L);

for l = 1 : L
    a = min([L-l, l-1, round(L/2)-1]);
    t = -a: a;
    W(t-t(1)+1, l) =  f(l+t).*conj(f(l-t));
end

p = real(2.*fft(W));