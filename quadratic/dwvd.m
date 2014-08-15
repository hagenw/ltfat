function W = dwvd(f);
%DWVD discrete Wigner-Ville distribution
%   Usage R = instaucorr(f);
%
%   Input parameters:
%         f      : Input signal.
%
%   Output parameters:
%         R      : discrete Wigner-Ville distribution
%
% `dwvd(f)` computes the discrete Wigner-Ville distribution. The
% discrete Wigner-Ville distribution is computed as the discrete 
% Fourier transform of the instantaneous autocorrelation function.

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DWVD');

R = instaucorr(f);

W = 2.*fft(R);