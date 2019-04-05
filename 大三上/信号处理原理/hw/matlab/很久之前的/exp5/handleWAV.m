fileName = {'1-1-2.wav', '1-1-3(2).wav', '1-1-3(3).wav', '1-1-3(4).wav', '1-1-3(5).wav',...
            '1-1-3(6).wav', '1-1-3.wav', '1-2-2(2).wav', '1-2-2(3).wav', '1-2-2.wav',...
            '3-1-3(2).wav', '3-1-3(3).wav', '3-1-3(4).wav', '3-1-3(5).wav', '3-1-3(6).wav',...
            '3-1-3(7).wav', '3-1-3.wav', '3-1-4(2).wav', '3-1-4(3).wav', '3-1-3(4).wav'};
A = zeros(1,length(fileName));
E = cell(1,length(fileName));
tag = zeros(1,length(fileName));
for index = 1:length(fileName)
    tag(index) = fileName{index}(1) - '0';
    audio = audioread(fileName{index});
    len = length(audio);
    A(index) = sum(abs(audio))/len;      %信号幅度
    E{index} = zeros(1,ceil(len/3200));
    for i = 1:ceil(len/3200)
        upbound = min(i*3200, len);
        y = abs(fft(audio((i-1)*3200+1:upbound)));
        E{index}(i) = sum(y.*y) / length(y);          %信号能量
    end
    figure(index);
    plot(E{index});
end
display(A);
display(E);
display(tag);
x = 1:20;