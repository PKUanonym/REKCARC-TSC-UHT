% origin conv
function ans = fft_origin(x, y)
	% init
	N = length(x);
	M = length(y);
	L = M + N - 1;
	ans = zeros(1, L);
	% calc
	for n = 1 : L
		m0 = max(1, n + 1 - N);
		m1 = min(M, n);
		for m = m0 : m1
			ans(n) = ans(n) + x(n - m + 1) * y(m); % conv eqn
		end
	end
end