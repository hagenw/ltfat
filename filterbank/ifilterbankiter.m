function [f,flag,relres,iter,resvec]=ifilterbankiter(c,g,a,varargin)
%IFILTERBANKITER  Iterative filter bank inversion
%   Usage:  f=ifilterbankiter(c,g,a);
%
%   The filter format for g is the same as for FILTERBANK.
%
%   If perfect reconstruction is desired, the filters must be the duals
%   of the filters used to generate the coefficients. See the help on
%   FILTERBANKDUAL.
%
%   See also: filterbank, ufilterbank, filterbankdual
%
%R  bohlfe02

  if nargin<3
    error('%s: Too few input parameters.',upper(mfilename));
  end;
  
  definput.keyvals.Ls=[];
  definput.keyvals.tol=1e-6;
  definput.keyvals.maxit=100;
  
  [flags,kv,Ls]=ltfatarghelper({'Ls'},definput,varargin);
  
  [a,M,longestfilter,lcm_a]=assert_filterbankinput(g,a,1);
  
  if iscell(c)
    Mcoef=numel(c);
  else
    Mcoef=size(c,2);
  end;

  if iscell(g)
    M=numel(g);
  else
    M=size(g,2);
  end;

  
  if ~(M==Mcoef)
    error(['Mismatch between the size of the input coefficients and the ' ...
           'number of filters.']);
  end;
  
  % Determine L from the first vector, it must match for all of them.
  L=a(1)*size(c{1},1);
  
  % In order for lsqr to work, the coefficients must be converted to a
  % long vector. cell2mat and mat2cell are used to convert back and forth
  % between the formats.
  % FIXME: This line will fail for large W.
  c_layout=cellfun(@length,c);
  
  % It is possible to specify the initial guess
  [f,flag,relres,iter,resvec]=lsqr(@apply_filterbank,cell2mat(c),kv.tol,kv.maxit);

  
  % Cut or extend f to the correct length, if desired.
  if ~isempty(Ls)
    f=postpad(f,Ls);
  else
    Ls=L;
  end;
  
  % This is a nested function, as it must use variables from the scope
  % or the main function
  function y=apply_filterbank(x, transp_flag)
    if strcmp(transp_flag,'transp') 
       % The transpose has the same structure as the inverse. Input is
       % set of coefficients, so we need to convert to the right format.
       c=mat2cell(x,c_layout);
       y = 2*real(ifilterbank(c,g,a));    
    elseif strcmp(transp_flag,'notransp')
      % This is the forward transform. Input is a solution vector. We
      % need to convert the output to vector format.
      y = cell2mat(filterbank(x,g,a));
    end
  end
end
  
    