function L = cholesky(A, n)
L = zeros(n, n);
for j = 1: n
    for k = 1: j - 1
        A(j, j) = A(j, j) - A(j, k) ^ 2;
    end
    A(j, j) = sqrt(A(j, j));
    for i = j + 1: n
        for k = 1: j - 1
            A(i, j) = A(i, j) - A(i, k) * A(j, k);
        end
        A(i, j) = A(i, j) / A(j, j);
    end
end
for i = 1: n
    for j = 1: i
        L(i, j) = A(i, j);
    end
end
