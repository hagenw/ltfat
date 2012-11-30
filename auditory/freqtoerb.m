function erb = freqtoerb(freq);
%FREQTOERB  Converts frequencies (Hz) to erbs
%   Usage: erb = freqtoerb(freq);
%
%   This is a wrapper around |freqtoaud|_ that selects the erb-scale. Please
%   see the help on |freqtoaud|_ for more information.
%
%   See also: freqtoaud
%
%   Demos: demo_audscales
  
%   AUTHOR: Peter L. Søndergaard

erb = freqtoaud(freq,'erb');

