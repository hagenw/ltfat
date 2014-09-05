function R = comp_iaf(f, Ls);
%COMP_IAF Compute instantaneous autocorrelation function
%   Usage R = iaf(f);
%
%   Input parameters:
%         f      : Input signal.
%	  Ls 	 : length of f.
%
%   Output parameters:
%         R      : Instantaneous autocorrelation.
%
% `comp_iaf(f)` computes the instantaneous autocorrelation function. 
%

% AUTHOR: Jordy van Velthoven


R = zeros(Ls,Ls);


for l = 0 : Ls-1;
   m = -min([Ls-l, l, round(Ls/2)-1]) : min([Ls-l, l, round(Ls/2)-1]);
   R(mod(Ls+m,Ls)+1, l+1) =  f(mod(l+m, Ls)+1).*conj(f(mod(l-m, Ls)+1));
end

