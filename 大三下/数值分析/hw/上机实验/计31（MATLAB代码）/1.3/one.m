b=single(0);
b0=single(0);
a=single(0);
a0=single(0);
n=10000000;
%实际值
for i=1:n
    b0=b;
    b=b+1/i;
    if b-b0==0
        disp(i);
        break;
    end
end
%理论值
for i=1:n
    a0=a;
    a=a+1/i;
    if (1/i)/a<=0.5*5.96*1e-8
        disp(i);
        break;
    end
end