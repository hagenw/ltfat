x=0.0:0.02:2*pi; y =cos(x);
clear p_saved hn_saved E_saved
for a=0:0.05:4
    fy=Disfrft(y,a);
    fys=cdpei(y,a);
    fyss=frft(y,a);
    % blue,green,red,cyan
    figure(1)
    subplot(311);plot(x,real([fy,fys,fyss]));
    title(['a = ',num2str(a)]);
    subplot(312);plot(x,imag([fy,fys,fyss]));
    subplot(313);plot(x,abs([fy,fys,fyss]));
    pause(0.7);
end
