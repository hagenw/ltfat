function [f,relres,iter]=iabsfilterbank(s,g,a,varargin)
%IABSFILTERBANK  Spectrogram inversion
%   Usage:  f=iabsfilterbank(s,g,a);
%           f=iabsfilterbank(s,g,a,Ls);
%           [f,relres,iter]=iabsfilterbank(...);
%
%   Input parameters:
%         c       : Array of coefficients.
%         g       : Window function.
%         a       : Length of time shift.
%         Ls      : length of signal.
%   Output parameters:
%         f       : Signal.
%         relres  : Vector of residuals.
%         iter    : Number of iterations done.
%
%   IABSFILTERBANK(s,g,a) attempts to invert a spectrogram computed by
%
%C     s = abs(dgt(f,g,a,M)).^2;
%
%   by an iterative method.
%
%   IABSFILTERBANK(c,g,a,Ls) does as above but cuts or extends f to length Ls.
%
%   If the phase of the spectrogram is known, it is much better to use
%   IDGT.
%
%   [f,relres,iter]=IABSFILTERBANK(...) additionally return the residuals in a
%   vector relres and the number of iteration steps done.
%
%   Generally, if the spectrogram has not been modified, the iterative
%   algorithm will converge slowly to the correct result. If the
%   spectrogram has been modified, the algorithm is not guaranteed to
%   converge at all.  
%
%   IABSFILTERBANK takes the following parameters at the end of the line of input
%   arguments:
%
%-    'zero'     - Choose a starting phase of zero. This is the default
%
%-    'rand'     - Choose a random starting phase.
%
%     'griflim'  - Use the Griffin-Lim iterative method, this is the
%                  default.
%
%-    'bfgs'     - Use the limited-memory Broyden Fletcher Goldfarb
%                  Shanno (BFGS) method.  
%
%-    'tol',t    - Stop if relative residual error is less than the specified tolerance.  
%
%-    'maxit',n  - Do at most n iterations.
%
%-    'print'    - Display the progress.
%
%-    'quiet'    - Don't print anything, this is the default.
%
%-    'printstep',p - If 'print' is specified, then print every p'th
%                  iteration. Default value is p=10;
%
%   To use the BFGS method, please install the minFunc software from
%   http://www.cs.ubc.ca/~schmidtm/Software/minFunc.html
%
%   See also:  dgt, idgt
%
%   Demos: demo_iabsfilterbank
%
%R  griffin1984sem  decorsiere2011 liu1989limited
  
%   AUTHOR : Remi Decorsiere and Peter Soendergaard.
%   REFERENCE: OK

% Check input paramameters.

  if nargin<3
    error('%s: Too few input parameters.',upper(mfilename));
  end;
  
  if numel(g)==1
    error('g must be a vector (you probably forgot to supply the window function as input parameter.)');
  end;
  
  definput.keyvals.Ls=[];
  definput.keyvals.tol=1e-6;
  definput.keyvals.maxit=100;
  definput.keyvals.printstep=10;
  definput.flags.method={'griflim','bfgs'};
  definput.flags.print={'print','quiet'};
  definput.flags.startphase={'zero','rand'};
  
  [flags,kv,Ls]=ltfatarghelper({'Ls','tol','maxit'},definput,varargin);

  wasrow=0;
  
  if isnumeric(g)
    if size(g,2)>1
      if size(g,1)>1
        error('g must be a vector');
      else
        % g was a row vector.
        g=g(:);
        
        % If the input window is a row vector, and the dimension of c is
        % equal to two, the output signal will also
        % be a row vector.
        if ndims(s)==2
          wasrow=1;
        end;
      end;
    end;
  end;
  
  M=size(s,1);
  N=size(s,2);
  W=size(s,3);
    
  L=N*a;
  
  sqrt_s=sqrt(s);
  
  if flags.do_zero
    % Start with a phase of zero.
    c=sqrt_s;
  end;
  
  if flags.do_rand
    c=sqrt_s.*exp(2*pi*i*rand(M,N));
  end;
      
  gd = filterbankdual(g,a);
    
  % For normalization purposes
  norm_s=norm(s,'fro');
  
  relres=zeros(kv.maxit,1);
  if flags.do_griflim
    
    for iter=1:kv.maxit
      f=ifilterbank(c,gd,a);
      c=ufilterbank(f,g,a);
      
      relres(iter)=norm(abs(c).^2-s,'fro')/norm_s;
      
      c=sqrt_s.*exp(i*angle(c));
      
      if flags.do_print
        if mod(iter,kv.printstep)==0
          fprintf('IABSFILTERBANK: Iteration %i, residual = %f.\n',iter,relres(iter));
        end;    
      end;
      
      if relres(iter)<kv.tol
        relres=relres(1:iter);
        break;
      end;
      
    end;
  end;
  
  if flags.do_bfgs
    if exist('minFunc')~=2
      error(['To use the BFGS method in IABSFILTERBANK, please install the minFunc ' ...
             'software from http://www.cs.ubc.ca/~schmidtm/Software/minFunc.html.']);
    end;
    
    % Setting up the options for minFunc
    opts = struct;
    opts.display = kv.printstep;
    opts.maxiter = kv.maxit;
    opts.usemex = 0;
    
    f0 = comp_idgt(c,gd,a,M,L,0);
    [f,fval,exitflag,output]=minFunc(@objfun,f0,opts,g,a,M,s);
    % First entry of output.trace.fval is the objective function
    % evaluated on the initial input. Skip it to be consistent.
    relres = output.trace.fval(2:end)/norm_s;
    iter = output.iterations;
  end;

    
  % Cut or extend f to the correct length, if desired.
  if ~isempty(Ls)
    f=postpad(f,Ls);
  else
    Ls=L;
  end;
  
  f=comp_sigreshape_post(f,Ls,wasrow,[0; W]);

%  Subfunction to compute the objective function for the BFGS method.
function [f,df]=objfun(x,g,a,M,s);
  L=size(s,2)*a;
  c=comp_dgt(x,g,a,M,L,0);
  
  inner=abs(c).^2-s;
  f=norm(inner,'fro')^2;
  
  df=4*real(conj(comp_idgt(inner.*c,g,a,M,L,0)));




