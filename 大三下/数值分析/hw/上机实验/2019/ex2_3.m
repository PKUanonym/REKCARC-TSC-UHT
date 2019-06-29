x = (0: 0.1: 40);
y = besselj(0, x);
plot(x, y);
hold on;

cnt = 0;
a = 0; b = 1;
while cnt < 10
    x = zerotx(@ (x) besselj(0, x), [a, b]);
    if x > 0
        cnt = cnt + 1;
        plot(x, 0, 'o');
    end
    a = a + 1;
    b = b + 1;
end
