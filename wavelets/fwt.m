function [c, Lc] = fwt(f,h,J,varargin)
%FWT   Fast Wavelet Transform 
%   Usage:  c = fwt(f,h,J);
%           c = fwt(f,h,J,...);
%           [c,Lc] = fwt(...);
%
%   Input parameters:
%         f     : Input data.
%         h     : Analysis Wavelet Filterbank. 
%         J     : Number of filterbank iterations.
%
%   The following flags are supported:
%
%         'dec','undec'
%                Type of the wavelet transform.
%
%         'per','zpd','sym','symw','asym','asymw','ppd','sp0'
%                Type of the boundary handling.
%
%   Output parameters:
%         c      : Coefficients stored in J+1 cell-array.
%         [c,Lc] : Coefficients stored as one collumn vector, Lc array
%         defines lengths of coefficients vectors.
%
%   `c=fwt(f,h,J)` computes wavelet coefficients *c* of the input signal *f*
%   using basis constructed from the filters *h* and the depth *J* using MRA principle.
%   For computing the coefficients the fast wavelet transform algorithm (or Mallat's algorithm) is
%   emplyed. If *f* is a matrix, the transformation is applied to each of *W* columns. 
%   Coefficients in cell array *c{j}* for *j*=1,...,J+1 are ordered with inceasing central frequency
%   of the equivalent filter frequency response or equivalently with decreasing wavelet scale. 
%   The number of coefficients in *c\{j\}* for *j*=2,...,J+1 is as follows:
%
%   .. length(c{j}) = ceil(2^(j-2-J)length(f))
%
%   and length(c{1})=length(c{2}). 
%   If *f* is matrix with *W* collumns, each element of the cell array *c\{j\}* is a matrix
%   with *W* collumns with coefficients belonging to the appropriate input channel.
%
%   The proper name for the transform is dyadic (or critically subsampled)
%   discrete wavelet transform which is equivalent to the (bi)orthogonal
%   wavelet expansion provided appropriate (bi)orthogonal wavelet filterbank is supplied.
%
%   The transform is 2^J-shift invariant.
%
%   Time-invariant wavelet tranform:
%   --------------------------------
%
%   `c=fwt(f,h,J,'undec')` computes redundant time (or shift) invariant wavelet representation of the
%   input signal *f* using a-trous algorithm. length(c{j})=length(f) for all *j*.
%
%   Another names for this version of the wavelet transform are:
%   undecimated wavelet transform, stationary wavelet transform or even
%   "continuous" (as the time step is one sample) wavelet transform.
%                                                                                                                                                                                  The redundancy is exactly *J+1*.
%
%   Boundary handling:
%   ------------------
%
%   `fwt(f,h,J,ext)` computes slightly redundant wavelet
%   representation of the input signal *f* with the chosen boundary
%   extension *ext*.
%
%   The default periodic extension at the signal boundaries can result in
%   "false" hight wavelet coefficients near the boundaries due to the
%   possible discontinuity introduced by the periodic extension. Using
%   different kind of the boundary extension comes with a price of a slight
%   redundancy of the wavelet representation. 
%
%   For the *type*='dec' option, the number of coefficients in *c{j}* for *j*=2,...,J+1 is as
%   follows:
%
%   .. length(c{j}) = floor(2^(j-2-J)length(f) + (1-2^(j-2-J))(length(h{1})-1))
%
%   and length(c{1})=length(c{2}).
%
%   For the *type*='undec' option, the redundancy can become more than slight for the
%   number of coefficients in *c* grows as follows:
%
%   .. length(c{J+1}) = length(f) + length(h{1})-1
%
%   and for *j*=J,...,2
%
%   .. length(c{j}) = length(c{j+1}) + 2^(j-J+1)*(length(h{1})-1)
%
%   and length(c{1})=length(c{2}).
%
%   See also: ifwt
%
%   Demos:
%
%   References: mallat,  

%   AUTHOR : Zdenek Prusa.
%   TESTING: TEST_FWT
%   REFERENCE: REF_FWT

if nargin<3
  error('%s: Too few input parameters.',upper(mfilename));
end;

if ~isnumeric(J) || ~isscalar(J)
  error('%s: "J" must be a scalar.',upper(mfilename));
end;

if(J<1 && rem(a,1)~=0)
   error('%s: J must be a positive integer.',upper(mfilename)); 
end

do_definedfb = 0;
if(iscell(h))
    if(length(h)<2 || length(h) > 2)
       error('%s: h is expected to be a cell array containing two wavelet filters.',upper(mfilename)); 
    end

    if(length(h{1})< 2 && length(h{2})< 2)
        error('%s: Wavelet filters should have at least two coefficients.',upper(mfilename)); 
    end

    if(length(h{1})~=length(h{2}))
        error('%s: Wavelet filters have to have equal length.',upper(mfilename));
    end
elseif(isstruct(h))
    do_definedfb = 1;
elseif(ischar(h))
    h = waveletfb(h);
    do_definedfb = 1;
else
   error('%s: Unrecognized Wavelet filters definition.',upper(mfilename)); 
end


%% ----- step 1 : Verify f and determine its length -------
% Change f to correct shape.
[f,Ls,W,wasrow,remembershape]=comp_sigreshape_pre(f,upper(mfilename),0);
if(Ls<2)
   error('%s: Input signal seems not to be a vector of length > 1.',upper(mfilename));  
end

definput.import = {'fwt'};
[flags,kv]=ltfatarghelper({},definput,varargin);

if(do_definedfb)
    if(flags.do_type_null)
       flags.type = h.type; 
    end

    if(flags.do_ext_null)
       flags.ext = h.ext; 
    end
    
    h = h.h;
else
    % setting defaults
    if(flags.do_type_null)
       flags.type = 'dec'; 
    end

    if(flags.do_ext_null)
       flags.ext = 'per'; 
    end
end


%% ----- step 2 : Check whether the input signal is long enough
% input signal length is not restricted for expansive wavelet transform (extension type other than the default 'per')
flen = length(h{1});
if(strcmp(flags.ext,'per'))
   if(strcmp(flags.type,'dec'))
     minLs = (2^J-1)*(flen-1); % length of the longest equivalent filter -1
   else
     minLs = (2^(J-1))*(flen-1); % length of the longest upsampled filter - 1
   end
   if Ls<minLs
     error('%s: Input signal length is %d. Minimum signal length is %d or use %s flag instead. \n',upper(mfilename),Ls,minLs,'''ppd''');
   end;
end


%% ----- step 3 : Run computation
 c = comp_fwt_all(f,h,J,flags.type,flags.ext);
 
 % TO DO: integrate to previous function to avoid copying (if it turns out to cause serious slowdown)
if(nargout>1)
    [c,Lc] = cell2pack(c);
end

