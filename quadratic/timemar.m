function a = timemar(q);
%TIMEMAR Time marginal
%   Usage: a = timemar(q);
% 
%   'timemar(q)' computes the time marginal of the time-frequency
%   distribution q.
%
%   AUTHOR: Jordy van Velthoven

[M,N] = size(q);

if ~all(M==N)
  error('%s: The input should be a square matrix.', upper(mfilename));
end

s = real(sum(q, 1))/M;

a = s';

