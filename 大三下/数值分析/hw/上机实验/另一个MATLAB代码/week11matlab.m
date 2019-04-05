>> x=1:6;
>> y=[16 18 21 17 15 12];
>> xi=1:0.01:6;
>> yi=pchip(x,y, xi);
>> plot(x, y, 'o', xi, yi);