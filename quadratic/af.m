function  A = af(f)
%AF Ambiguity function
%   Usage: W = wd(f);
%
% `wd(f)` computes the Ambiguity function of  `f`. 
%
%
%   See also: wd, sgram

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'AF');

L = length(f);

% Gabor transform with f as window function
c = dgt(f,f,1, L);

% Modulation operator
M = exp(pi*i*([1:L]'/L));

% Ambiguity function
A = M .* c;
