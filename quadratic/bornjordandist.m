function p = bornjordandist(f);
%BORNJORDANDIST Born-Jordan distribution
%   Usage W = dbjd(f);
%
%   Input parameters:
%         f      : Input signal
%
%   Output parameters:
%         c      : Born-Jordan distribution
%
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'BORNJORDANDIST');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

H = round(Ls/2);

%% Computation of kernel
for n = 0 : (H -1)
  c(n+1, 1:(n+1)) = ones(1, (n+1))/(n+1);
end

c = [fliplr(c(:,2:H)) c]; 
c = [flipud(c(2:H,:)); c];
c = [zeros(length(c), 1) c; zeros(1, Ls)]; 

c = fftshift(c);


p = comp_quadratictfdist(f, c);

