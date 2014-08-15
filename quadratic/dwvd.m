function W = dwvd(f);
%DWVD discrete Wigner-Ville distribution
%   Usage W = dwvd(f);
%
%   Input parameters:
%         f      : Input signal.
%
%   Output parameters:
%         R      : discrete Wigner-Ville distribution
%
% `dwvd(f)` computes the discrete Wigner-Ville distribution. The
% discrete Wigner-Ville distribution is computed as the discrete 
% Fourier transform with respect to the translation of the 
% instantaneous autocorrelation function.

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DWVD');

R = iaf(f);

W = 2.*fft(R);