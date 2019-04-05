function [ num ] = goertzel(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    num=0;
    tm=[1,2,3,65;4,5,6,66;7,8,9,67;42,0,35,68];
    [y]=wavread('3.wav');
    N=205;
    x=y(1:N);
    v(1)=0;v(2)=0;
    k=[18,20,22,24,31,34,38,42];
    for m=1:8
        d=2*cos(2*pi*k(m)/N);
        for i=3:202
            v(i)=d.*v(i-1)-v(i-2)+x(i);
        end
        X(m)=v(202).^2+v(201).^2-d*v(202)*v(201);
    end
    val=abs(X);stem(k,val,'.');
    limit=80;
    for s=5:8
        if val(s)>limit,break,end
    end
    for r=1:4
        if val(r)>limit,break,end
    end
    num=num+tm(r,s-4)*10^(8-m);
end

