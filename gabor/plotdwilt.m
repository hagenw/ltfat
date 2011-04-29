function plotdwilt(coef,varargin)
%PLOTDWILT  Plot DWILT coefficients.
%   Usage: plotdwilt(coef,);
%          plotdwilt(coef,fs);
%          plotdwilt(coef,fs,dynrange);
%
%   PLOTDWILT(coef) will plot coefficients from DWILT.
%
%   PLOTDWILT(coef,fs) will do the same assuming a sampling rate of
%   fs Hz of the original signal. Because a Wilson representation does
%   not contains coefficients for all positions on a rectangular TF-grid,
%   there will be visible 'holes' among the lowest (DC) and highest
%   (Nyquest rate) coefficients. See the help on WIL2RECT.
%
%   PLOTDWILT(coef,fs,dynrange) will additionally limit the dynamic
%   range.
%   
%   PLOTDWILT supports all the optional parameters of TFPLOT. Please
%   see the help of TFPLOT for an exhaustive list.
%
%   See also:  dwilt, tfplot, sgram, wil2rect

%   AUTHOR : Peter Soendergaard.
%   TESTING: NA
%   REFERENCE: NA

if nargin<1
  error('%s: Too few input parameters.',upper(mfilename));
end;

definput.import={'tfplot'};

[flags,kv,fs]=ltfatarghelper({'fs','dynrange'},definput,varargin);

M=size(coef,1)/2;

% Find smallest value in the coefficients, because we will be inserting
% zeros, which messes up the dynamic range. Set a minimum value of the
% dynamic range based on this
maxc=max(abs(coef(:)));
minc=min(abs(coef(:)));
if isempty(kv.dynrange)
  if flags.do_db
    kv.dynrange=20*log10(maxc/minc);
  end;
  if flags.do_dbsq
    kv.dynrange=10*log10(maxc/minc);
  end;
end;

coef=wil2rect(coef);

yr=[0,1];

tfplot(coef,M,yr,'argimport',flags,kv);