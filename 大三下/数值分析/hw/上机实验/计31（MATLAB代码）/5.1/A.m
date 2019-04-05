a=[5,-4,1;-4,6,-4;1,-4,7];
v=[0,0,1]';
u=v;
v=a*u;
lamda0=1;
lamda1=0;
while abs(lamda1-lamda0)>=1e-5
    v=a*u;
    lamda0=lamda1;
    lamda1=norm(v,inf);
    u=v/lamda1;
end
disp(lamda0);%特征值
disp(u);%特征向量