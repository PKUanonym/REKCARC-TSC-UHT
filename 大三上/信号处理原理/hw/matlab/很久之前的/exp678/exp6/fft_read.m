%FFT算法
function res = fft_read(filename)
[audio, fs] = audioread(filename);
tic
y = abs(fft(audio,fs));       %fft
p = y;               
dtmf = [697, 770, 852, 941, 1209, 1336, 1477, 1633]; %dtmf按键8个频率	
row = find(p(650:1000) == max(p(650:1000))) + 649;  %第一个峰值      
col = 1149 + find(p(1150:1500) == max(p(1150:1500)));  %第二个峰值
rf = abs(dtmf - row);           %跟标准频率做差
cf = abs(dtmf - col);
row = find(rf == min(rf));      %求出最接近的一行
col = find(cf == min(cf)) - 4;  %求出最接近的一列

keys = ...
    ['1','2','3','A';
    '4','5','6','B';
    '7','8','9','C';
    '*','0','#','D'];
res = keys(row,col);
toc
end
