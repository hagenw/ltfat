function a = moyal(d,q);
%MOYAL Moyal's formula
%   Usage: a = moyal(d,q);
% 
%   'moyal(q)' computes Moyal's formula of the time-frequency
%   distribution *d* and *q*. 

%   AUTHOR: Jordy van Velthoven

[M1, N1] = size(d);
[M2, N2] = size(q);

if ~all(M1==N1)
  error('%s: The input(s) should be a square matrices.', upper(mfilename));
end

if all(size(d)==size(q))
   error('%s: The input(s) should have the same size.', upper(mfilename));
end

a = sum(sum(d .* q));