%使用FFT计算线卷积
function res = conv_circle(a, b)
m = length(a);
n = length(b);
a=[a,zeros(1,n-1)];     %将序列长度补为n+m-1
b=[b,zeros(1,m-1)];
aa=fft(a);              %计算FFT
bb=fft(b);
y = aa .* bb;
res=ifft(y);           %计算IFFT
end

