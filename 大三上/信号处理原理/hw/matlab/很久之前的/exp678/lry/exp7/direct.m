function [ y ] = direct( x,h )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    N=length(x);
    M=length(h);
    L=M+N-1;
    for n=1:1:L
        y(n)=0;
        for m=1:1:M
            k=n-m+1;
            if k>=1 && k<=N
                y(n)=y(n)+h(m)*x(k);
            end
        end
    end
end

