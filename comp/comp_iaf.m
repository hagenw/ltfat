function R = comp_iaf(f, Ls);
%COMP_IAF Compute instantaneous autocorrelation function
%   Usage R = iaf(f);
%
%   Input parameters:
%         f      : Input signal.
%	  L 	 : length of f.
%
%   Output parameters:
%         R      : Instantaneous autocorrelation.
%
% `comp_iaf(f)` computes the instantaneous autocorrelation function. 
%

% AUTHOR: Jordy van Velthoven


R = zeros(Ls,Ls);

for l = 1 : Ls
    a = min([Ls-l, l-1, round(Ls/2)-1]);
    m = -a: a;
    R(m-m(1)+1, l) =  f(l+m).*conj(f(l-m));
end
