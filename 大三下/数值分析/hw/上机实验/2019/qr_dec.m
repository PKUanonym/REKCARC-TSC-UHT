function [Q, R] = qr_dec(A, n)
Q = zeros(n, n);
R = zeros(n, n);
for j = 1: n
	b = A(:, j);
	for k = 1: j - 1
		t = Q(:, k)' * b;
		R(k, j) = t;
		b = b - t * Q(:, k);
	end
	R(j, j) = norm(b, 2);
	Q(:, j) = b / R(j, j);
end
