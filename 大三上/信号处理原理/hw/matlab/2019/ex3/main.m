% 读取数据
[audio1, fs] = audioread('./data/1.wav');
[audio2, fs] = audioread('./data/2.wav');
[audio3, fs] = audioread('./data/3.wav');
fprintf("read freq: %dHz\n", fs);
total_len = 150000; % 取前150000个点
audio1 = audio1(1 : total_len);
audio2 = audio2(1 : total_len);
audio3 = audio3(1 : total_len);

% 原始的时域信号
t = 0 : total_len - 1;
figure(1);
subplot(311);
stem(t, audio1, '.');
subplot(312);
stem(t, audio2, '.');
subplot(313);
stem(t, audio3, '.');

% 原始的频域信号
figure(2);
subplot(311);
stem(t, abs(fft(audio1)), '.');
subplot(312);
stem(t, abs(fft(audio2)), '.');
subplot(313);
stem(t, abs(fft(audio3)), '.');

% 1/3抽取和三倍上采样的下标
sample_idx = 1 : 3 : total_len - 1;

% 在时域进行1/3抽取
audio1 = audio1(sample_idx);
audio2 = audio2(sample_idx);
audio3 = audio3(sample_idx);

% 时域上进行上采样
a1 = zeros(1, total_len);
a2 = zeros(1, total_len);
a3 = zeros(1, total_len);
a1(sample_idx) = audio1;
a2(sample_idx) = audio2;
a3(sample_idx) = audio3;

% 变换到频域
f1 = fft(a1);
f2 = fft(a2);
f3 = fft(a3);

% f是频域编码信号
len = total_len / 6;
f = zeros(1, total_len);
f(1:len*3) 		 = [f1(1:len), 		 f2(1:len),		  f3(1:len)];
f(len*3+1:len*6) = [f3(len+1:len*2), f2(len+1:len*2), f1(len+1:len*2)];

% y是编码完成后的时域信号
y = ifft(f);
t = 0:total_len-1;
figure(3);
subplot(211);
stem(t, abs(f), '.');
subplot(212);
stem(t, real(y), '.');

% 频域解码
f = fft(y);
f1 = [f(1:len), 		f(len*5+1:len*6)];
f2 = [f(len+1:len*2),	f(len*4+1:len*5)];
f3 = [f(len*2+1:len*3), f(len*3+1:len*4)];
t = 0:2*len-1;
figure(4);
subplot(311);
stem(t, abs(f1), '.');
subplot(312);
stem(t, abs(f2), '.');
subplot(313);
stem(t, abs(f3), '.');

% 恢复时域信号
audio1 = real(ifft(f1));
audio2 = real(ifft(f2));
audio3 = real(ifft(f3));
a1 = zeros(1, total_len);
a2 = zeros(1, total_len);
a3 = zeros(1, total_len);
a1(sample_idx) = audio1;
a2(sample_idx) = audio2;
a3(sample_idx) = audio3;
figure(5);
subplot(311);
stem(1:total_len, a1, '.');
subplot(312);
stem(1:total_len, a2, '.');
subplot(313);
stem(1:total_len, a3, '.');
