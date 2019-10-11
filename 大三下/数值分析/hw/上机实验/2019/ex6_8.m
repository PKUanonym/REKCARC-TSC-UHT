pos = [2, 30, 130, 350, 515];
x = [0.520, 3.1, 8.0, 17.95, 28.65, 39.62, 50.65, 78, 104.6, 156.6, 208.6, 260.7, 312.50, 364.4, 416.3, 468, 494, 507, 520]';
y = [5.288, 9.4, 13.84, 20.20, 24.90, 28.44, 31.10, 35, 36.9, 36.6, 34.6, 31.0, 26.34, 20.9, 14.8, 7.8, 3.7, 1.5, 0.2]';
dy0 = 1.86548;
dyn = -0.046115;
n = 18;
h = zeros(n, 1);
for i = 1: n
    h(i) = x(i + 1) - x(i);
end
lambda = zeros(n, 1);
lambda(1) = 1;
miu = zeros(n, 1);
miu(n) = 1;
for i = 2: n
    lambda(i) = h(i) / (h(i - 1) + h(i));
    miu(i - 1) = 1 - lambda(i);
end
d = zeros(n + 1, 1);
d(1) = (6 / h(1)) * ((y(2) - y(1)) / h(1) - dy0);
d(n + 1) = (6 / h(n)) * (dyn - (y(n + 1) - y(n)) / h(n));
for i = 2: n
    d(i) = 6 * (y(i - 1) / (h(i - 1) * (h(i - 1) + h(i))) + y(i + 1) / (h(i) * (h(i - 1) + h(i))) - y(i) / (h(i - 1) * h(i)));
end
M = zeros(n + 1, 1);
m = zeros(n + 1, 1);
b = 2 .* ones(n + 1, 1);
for i = 2: n + 1
    m(i) = miu(i - 1) / b(i - 1);
    b(i) = b(i) - m(i) * lambda(i - 1);
    d(i) = d(i) - m(i) * d(i - 1);
end
M(n + 1) = d(n + 1) / b(n + 1);
for i = n : -1 : 1
    M(i) = (d(i) - lambda(i) * M(i + 1)) / b(i);
end
for i = 1: 5
    disp(pos(i));
    k = 1;
    while ~((x(k) <= pos(i)) && (x(k + 1) >= pos(i)))
        k = k + 1;
    end
    val = M(k) * (x(k + 1) - pos(i)) ^ 3 / (6 * h(k)) + M(k + 1) * (pos(i) - x(k)) ^ 3 / (6 * h(k)) + (y(k) - M(k) * h(k) ^ 2 / 6) * ((x(k + 1) - pos(i)) / h(k)) + (y(k + 1) - M(k + 1) * h(k) ^ 2 / 6) * ((pos(i) - x(k)) / h(k));
    disp(val);
    der = -M(k) * (x(k + 1) - pos(i)) ^ 2 / (2 * h(k)) + M(k + 1) * (pos(i) - x(k)) ^ 2 / (2 * h(k)) + (y(k + 1) - y(k)) / h(k) - h(k) * (M(k + 1) - M(k)) / 6;
    disp(der);
    der2 = M(k) * ((x(k + 1) - pos(i)) / h(k)) + M(k + 1) * ((pos(i) - x(k)) / h(k));
    disp(der2);
end