b=[25,-41,10,-6;-41,68,-17,10;10,-17,5,3;-6,10,-3,2];
v=[0,0,0,1]';
u=v;
lamda0=1;
lamda1=0;
while abs(lamda1-lamda0)>=1e-5
    v=b*u;
    lamda0=lamda1;
    lamda1=norm(v,inf);
    u=v/lamda1;
end
disp(lamda0);
disp(u);