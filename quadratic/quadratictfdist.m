function p = quadratictfdist(f, q);
%QUADRATICTFDIST Quadratic time-frequency distribution
%   Usage p = quadratictfdist(f, q);;
%
%   Input parameters:
%         f      : Input vector
%	  q	 : Kernel
%
%   Output parameters:
%         p      : Quadratic time-frequency distribution
% 
% For an input vector of length L, the kernel should be a L x L matrix.
% `quadratictfdist(f, q);` computes a discrete quadratic time-frequency distribution. 
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 2, 'QUADRATICTFDIST');

[M,N] = size(q);

if ~all(M==N)
  error('%s: The kernel should be a square matrix.', upper(mfilename));
end

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

p = comp_quadratictfdist(f, q);