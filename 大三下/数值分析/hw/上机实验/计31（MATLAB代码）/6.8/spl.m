x=[0.520,3.1,8.0,17.95,28.65,39.62,50.65,78,104.6,156.6,208.6,260.7,312.50,364.4,416.3,468,494,507,520].';
y=[5.288,9.4,13.84,20.20,24.90,28.44,31.10,35,36.9,36.6,34.6,31.0,26.34,20.9,14.8,7.8,3.7,1.5,0.2].';
dy0=1.86548;%两端点导数值
dyn=-0.046115;
test=515;%测试的x值
h=zeros(18,1);
for i=1:18
    h(i)=x(i+1)-x(i);
end
lambda=zeros(18,1);%三对角矩阵中的λ值
lambda(1)=1;
mu=ones(18,1);%三对角矩阵中的μ值
mu(18)=1;
for j=2:18
    lambda(j)=h(j)/(h(j-1)+h(j));
    mu(j-1)=1-lambda(j);
end
d=zeros(19,1);%右端项
d(1)=(6/h(1))*((y(2)-y(1))/h(1)-dy0);
d(19)=(6/h(18))*(dyn-(y(19)-y(18))/h(18));
for j=2:18
    d(j)=6*(y(j-1)/(h(j-1)*(h(j-1)+h(j)))+y(j+1)/(h(j)*(h(j-1)+h(j)))-y(j)/(h(j-1)*h(j)));
end
M=ones(19,1);
b=2*ones(19,1);
m=zeros(19,1);
for i=2:19%追赶法求解三对角矩阵方程
    m(i)=mu(i-1)/b(i-1);
    b(i)=b(i)-m(i)*lambda(i-1);
    d(i)=d(i)-m(i)*d(i-1);
end
M(19)=d(19)/b(19);
i=18;
while i>0
    M(i)=(d(i)-lambda(i)*M(i+1))/b(i);
    i=i-1;
end
k=1;
while x(k)>test||x(k+1)<test%判断测试值位于哪个区间
    k=k+1;
end
answer=M(k)*(x(k+1)-test)^3/(6*h(k))+M(k+1)*(test-x(k))^3/(6*h(k))+(y(k)-M(k)*h(k)^2/6)*((x(k+1)-test)/h(k))+(y(k+1)-M(k+1)*h(k)^2/6)*((test-x(k))/h(k));%函数值
disp(answer);
danswer=-M(k)*(x(k+1)-test)^2/(2*h(k))+M(k+1)*(test-x(k))^2/(2*h(k))+(y(k+1)-y(k))/h(k)-h(k)*(M(k+1)-M(k))/6;%一阶导数值
disp(danswer);
ddanswer=M(k)*((x(k+1)-test)/h(k))+M(k+1)*((test-x(k))/h(k));%二阶导数值
disp(ddanswer);