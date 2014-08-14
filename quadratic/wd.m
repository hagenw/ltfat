function W = wd(f);
%WD Wigner Distribution
%   Usage: W = wd(f);
%
% `wd(f)` computes the Wigner distribution of  `f`.  
%
%   See also: af, sgram

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'WD');

% Ambiguity function of f
A = af(f);

%Wigner Distribution
W = dsft(A);
