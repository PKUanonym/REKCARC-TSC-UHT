x = -2:0.01:2;
y1 = f2(x);
y2 = f2(x-2);
y3 = f2(2*x);
y4 = f2(x/2);
y5 = f2(-x);
plot(x,y1,x,y2,x,y3,x,y4,x,y5);