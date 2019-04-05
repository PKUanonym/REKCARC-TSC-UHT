x = -5:0.1:5;
y1 = f1(x);
y2 = f1(x-2);
y3 = f1(2*x);
y4 = f1(x/2);
y5 = f1(-x);
plot(x,y1,x,y2,x,y3,x,y4,x,y5);