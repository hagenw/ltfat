function [outsig, sigweight] = rangecompress(insig,varargin)
%RANGECOMPRESS   Compress the dynamic range of a signal 
%   Usage: [outsig, sigweight] = rangecompress(insig,mu);
%   
%   [outsig, sigweight]=RANGECOMPRESS(insig,mu) mu-law rangecompresss the input
%   signal insig using mu-law rangecompressing with parameters mu.
%
%   RANGECOMPRESS takes the following optional arguments:
%
%-     'mulaw'  - Do mu-law compression, this is the default.
%
%-     'alaw'   - Do A-law compression.
%
%-     'mu',mu  - mu-law parameter. Default value is 255.
%
%-     'A',A    - A-law parameter. Default value is 87.7.
%
%R  jano90

% AUTHOR: Bruno Torresani and Peter L. Soendergaard

if nargin<1
  error('%s: Too few input parameters.',upper(mfilename));
end;

definput.flags.method={'mulaw','alaw'};
definput.keyvals.mu=255;
definput.keyvals.A=87.7;
[flags,kv]=ltfatarghelper({},definput,varargin);

if flags.do_mulaw
  tmp = log(1+kv.mu);
  
  sigweight = max(abs(insig(:)));
  outsig = sign(insig) .* log(1+kv.mu*abs(insig))/tmp;

end;

if flags.do_alaw
  absx=abs(insig);
  tmp=1+log(kv.A);
  mask=absx<1/kv.A;

  outsig = sign(insig).*(mask.*kv.A.*absx./tmp+(1-mask).*(1+log(kv.A*absx))/tmp);
end;
