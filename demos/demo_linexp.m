C=log(2);
corner=1;

x=linspace(-2.5,2.5,100);

figure(1);
plot(x,linexp(x,C,'soft'),'r',...
     x,linexp(x,C,corner,'hard'),'b');
legend('soft','hard');
title('C=log(2) corner=1');

print -depsc linexp.eps