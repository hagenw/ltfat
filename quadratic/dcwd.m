function p = dcwd(f, s);
%DCWD discrete Choi-Williams distribution
%   Usage W = dwvd(f);
%
%   Input parameters:
%         f      : Input signal
%         s      : sigma
%
%   Output parameters:
%         c      : discrete Choi-Williams distribution
%
% `dcwd(f)` computes a discrete Choi-Williams distribution. The discrete
% Choi-Williams distribution is computed by
%
%

% AUTHOR: Jordy van Velthoven

complainif_notenoughargs(nargin, 1, 'DCWD');

[f,~,Ls,W,~,permutedsize,order]=assert_sigreshape_pre(f,[],[],upper(mfilename));

%%%% Computation of kernel
for n = 1 : (Ls/2 -1)
  for m = 0 : (Ls/2 - 1)
      c(m+1,n+1) = exp(-(s*m^2)/(4*n^2));
  end
end

c(1, 1) = 1;

c = normalize(c, '1', 'dim', 1);

c = [fliplr(c(:,2:Ls/2)) c]; 
c = [flipud(c(2:Ls/2,:)); c];
c = [zeros(length(c), 1) c; zeros(1, Ls)]; 
%%%%

p = comp_dqtfd(f, c, Ls);

