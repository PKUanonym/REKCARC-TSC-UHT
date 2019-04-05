x = [0:0.001:20];
y = Funcx(x);
%DWT
figure(1);
plot(y);
figure(2);
[cA, cD] = dwt(y, 'haar');
plot(cA);
figure(3);
plot(cD);
figure(4);
Idwt = idwt(cA, cD, 'haar');
plot(Idwt);

display(psnr(Idwt, [y,y(20001)]));

%FFT
a = 1;
t = [-2.5:0.002:2.5];
Fft = fft(Funcx(x));
iFft = ifft(Fft);
display(psnr(iFft, y));

