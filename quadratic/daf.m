function A = daf(f);
%DWVD discrete ambiguity function
%   Usage W = daf(f);
%
%   Input parameters:
%         f      : Input signal.
%
%   Output parameters:
%         R      : discrete ambiguity function
%
% `dwvd(f)` computes the discrete ambiguity function. The discrete
% ambiguity function is computed as the discrete Fourier transform
% with respect to the time index of the instantaneous autocorrelation 
% function.

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DAF');

R = iaf(f);

A = ifft(R);