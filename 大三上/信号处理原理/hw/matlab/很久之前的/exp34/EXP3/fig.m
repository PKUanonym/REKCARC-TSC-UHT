x = -1:0.01:1;
[y1, yo, m1] = rect(1, 1, 10, x);
[y2, yo, m2] = rect(1, 1, 100, x);
[y3, yo, m3] = rect(1, 1, 1000, x);
[y4, yo, m4] = rect(1, 1, 10000, x);
figure(1);
plot(x, y1, '-y', x, y2, '--m', x, y3, ':c', x, y4, '-.r', x, yo, 'k');

m = zeros([1,1000]);
for k = 1:1000
    [y, yo, m(k)] = rect(1, 1, k, x);
end
x2 = 1:1000;
figure(2);
plot(x2, m);