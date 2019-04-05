t = 0:0.005:20;
%FFT
figure(1);
plot(t, abs(fft(f(t))));    
%STFT
figure(2);
spectrogram(f(t), gausswin(round(length(t)/4),10));
figure(3);
spectrogram(f(t), gausswin(round(length(t)/4),2));
figure(4);
spectrogram(f(t), gausswin(round(length(t)/2),2));