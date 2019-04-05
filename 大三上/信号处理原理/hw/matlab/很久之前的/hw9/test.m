x = 0:0.01:20;
y = f(x);
%DWT
figure(1);
plot(x,y);
[ca, cd] = dwt(y, 'haar');
figure(2);
plot(ca);
figure(3);
plot(cd);
Idwt = idwt(ca, cd, 'haar');
figure(4);
plot(Idwt);
psnr_dwt = psnr(Idwt, [y,y(length(y))])

%FFT
x2 = 0:0.01:20;
y2 = f(x2); 
psnr_fft = psnr(ifft(fft(f(x2))), y2)

