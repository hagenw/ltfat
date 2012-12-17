function [tc,relres,iter,xrec] = framelasso(F,x,lambda,varargin)
%FRAMELASSO  Frame LASSO regression
%   Usage: [tc,xrec] = framelasso(F,x,lambda,C,tol,maxit)
%
%   Input parameters:
%       F        : Frame definition
%       x        : Input signal
%       lambda   : Regularization parameter, controls sparsity of the solution
%   Output parameters:
%       tc       : Thresholded coefficients
%       relres   : Vector of residuals.
%       iter     : Number of iterations done.  
%       xrec     : Reconstructed signal
%
%   `framelasso(F,x,lambda)` solves the LASSO (or basis pursuit denoising)
%   regression problem for a general frame: minimize a functional of the
%   synthesis coefficients defined as the sum of half the $l^2$ norm of the
%   approximation error and the $l^1$ norm of the coefficient sequence, with
%   a penalization coefficient *lambda*.
%
%   The solution is obtained via an iterative procedure, called Landweber
%   iteration, involving iterative soft thresholdings.
%  
%   `[tc,relres,iter] = framelasso(...)` return thes residuals *relres* in a vector
%   and the number of iteration steps done, *maxit*.
%
%   `[tc,relres,iter,xrec] = framelasso(...)` returns the reconstructed
%   signal from the coefficients, *xrec*. Note that this requires additional
%   computations.
%
%   The relationship between the output coefficients is given by ::
%
%     xrec = frsyn(F,tc);
%
%   The function takes the following optional parameters at the end of
%   the line of input arguments:
%
%     'C',cval   Landweber iteration parameter: must be larger than
%                square of upper frame bound. Default value is the upper
%                frame bound.
%
%     'tol',tol  Stopping criterion: minimum relative difference between
%                norms in two consecutive iterations. Default value is
%                1e-2.
%
%     'maxit',maxit
%                Stopping criterion: maximal number of iterations to do. Default value is 100.
%
%     'print'    Display the progress.
%
%     'quiet'    Don't print anything, this is the default.
%
%     'printstep',p
%                If 'print' is specified, then print every p'th
%                iteration. Default value is 10;
%
%   The parameters *C*, *itermax* and *tol* may also be specified on the
%   command line in that order: `framelasso(F,x,lambda,C,tol,maxit)`.
%
%   **Note**: If you do not specify *C*, it will be obtained as the upper
%   framebound. Depending on the structure of the frame, this can be an
%   expensive operation.
%  
%   See also: frame, frsyn, framebounds
%
%   References: dademo04

if nargin<2
  error('%s: Too few input parameters.',upper(mfilename));
end;

% Define initial value for flags and key/value pairs.
definput.keyvals.C=[];
definput.keyvals.tol=1e-2;
definput.keyvals.maxit=100;
definput.keyvals.printstep=10;
definput.flags.print={'print','quiet'};
definput.flags.startphase={'zero','rand','int'};

[flags,kv]=ltfatarghelper({'C','tol','maxit'},definput,varargin);

  
%   AUTHOR : Bruno Torresani.  
%   TESTING: OK

%   XXX Removed Remark: When the frame is an orthonormal basis, the solution
%   is obtained by soft thresholding of the basis coefficients, with
%   threshold lambda.  When the frame is a union of orthonormal bases, the
%   solution is obtained by applying soft thresholding cyclically on the
%   basis coefficients (BCR algorithm)

% Determine transform length, and calculate the window.
L = framelength(F,size(x,1));

% Accelerate frame, we will need it repeatedly
F=frameaccel(F,L);  

% Initialization of thresholded coefficients
c0 = frana(F,x);

if isempty(kv.C)
  [A_dummy,kv.C] = framebounds(F,L);
end;

% Various parameter initializations
threshold = lambda/kv.C;

tc0 = c0;
relres = 1e16;
iter = 0;

% Main loop
while ((iter < kv.maxit)&&(relres >= kv.tol))
    tc = c0 - frana(F,frsyn(F,tc0));
    tc = tc0 + tc/kv.C;
    tc = thresh(tc,threshold,'soft');
    relres = norm(tc(:)-tc0(:))/norm(tc0(:));
    tc0 = tc;
    iter = iter + 1;
    if flags.do_print
      if mod(iter,kv.printstep)==0        
        fprintf('Iteration %d: relative error = %f\n',iter,relres);
      end;
    end;
end

% Reconstruction
if nargout>3
  xrec = frsyn(F,tc);
end;
