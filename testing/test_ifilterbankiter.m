% This example constructs uniform constant-Q filterbank with Gaussians FIR
% filters in each channel. The code has not yet been tested for a
% non-uniform filterbank.

[f,fs]=greasy;
Q=3;
a=4;
M=40;
corner=0.1;

C2=Q;
fc=linexp(linspace(0,1,M)*C2,exp(C2),log(corner*exp(C2)),'hard');

% The sampling frequency of normalized frequencies are fs=2
g=linloggauss(fc,2,exp(C2),C2,'hard','corner',corner);

gc=cell(1,M);

% Shorten the vectors
for ii=1:M  
  gc{ii}=middlepad(g{ii},sum(abs(g{ii})>0.0001));
end;

disp('Frame bounds of filterbank.');
filterbankrealbounds(gc,a)

c=filterbank(f,gc,a);

[f,flag,relres,iter,resvec]=ifilterbankiter(c,gc,a,'maxit',500);

figure(1);
loglog(resvec);
title('Convergence of the iterative reconstruction.');