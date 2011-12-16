[f,fs]=greasy;
Q=3;
a=4;
M=40;
fcorner=0.1;

[coef,fc,g] = cqt(f,'gauss',Q,a,M,fcorner);

plotfilterbank(coef,a,fc*fs/2,fs,80,'audtick');