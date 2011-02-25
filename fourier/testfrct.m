% Disfrft

function testfrct(x)
x=[-35:35];
y = zeros(size(x));
y(fix(length(x)/2)+1)=1;
subplot(321),
plot(x,y);
title('symmetric delta')

yf=Disfrft(y,5/6);
subplot(322),
plot(x,real(yf),'b',x,imag(yf),'r');
axis([-32,32,-0.2,0.2]);
title('FrFT for a = 5/6 of symmetric delta')

% Disfrct

x=[0:35];
y1(1:1)=1;
y1(2:36)=zeros(1,35);
subplot(323),
plot(x,y1)
axis([0,35,0,1])
title('half delta')

yc=Disfrct(y1,5/6);
subplot(324),
plot(x,real(yc),'b',x,imag(yc),'r');
axis([0,35,0-.2,0.2]);
title('FrCT for a = 5/6 of half delta')

% Disfrcst

x=[-35:0];
y1(1:36)=zeros(1,36);
y1(1:1)=-1;
subplot(325),
plot(x,y1)
axis([-35,0,-1,0])
title('half delta')

ys=Disfrst(y1,5/6);
subplot(326),
plot(x,real(ys),'b',x,imag(ys),'r');
axis([-35,0,-.2,0.2]);
title('FrST for a = 5/6 of half delta')
