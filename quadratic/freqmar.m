function a = freqmar(q);
%TIMEMAR Frequency marginal
%   Usage: a = freqmar(q);
% 
%   'timemar(q)' computes the frequency marginal of the time-frequency
%   distribution q.
%
%   AUTHOR: Jordy van Velthoven

[M,N] = size(q);

if ~all(M==N)
  error('%s: The input should be a square matrix.', upper(mfilename));
end

a = real(sum(q, 2))/400;