function[signal,a_new,fact]=rescale(signal,a,delta_x1);
% This routine calculates the parameters to transform the input for the
% fractional Fourier transform when the support of the input
% input is not N^2 with N=sqrt(length(signal))
% Parameters: signal   = the signal to be transformed
%             a        = the order of the transform
%             delta_x1 = the length of the support of the input signal.
% To compute the frft with these data use
% Output:     signal = possibly flipped signal to avoid infinite factor
%             a_new = compute the frft of order a_new
%             fact = and elementwise multiply the result with fact
N = length(signal);
delta_x2 = sqrt(N);
k = delta_x2/delta_x1;

a_new =  mod(a,4);

if k == 1 || a == 0
  a_new = a;
  fact = 1;
  return
elseif a == 2
  signal = flipud(signal)
else
  phi = a*pi/2;
  psi = acot(cot(phi)/k^2);
  c = csc(phi)/(k*csc(psi));
  x = linspace(-delta_x1/2,delta_x1/2,N);
  u = x;
  nu = c*u;
  a_new = 2*psi/pi;
  A_phi = exp(-i*(pi*sign(sin(phi))/4-phi/2))/sqrt(abs(sin(phi)));
  A_psi = exp(-i*(pi*sign(sin(psi))/4-psi/2))/sqrt(abs(sin(psi)));
  fact = A_phi/(k*A_psi)*exp(i*pi*(cot(phi)/c^2-cot(psi))*(nu.^2))';
end;




