x0=0.6;
k=0;
delta=1e-4;%误差阈值
lamda=1;%初始值λ0
x1=x0-lamda*f1(x0)/ff1(x0);
while abs(f1(x0))>delta||abs(x1-x0)>delta
    s=f1(x0)/ff1(x0);
    x1=x0-s;
    i=0;
    lamda=1;
    while abs(f1(x1))>=abs(f1(x0))
        x1=x0-lamda*s;
        lamda=lamda/2;
        i=i+1;
    end
    x0=x1;
    k=k+1;
    disp(lamda);%每一步的最终λ值
    disp(x1);%近似解
end
disp(x1);
return