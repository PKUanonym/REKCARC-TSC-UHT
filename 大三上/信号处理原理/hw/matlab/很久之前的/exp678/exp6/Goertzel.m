%Goertzel算法
function res = Goertzel(fileName)
res = 0;
keys = ...
['1','2','3','A';
'4','5','6','B';
'7','8','9','C';
'*','0','#','D'];			%键盘排布
[y, fs] = audioread(fileName); 	
N = length(y);
x = y(1:N);					%截取适当时间?
tic 						%开始计时
temp = zeros(1,N);
dtmf = [697, 770, 852, 941, 1209, 1336, 1477, 1633]; %dtmf按键8个频率	
k = N / fs * dtmf;								%8个频率对应的序列中的点
P = zeros(1,8);
for m = 1:8
	fil = 2 * cos(2*pi*k(m)/N);									%滤波
	for i = 3:N-3
		temp(i) = fil .* temp(i-1) - temp(i-2) + x(i);			%Goertzel算法递推
	end
	P(m)=temp(N-3).^2 + temp(N-4).^2 - fil*temp(N-3)*temp(N-4);		%计算功率
end
P = abs(P);
col = find(P(5:8) == max(P(5:8)));  %找到列
row = find(P(1:4) == max(P(1:4)));  %找到行
res = keys(row, col);			%找到对应按键
toc         
end
