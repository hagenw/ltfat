function z = comp_fftanalytic(f, Ls);
%COMP_FFTANALYTIC Compute analytic representation
%   Usage z = comp_fftanalytic(f, Ls);
%
% `comp_fftanalytic(f)` computes the analytic representation of f.  
% The analytic representation is computed through the FFT of f.
%

% AUTHOR: Jordy van Velthoven

H = floor(Ls/2);

z = fft(f);
z(2:Ls-H) = 2*z(2:Ls-H);
z(H+2:Ls) = 0;
z = ifft(z);



