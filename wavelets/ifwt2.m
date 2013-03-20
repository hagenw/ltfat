function f = ifwt2(c,g,J,Ls,varargin)
%IFWT2   Inverse Fast Wavelet Transform 
%   Usage:  f = ifwt2(c,g,J,Ls)
%           f = ifwt2(c,g,J,Ls,...)
%
%   Input parameters:
%         c     : Coefficients stored in J+1 cell-array.
%         g     : Synthesis wavelet filters.
%         J     : Number of filterbank iterations.
%         Ls    : Length of the reconstructed signal.
%
%   Output parameters:
%         f     : Reconstructed data.
%
%   `f = ifwt2(c,g,J)` reconstructs signal *f* from the wavelet coefficients
%   *c* using a *J*-iteration synthesis filter bank build from the basic synthesis
%   filterbank defined by *g*.
%
%   This function takes the same optional parameters as |fwt2|. Please see
%   the help on |fwt2| for a description of the parameters.
%   
%   See also:  fwt2, fwtinit
%
%   Demos: demo_imagecompression
%
%   References: ma98

if nargin<3
   error('%s: Too few input parameters.',upper(mfilename));
end;

if ~(iscell(c)||isnumeric(c))
  error('%s: Unrecognized coefficient format.',upper(mfilename));
end;

% Initialize the wavelet filters structure
g = fwtinit(g,'syn');


%% PARSE INPUT
definput.keyvals.Ls=[];    
definput.import = {'fwt','fwt2'};

[flags,kv]=ltfatarghelper({},definput,varargin);

if (numel(Ls)==1)
  Ls = [Ls,Ls];
end

Lcrows = fwtclength(Ls(1),g,J,'per');
Lccols = fwtclength(Ls(2),g,J,'per');
nFilts = numel(g.filts);

if flags.do_standard
  Jstep = 1;
  for jj=1:J-1
    LcIdx =  jj*(nFilts-1)+2;
    colRange = 1:Lcrows(LcIdx);
    rowRange = 1:Lccols(LcIdx);
    c(colRange,rowRange) = ifwt(c(colRange,rowRange),g,Jstep,Lcrows(LcIdx),'dim',1,'per');
    c(colRange,rowRange) = ifwt(c(colRange,rowRange),g,Jstep,Lccols(LcIdx),'dim',2,'per');
  end

  c = ifwt(c,g,Jstep,Ls(1),'dim',1,'per');
  f = ifwt(c,g,Jstep,Ls(2),'dim',2,'per');
  
end;

if flags.do_tensor
  f = ifwt(c,g,J,Ls(1),1,'per');
  f = ifwt(f,g,J,Ls(2),2,'per');
end;

%% ----- step 1 : Run calc -----------
% filtNo = length(g.filts);
% subbNo = filtNo^2-1;
% cTmp = cell(filtNo,1);
% cTmp{1} = c{1};
% cJidxTmp = 2;
% for jj=1:J
%    if (jj==J)
%      cLs = Ls;
%    else
%      cLs = size(c{cJidxTmp+subbNo});  
%    end
% 
%    cTmp{1} = comp_ifwt_all({cTmp{1},c{cJidxTmp:cJidxTmp+filtNo-1}},g.filts,1,g.a,cLs(1),'dec',flags.ext).'; 
%    cJidxTmp = cJidxTmp+filtNo-1;
%    for cc= 2:filtNo
%       cTmp{cc} = comp_ifwt_all({c{cJidxTmp:cJidxTmp+filtNo-1}},g.filts,1,g.a,cLs(1),'dec',flags.ext).';
%       cJidxTmp = cJidxTmp+filtNo;
%    end
%    
%    cTmp{1} = comp_ifwt_all(cTmp,g.filts,1,g.a,cLs(2),'dec',flags.ext).';  
% end
% f = cTmp{1};







