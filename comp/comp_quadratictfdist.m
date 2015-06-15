function p = comp_quadratictfdist(f, q);;
% Comp_QUADRATICTFDIST Compute quadratic time-frequency distribution
%   Usage p = comp_quadratictfdist(f, q);;
%
%   Input parameters:
%         f      : Input vector
%	  q	 : Kernel
%
%   Output parameters:
%         p      : Quadratic time-frequency distribution
%

% AUTHOR: Jordy van Velthoven

if isreal(f)
 z = comp_fftanalytic(f);
else
 z = f;
end;

R = comp_instcorrmat(z,z);

c = fftshift(ifft2(fft2(R).*fft2(q)));

p = fft(c);