function p = dqtfd(f, q);
%DQTFD discrete quadratic time-frequency distribution
%   Usage p = dqtfd(f);
%
%   Input parameters:
%         f      : Input vector
%         q	     : Kernel
%
%   Output parameters:
%         p      : discrete quadratic time-frequency distribution
% 
% For an input vector of length L, the kernel should be a L x L matrix.
% `dqtfd(f, q)` computes a discrete quadratic time-frequency distribution. 
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 2, 'DQTFD');

[M,N] = size(q);

if ~all(M==N)
  error('%s: The kernel should be a square matrix.', upper(mfilename));
end

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

p = comp_dqtfd(f, q, Ls);