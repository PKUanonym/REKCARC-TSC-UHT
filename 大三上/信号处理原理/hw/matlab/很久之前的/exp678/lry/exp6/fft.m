function [  ] = fft(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    [y]=wavread('1.wav');
    f=fft(y,2048);
    a=abs(f);
    p=a.*a/10000;
    num1=find(p(1:250)==max(p(1:250)));
    num2=300+find(p(300:380)==max(p(300:380)));
    display(num1);display(num2);
end

