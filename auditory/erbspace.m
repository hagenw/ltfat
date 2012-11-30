function [y,bw] = erbspace(flow,fhigh,n)
%ERBSPACE  Equidistantly spaced points on erbscale
%   Usage: y=erbspace(flow,fhigh,n);
%
%   This is a wrapper around |audspace|_ that selects the erb-scale. Please
%   see the help on |audspace|_ for more information.
%
%   See also: audspace, freqtoaud

%   AUTHOR : Peter L. Søndergaard
  
[y,bw] = audspace(flow,fhigh,n,'erb');

