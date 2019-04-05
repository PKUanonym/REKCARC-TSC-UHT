file = {'dtmf-0.wav','dtmf-1.wav', 'dtmf-2.wav', 'dtmf-3.wav', 'dtmf-4.wav',...
        'dtmf-5.wav', 'dtmf-6.wav', 'dtmf-7.wav', 'dtmf-8.wav', 'dtmf-9.wav'};
for i = 1:10;
    disp(i);
    disp(fft_read(file{i}));
    disp(Goertzel(file{i}));
end