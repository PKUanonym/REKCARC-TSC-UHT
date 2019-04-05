%yo为矩形脉冲信号
%y为其傅里叶级数, mse为均方误差
% h为脉高，w为脉宽，n为项数
function [y, yo, mse] = rect(h, w, n, x)
T = 2 * w; %周期
yo = h * rectpuls(x, w);
y = h * w / T;
for k = 1:n
    y = y + ((2 * h * w * sin(k * pi * w / T) / (k * pi)) * cos(k * 2 * pi * x / T));
end
mse = norm(y - yo);