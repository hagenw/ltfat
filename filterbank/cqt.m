function [coef,fc,g] = cqt(f,g,Q,a,M,corner,varargin)
%CQT  Constant-Q transform
%   Usage:  coef = cqt(f,g,Q,a,M,corner);
% 
%   CQT(f,g,Q,a,M,corner) computes the constant-Q transform of the input
%   signal f. The transform consists of M-1 filters logarithmically
%   spaced between corner and and the Nyquest frequency. corner is entered
%   using the Matlab-style normalized frequency, where the value 1 equals
%   the Nyquest frequency. A low-pass filter is added to capture the
%   signal below corner. Each channel is downsampled by a factor of _a.
  
  
if nargin<5
  error('%s: Too few input parameters.',upper(mfilename));
end;

if ~strcmp(lower(g),'gauss')
  error('%s: Only Gaussian windows are supported so far.', ...
        upper(mfilename));
end;

if corner<=0 || corner>=1
  error('%s: corner must have a value between 0 and 1.', ...
        upper(mfilename));
end;  

definput.keyvals.L=[];
[flags,kv,L]=ltfatarghelper({'L'},definput,varargin);

C2=Q;
fc=linexp(linspace(0,1,M)*C2,exp(C2),log(corner*exp(C2)),'hard');

% The sampling frequency of normalized frequencies are fs=2
g=linloggauss(fc,2,exp(C2),C2,'hard','corner',corner);

coef = ufilterbank(f,g,a);

