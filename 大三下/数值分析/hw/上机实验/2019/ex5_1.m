A = [5, -4, 1; -4, 6, -4; 1, -4, 7];
v = rand(3, 1);
lambda = norm(v, inf);
w = A * v;
lambda0 = norm(w, inf);
while abs(lambda - lambda0) >= 1e-5
    v = w;
    lambda = lambda0;
    w = A * v;
    lambda0 = norm(w, inf);
    w = w / lambda0;
end
disp(lambda0);
disp(w);

A = [25, -41, 10, -6; -41, 68, -17, 10; 10, -17, 5, -3; -6, 10, -3, 2];
v = rand(4, 1);
lambda = norm(v, inf);
w = A * v;
lambda0 = norm(w, inf);
while abs(lambda - lambda0) >= 1e-5
    v = w;
    lambda = lambda0;
    w = A * v;
    lambda0 = norm(w, inf);
    w = w / lambda0;
end
disp(lambda0);
disp(w);
