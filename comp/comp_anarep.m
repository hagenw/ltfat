function z = comp_anarep(f, Ls);
%COMP_ANAREP Analytic representation
%   Usage z = comp_anarep(f);
%
% `comp_anarep(f)` computes the analytic representation of f.  
% The analytic representation is computed through the FFT of f.
%

% AUTHOR: Jordy van Velthoven

H = floor(Ls/2);

z = fft(f);
z(2:Ls-H) = 2*z(2:Ls-H);
z(H+2:Ls) = 0;
z = ifft(z);



