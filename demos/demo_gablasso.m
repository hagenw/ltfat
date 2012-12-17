%DEMO_GABLASSO  Sparse regression by Lasso method

% Signals
t=(0:511)/512;
x0 = sin(2*pi*64*t);
x=x0';
x=x+randn(size(x))/2;

% DCGT parameters
a=2;
M=128;

% Regression parameters
lambda = 0.08;
maxit=500;
tol=1e-4;

F=frametight(frame('dgtreal','gauss',a,M));

% LASSO
[tcl,relres,iter,xrecl] = framelasso(F,x,lambda,'maxit',maxit,'tol',tol);

% GLASSO
[tcgl,relres,iter,xrecgl] = framegrouplasso(F,x,lambda,'maxit',maxit,'tol',tol);

% Displays
figure(1);
subplot(2,2,1);plot(x0); axis tight; grid; title('Original')
subplot(2,2,2);plot(x); axis tight; grid; title('Noisy')
subplot(2,2,3);plot(real(xrecl)); axis tight; grid; title('LASSO')
subplot(2,2,4);plot(real(xrecgl)); axis tight; grid; title('GLASSO')

dr=80;

figure(2);
subplot(2,2,1);
framegram(F,x0,'dynrange',dr);
title('Original')

subplot(2,2,2); 
framegram(F,x,'dynrange',dr);
title('Noisy')

subplot(2,2,3);
framegram(F,xrecl,'dynrange',dr);
title('LASSO')

subplot(2,2,4); 
framegram(F,xrecgl,'dynrange',dr);
title('Group LASSO')
