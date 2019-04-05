%直接使用公式
function res = conv_origin(a, b)
N=length(a);
M=length(b);
L=M+N-1;
res = zeros(1,L);   %初始化
for n=1:L
    for m=1:M
        k = n-m+1;
        if k >= 1 && k <= N
            res(n) = res(n) + b(m)*a(k);    %卷积公式求和
        end
    end
end
end

