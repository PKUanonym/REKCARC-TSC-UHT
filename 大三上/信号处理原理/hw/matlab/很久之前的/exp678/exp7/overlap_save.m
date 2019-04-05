%使用overlap-save方法计算
function res = overlap_save(x, h, N)
lx = length(x);
M = length(h);
if N < M          %N应不小于M
    N = M + 1;
end
L = N+M-1;
temp_m = zeros(1,M-1);    %x前插入0
num = ceil(lx/N);     %x被分成num段
x = [x,zeros(1,(num+1)*N-lx)];
res = zeros(1,(num+1)*N);
for i = 0:num
    left = i*N+1;
    temp_x = [temp_m,x(left:left+N-1)]; 
    temp_m = temp_x(N+1:N+M-1);     %更新x前一小段
    temp_y = ifft(fft(temp_x,L) .* fft(h,L)); %计算圆卷积
    res(left:left+N-1) = temp_y(M:N+M-1);  %将有用的段存下
end
res = res(1:lx+M-1);
end

