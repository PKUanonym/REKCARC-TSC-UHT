i=1;
A=hilb(10);%hilbert¾ØÕó
b=[1,1/2,1/3,1/4,1/5,1/6,1/7,1/8,1/9,1/10]';
d=diag(diag(A));
l=d-tril(A);%LU·Ö½â
u=d-triu(A);
%d0=inv(d);%D^-1
B=d\(l+u);
f=d\b;
x0=zeros(10,1);
x=B*x0+f;
while norm(x-x0,inf)>=1e-4
    x0=x;
    x=B*x0+f;
    i=i+1;
    disp(x);
    disp(i);
end
