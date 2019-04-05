>> h1=200; h2=51000; R=6378;
>> a= (h1+h2)/2+R;
>> c=(h2-h1)/2;
>> b=sqrt(a^2-c^2);
>> f =@(x) sqrt(a^2*cos(x).^2+b^2*sin(x).^2);
>> [L1, fcnt]=quad(f, 0, pi/2)

L1 =

   4.0978e+04


fcnt =

   149

>> L=4*L1

L =

   1.6391e+05

>> T=16*3600;
>> v=L/T

v =

    2.8457

>> vmax=2*pi*a*b/T/(h1+R)

vmax =

   10.3023

>> syms x;
>> y= sqrt(a^2*cos(x)^2+b^2*sin(x)^2);
>> I= int(y, x)
Warning: Explicit integral could not be found. 
 
I =
 
int((1022592484*cos(x)^2 + (6332266309484545*sin(x)^2)/16777216)^(1/2), x)
 
>> 
>> h= 1/((x-0.3)^2+0.01)+1/((x-0.9)^2+0.04)-6;
>> I= int(h, 0, 1)
 
I =
 
11*pi + atan(3588784/993187) - 6
 
>> 
>> 
>> 
>> Q=double(I)

Q =

   29.8583

>> 