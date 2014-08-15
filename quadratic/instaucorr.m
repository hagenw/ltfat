function R = instaucorr(f);
%INSTAUCORR Instantaneous autocorrelation function
%   Usage R = instaucorr(f);
%
%   Input parameters:
%         f      : Input signal.
%
%   Output parameters:
%         R      : Instantaneous autocorrelation.
%
% `instaucorr(f)` computes the instantaneous autocorrelation function. 
%
% For an input signal of length L the instantaneous autocorrelation is a L x L
% matrix in which the column represents the translation and each row the time index.
% 


% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'instaucorr');

L = length(f);

R = zeros(L,L);

for l = 1 : L
    a = min([L-l, l-1, round(L/2)-1]);
    t = -a: a;
    R(t-t(1)+1, l) =  f(l+t).*conj(f(l-t));
end
