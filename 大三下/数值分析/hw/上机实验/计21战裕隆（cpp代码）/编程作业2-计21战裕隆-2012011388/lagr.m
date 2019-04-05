function yy=lagr(x,y,xx)

% yy=nalagr(x,y,xx)是求拉格朗日插值，其中x是插值节点，y是对应的向量，%xx是插值点，也可以是向量

disp('拉格朗日插值');

x=-5:1:5

y=1./(1+16*x.^2)

plot(x,y,'r');

hold on;

xx=5.*cos((2.*[0:1:20]+1)*pi./42)

m=length(x);

n=length(y);

if m~=n

    error('向量x和向量y的长度必须一致')

end

s=0;

for i=1:n

    t=ones(1,length(xx));

    for j=1:n

        if j~=i

            t=t.*((xx-x(j))/(x(i)-x(j)))

        end

    end

    s=s+t*y(i);

end

yy=s;

yy

plot(xx,yy,'k');
