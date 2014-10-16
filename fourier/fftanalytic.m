function z = fftanalytic(f);
%FFTANALYTIC Compute analytic representation
%   Usage z = fftanalytic(f);
%
%   `z = fftanalytic(f)` computes the analytic representation *z* of a real-valued  
%   function *f*. The analytic representation is computed through the FFT of f.
%
%   The real part of the analytic representation *z* equals the function *f* and 
%   the imaginary part is the Hilbert transform of *f*. 
%   The instananeous amplitude of the function *f* can be computed as::
%
%     abs(fftanalytic(f));
%
%   The instantaneous phase of the function *f* can be computed as::
%
%     arg(fftanalytic(f));
%

%   AUTHOR: Jordy van Velthoven

if ~isreal(f)
  error('The input should be real-valued');
end;
         
[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

z = comp_fftanalytic(f, Ls);