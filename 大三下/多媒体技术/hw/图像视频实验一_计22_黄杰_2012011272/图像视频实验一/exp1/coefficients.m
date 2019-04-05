function [ B ] = coefficients( coefficients,A ,t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[h w]=size(A);
hh=h*sqrt(coefficients);
ww=w*sqrt(coefficients);
if (t==1)
    for i=1:h
        for j=1:w
            if i>hh || j>ww
                A(i,j)=0;
            end
        end
    end
end
if (t==2)
    hhh=[];
    www=[];
    hh=8*sqrt(coefficients);
    ww=8*sqrt(coefficients);
    for i=1:h/8
        hhh=[hhh 8];
    end
    for i=1:w/8
        www=[www 8];
    end
    c = mat2cell(A, hhh, www);
    for i=1:h/8
        for j=1:w/8
            for ii=1:8
                for jj=1:8
                    if ii > hh || jj > ww
                        c{i, j}(ii, jj) = 0;
                    end
                end
            end
        end
    end
    A = cell2mat(c);
end
B=A;
end