x = [0:0.01:20];
figure(1);
spectrogram(Funcx(x));
figure(2);
plot(abs(fft(Funcx(x))));
