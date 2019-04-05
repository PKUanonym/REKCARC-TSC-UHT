function y = Funcx(x)

    y = (cos(10 * pi * x) + 2 * sin(30 * pi * x)) .* (0<=x & x<=5) + cos(40 * pi * x) .* (5<x & x<=10) + (cos(60 * pi *x) + 0.6 * sin(90 * pi * x)) .* (10<x & x<=15) + sin(100 * pi * x) .* (15<x & x<=20);

end
