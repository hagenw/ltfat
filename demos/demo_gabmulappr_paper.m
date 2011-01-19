%DEMO_GABMULAPPR Approximate a slowly time variant system by a Gabor multiplier
%   
%   This script construct a slowly time variant system and performs the 
%   best approximation by a Gabor multiplier with specified parameters
%   (a and L see below). Then it shows the action of the slowly time 
%   variant system (A) as well as of the best approximation of (A) by a 
%   Gabor multiplier (B) on a sinusoids and an exponential sweep.
%
% FIGURE 1 
%
%  shows the spectogram of the ouput of the two systems applied on a 
%  sinusoid (left) and an exponential sweep.   

%   AUTHOR : Peter Balazs.
%   based on demo_gabmulappr.m 

disp('Type "help demo_gabmulappr" to see a description of how this demo works.');

% Setup parameters for the Gabor system and length of the signal
L=576; % Length of the signal
a=32;   % Time shift 
M=72;  % Number of modulations
fs=44100; % assumed sampling rate
SNRtv=63; % signal to noise ratio of change rate of time-variant system

% construction of slowly time variant system
% take an initial vector and multiply by random vector close to one
A = [];
c1=(1:L/2); c2=(L/2:-1:1); c=[c1 c2].^(-1); % weight of decay x^(-1)
A(1,:)=(rand(1,L)-0.5).*c;  % convolution kernel
Nlvl = exp(-SNRtv/10);
Slvl = 1-Nlvl;
for ii=2:L;
     A(ii,:)=(Slvl*circshift(A(ii-1,:),[0 1]))+(Nlvl*(rand(1,L)-0.5)); 
end;
A = A/norm(A)*0.99; % normalize matrix

% perform best approximation by gabor multiplier
sym=gabmulappr(A,a,M);

% creation of 3 different input signals (sinusoids)
x=[2*pi/L:2*pi/L:2*pi];
f1 = 1000; % frequency in Hz
s1=0.99*sin((fs/f1).*x);
gtuks = fftshift(firwin('hann',L,'taper',0.8));
s1=s1.*(gtuks.');

L1=ceil(L*0.9);
e1=0.99*expchirp(L1,500,fs/2*0.9,'fs',fs);
gtuke = fftshift(firwin('hann',L1,'taper',0.8));
e1=e1.*gtuke; 
e1=[e1;zeros(L-L1,1)];

% application of the slowly time variant system
As1=A*s1';  
Ae1=A*e1;

% application of the Gabor multiplier
Gs1=gabmul(s1,sym,a); 
Ge1=gabmul(e1,sym,a);

% Plotting the results
%% ------------- figure 1 ------------------------------------------

figure(1);
subplot(2,2,1); sgram(real(As1),'tfr',10,'clim',[-40,13]); 
title (sprintf('Spectogram of output signal: \n Time-variant system applied on sinusoid'),'Fontsize',14);
set(get(gca,'XLabel'),'Fontsize',14);
set(get(gca,'YLabel'),'Fontsize',14);
colorbar('off');

subplot(2,2,2); sgram(real(Ae1),'tfr',10,'clim',[-40,13]); 
title (sprintf('Spectogram of output signal: \n Time-variant system applied on exponential sweep'),'Fontsize',14);
set(get(gca,'XLabel'),'Fontsize',14);
set(get(gca,'YLabel'),'Fontsize',14);
colorbar('off');

subplot(2,2,3); sgram(real(Gs1),'tfr',10,'clim',[-40,13]);
title (sprintf('Spectogram of output signal: \n Best approximation by Gabor multipliers applied on sinusoid'),'Fontsize',14);
set(get(gca,'XLabel'),'Fontsize',14);
set(get(gca,'YLabel'),'Fontsize',14);
colorbar('off');

subplot(2,2,4); sgram(real(Ge1),'tfr',10,'clim',[-40,13]);
title (sprintf('Spectogram of output signal: \n Best approximation by Gabor multipliers applied on exponential sweep'),'Fontsize',14);
set(get(gca,'XLabel'),'Fontsize',14);
set(get(gca,'YLabel'),'Fontsize',14);
colorbar('off');

