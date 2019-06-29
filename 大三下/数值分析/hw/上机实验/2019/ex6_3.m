t = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8]';
y = [33.4, 79.5, 122.65, 159.05, 189.15, 214.15, 238.65, 252.2, 267.55, 280.50, 296.65, 301.65, 310.40, 318.15, 325.15]';
yln = log(y);
A = zeros(15, 3);
for i = 1: 15
    A(i, 1) = 1;
    A(i, 2) = t(i);
    A(i, 3) = t(i) * t(i);
end
G = A' * A;
b = A' * y;
L = cholesky(G, 3);
x = L' \ (L \ b);
disp(x);
approx = x(3) .* (t .^ 2) + x(2) .* t + x(1);
plot(t, y);
hold on;
plot(t, approx);
disp(sqrt(sum((approx - y) .^ 2) / 15.0));

A = zeros(15, 2);
for i = 1: 15
    A(i, 1) = 1;
    A(i, 2) = t(i);
end
G = A' * A;
b = A' * yln;
L = cholesky(G, 2);
x = L' \ (L \ b);
disp(exp(x(1)));
disp(x(2));
approx = exp(x(1)) .* exp(x(2) .* t);
plot(t, approx);
disp(sqrt(sum((approx - y) .^ 2) / 15.0));

legend('data', 'quadratic', 'exponential');
