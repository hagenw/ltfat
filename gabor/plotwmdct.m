function plotwmdct(coef,varargin)
%PLOTWMDCT  Plot WMDCT coefficients
%   Usage: plotwmdct(coef);
%          plotwmdct(coef,fs);
%          plotwmdct(coef,fs,dynrange);
%
%   `plotwmdct(coef)` plots coefficients from |wmdct|_.
%
%   `plotwmdct(coef,fs)` does the same assuming a sampling rate of
%   *fs* Hz of the original signal.
%
%   `plotwmdct(coef,fs,dynrange)` additionally limits the dynamic
%   range.
%   
%   |plotwmdct|_ supports all the optional parameters of |tfplot|_. Please
%   see the help of |tfplot|_ for an exhaustive list.
%
%   See also:  wmdct, tfplot, sgram, plotdgt

%   AUTHOR : Peter L. Søndergaard.
%   TESTING: NA
%   REFERENCE: NA

if nargin<1
  error('%s: Too few input parameters.',upper(mfilename));
end;

definput.import={'ltfattranslate','tfplot'};

[flags,kv,fs]=ltfatarghelper({'fs','dynrange'},definput,varargin);

M=size(coef,1);

yr=[.5/M, 1-.5/M];

tfplot(coef,M,yr,'argimport',flags,kv);

