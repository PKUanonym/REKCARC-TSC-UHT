A = [0.5, 0.5, 0.5, 0.5; 0.5, 0.5, -0.5, -0.5; 0.5, -0.5, 0.5, -0.5; 0.5, -0.5, -0.5, 0.5];
n = 4;
done = 0;
while done == 0
    s = A(n, n);
    [Q, R] = qr_dec(A - s * eye(n), n);
    A = R * Q + s * eye(n);
    disp(A);
    done = 1;
    for i = 1: n
        for j = 1: n
            if i ~= j && abs(A(i, j)) > 1e-6
                done = 0;
            end
        end
    end
end
disp(diag(A));
