function F=frame(ftype,varargin);
%FRAME  Construct a new frame
%   Usage: F=frame(ftype,...);
%
%   `F=frame(ftype,...)` constructs a new frame object *F* of type
%   *ftype*. Arguments following *ftype* are specific to the type of frame
%   chosen.
%
%   Time/frequency frames
%   ---------------------
%
%   `frame('dgt',g,a,M)` constructs a Gabor frame with window *g*,
%   time-shift *a* and *M* channels. See the help on |dgt|_ for more
%   information.
%
%   `frame('dgtreal',g,a,M)` constructs a Gabor frame for real-valued
%   signals with window *g*, time-shift *a* and *M* channels. See the help
%   on |dgtreal|_ for more information.
%
%   `frame('dwilt',g,M)` constructs a Wilson basis with window *g* and *M*
%   channels. See the help on |dwilt|_ for more information.
%
%   `frame('wmdct',g,M)` constructs a windowed MDCT basis with window *g*
%   and *M* channels. See the help on |wmdct|_ for more information.
%
%   `frame('filterbank',g,a,M)` constructs a filterbank with filters *g*,
%   time-shifts of *a* and *M* channels. For the ease of implementation, it
%   is necessary to specify *M*, even though it strictly speaking could be
%   deduced from the size of the windows. See the help on |filterbank|_ for
%   more information on the parameters. Similarly, you can construct a
%   uniform filterbank by selecting `'ufilterbank'`, a positive-frequency
%   filterbank by selecting `'filterbankreal'` or a uniform
%   positive-frequency filterbank by selecting `'ufilterbankreal'`.
%
%   Pure frequency frames
%   ---------------------
%
%   `frame('dft')` constructs a frame where the analysis operator is the
%   |dft|_, and the synthesis operator is its inverse, |idft|_. Completely
%   similar to this, you can enter the name of any of the cosine or sine
%   transforms |dcti|_, |dctii|_, |dctiii|_, |dctiv|_, |dsti|_, |dstii|_,
%   |dstiii|_ or |dstiv|_.
%
%   Special / general frames
%   ------------------------
%
%   `frame('gen',g)` constructs an general frame with analysis matrix *g*.
%   The frame atoms must be stored as column vectors in the matrices.
%
%   `frame('identity')` constructs the canonical orthornormal basis, meaning
%   that all operators return their input as output, so it is the dummy
%   operation.
%
%   `frame('randn',red,seed)` constructs a frame with redundancy *red*
%   constisting of random noise generated by `randn`. The optional parameter
%   *seed* specifies the initial seed for the noise generation. All frame
%   vectors are normalized to have unit energy / $l^2$-norm.
%
%   Container frames
%   ----------------
%
%   `frame('fusion',w,F1,F2,...)` constructs a fusion frame, which is
%   the collection of the frames specified by *F1*, *F2*,... The vector
%   *w* contains a weight for each frame. If *w* is a scalar, this weight
%   will be applied to all the sub-frames.
%
%   Examples
%   --------
%
%   The following example creates a Gabor frame for real-valued signals,
%   analyses an input signal and plots the frame coefficients:::
%
%      F=frame('wmdct','gauss',40);
%      c=frana(F,greasy);
%      plotframe(F,c);
%
%   See also: frana, frsyn, plotframe

  
if nargin<1
  error('%s: Too few input parameters.',upper(mfilename));
end;

if ~ischar(ftype)
  error(['%s: First agument must be a string denoting the type of ' ...
         'frame.'],upper(mfilename));
end;

ftype=lower(ftype);

% Handle the windowed transforms
switch(ftype)
 case {'dgt','dgtreal','dwilt','wmdct','filterbank','ufilterbank',...
       'nsdgt','unsdgt','nsdgtreal','unsdgtreal'}
  F.g=varargin{1};
  
 case {'filterbankreal','ufilterbankreal'}
  F.g=varargin{1};    
  
end;

switch(ftype)
  case {'dgt','dgtreal'}
    F.a=varargin{2};
    F.M=varargin{3};
    F.vars=varargin(4:end);
  case {'dwilt','wmdct'}
    F.M=varargin{2};
  case {'filterbank','ufilterbank','filterbankreal','ufilterbankreal'}
    F.a=varargin{2};
    F.M=varargin{3};
    
    % Sanitize 'a': Make it a column vector of length M
    F.a=F.a(:);
    [F.a,~]=scalardistribute(F.a,ones(F.M,1));
    
  case {'nsdgt','unsdgt','nsdgtreal','unsdgtreal'}
    F.a=varargin{2};
    F.M=varargin{3};
    
    % Sanitize 'a' and 'M'. Make M a column vector of length N,
    % where N is determined from the length of 'a'
    F.a=F.a(:);
    F.N=numel(F.a);
    F.M=F.M(:);
    [F.M,~]=scalardistribute(F.M,ones(F.N,1));
    
  case 'gen'
    F.g=varargin{1};
    
  case 'identity'
    
  case {'dft',...
        'dcti','dctii','dctiii','dctiv',...
        'dsti','dstii','dstiii','dstiv'}
    
  case 'fusion'
    F.w=varargin{1};
    F.frames=varargin(2:end);
    F.Nframes=numel(F.frames);
    [F.w,~]=scalardistribute(F.w(:),ones(F.Nframes,1));
    
  otherwise
    error('%s: Unknows frame type: %s',upper(mfilename),ftype);  
end;

F.type=ftype;
