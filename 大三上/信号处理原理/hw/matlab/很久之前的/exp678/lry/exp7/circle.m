function [ y ] = circle( x,h )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    m=length(x);
    n=length(h);
    l=n+m-1;
    x=[x,zeros(1,n-1)];
    h=[h,zeros(1,m-1)];
    xk=fft(x,l);
    hk=fft(h,l);
    yk=xk.*hk;
    y=ifft(yk,l);
    y=y(1:l);
end

