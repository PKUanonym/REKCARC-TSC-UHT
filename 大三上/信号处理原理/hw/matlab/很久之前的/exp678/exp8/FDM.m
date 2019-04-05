duration=2;                                  %样本时间
[sd1,fs]=audioread('3-1-4(1).wav');            %打开保存的录音文件
[sd2,fs]=audioread('3-1-4(2).wav');
[sd3,fs]=audioread('3-1-4(3).wav');
t=0:duration*fs-1;                           %总的采样数
sd1 = sd1(1:duration*fs,:);                  %取相同时间
sd2 = sd2(1:duration*fs,:);
sd3 = sd3(1:duration*fs,:);
figure(1)                                    %三个声音样本的频谱分析
subplot(311)
stem(t,abs(fft(sd1)),'.');                   %fft对声音信号进行快速傅里叶变换       
subplot(312)
stem(t,abs(fft(sd2)),'.');
subplot(313)
stem(t,abs(fft(sd3)),'.');
%将三个声音信号用高频载波进行调制
x1=4*sd1'.*cos(2*pi*4000*t/fs);
x2=4*sd2'.*cos(2*pi*11000*t/fs);
x3=4*sd3'.*cos(2*pi*18000*t/fs); 
s=x1+x2+x3;
figure(2)
stem(t,abs(fft(s)),'.');
ys = s;
%带通滤波
Rp=0.5;
Rs=40;
Wp1=[4000 8000]/22050;
Ws1=[3800 8500]/22050;
[n1,Wn1]=cheb2ord(Wp1,Ws1,Rp,Rs);
[b1,a1]=cheby2(n1,Rs,Wn1);
Wp2=[9000 13000]/22050;
Ws2=[8000 14000]/22050;
[n2,Wn2]=cheb2ord(Wp2,Ws2,Rp,Rs);
[b2,a2]=cheby2(n2,Rs,Wn2);
Wp3=[14500 18500]/22050;
Ws3=[14000 19000]/22050;
[n3,Wn3]=cheb2ord(Wp3,Ws3,Rp,Rs);
[b3,a3]=cheby2(n3,Rs,Wn3);
y1=filter(b1,a1,ys);
y2=filter(b2,a2,ys);
y3=filter(b3,a3,ys);
%开始解调
y01=y1.*cos(2*pi*4000*t/fs);
y02=y2.*cos(2*pi*11000*t/fs);
y03=y3.*cos(2*pi*18000*t/fs);
%低通滤波
Rp=0.5;
Rs=40;
Wp1=3400/22050;
Ws1=4000/22050;
[n1,Wn1]=cheb2ord(Wp1,Ws1,Rp,Rs);
[b1,a1]=cheby2(n1,Rs,Wn1);
%恢复信号的频谱分析
yy1=filter(b1,a1,y01);
yy2=filter(b1,a1,y02);
yy3=filter(b1,a1,y03);
figure(3)                                    
subplot(311)
stem(t,abs(fft(yy1)));
subplot(312)
stem(t,abs(fft(yy2)));
subplot(313)
stem(t,abs(fft(yy3)));
sound(yy1,fs);
pause(2);
sound(yy2,fs);
pause(2);
sound(yy3,fs);
pause(2);