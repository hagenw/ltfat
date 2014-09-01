function p = dbjd(f, s);
%DBJD discrete Born-Jordan distribution
%   Usage W = dbjd(f);
%
%   Input parameters:
%         f      : Input signal
%
%   Output parameters:
%         c      : discrete Born-Jordan distribution
%
% `dbjd(f)` computes a discrete Born-Jordan distribution. The discrete
% Born-Jordan distribution is computed by
%
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DBJD');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

%%%% Computation of kernel
for n = 0 : (Ls/2 -1)
  c(n+1, 1:(n+1)) = ones(1, (n+1))/(n+1);
end

c = [fliplr(c(:,2:Ls/2)) c]; 
c = [flipud(c(2:Ls/2,:)); c];
c = [zeros(length(c), 1) c; zeros(1, Ls)]; 
%%%%

p = comp_dqtfd(f, c, Ls);

