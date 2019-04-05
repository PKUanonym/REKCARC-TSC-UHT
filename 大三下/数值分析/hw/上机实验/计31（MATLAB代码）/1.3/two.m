b=0;
b0=0;
n=2097152;
for i=1:n
    b0=b;
    b=b+1/i;
    if b-b0==0
        disp(i)
        break;
    end
end