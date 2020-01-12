function main
	points = 400;
	step = 100;
	M = 1000; % length y
	time_origin = zeros(1, points);
	time_circle = zeros(1, points);
	time_save   = zeros(1, points);
	time_add    = zeros(1, points);

	for i = 1 : points
		N = M + (i-1) * step
		fprintf("testing N = %d, M = %d\n", N, M);
		x = rand([1, N]);
		y = rand([1, M]);
		tic;
		ans1 = conv_origin(x, y);
		time_origin(i) = toc;
		tic;
		ans2 = conv_circle(x, y);
		time_circle(i) = toc;
		tic;
		ans3 = overlap_save(x, y);
		time_save(i) = toc;
		tic;
		ans4 = overlap_add(x, y);
		time_add(i) = toc;
	end
	x = M:step:M + step*(points-1);

	plot(x, time_origin, '-', x, time_circle, '-', x, time_save, '-', x, time_add, '-');
	legend({'origin conv', 'circle conv', 'overlap-save', 'overlap-add'}, 'Location', 'northwest');
	xlabel('M');
	ylabel('time_cost/s');
end

function ans = conv_origin(x, y)
	N = length(x);
	M = length(y);
	L = M + N - 1;
	ans = zeros(1, L);

	for n = 1 : L
		m0 = max(1, n + 1 - N);
		m1 = min(M, n);
		for m = m0 : m1
			ans(n) = ans(n) + x(n - m + 1) * y(m);
		end
	end
end

function ans = conv_circle(x, y)
	N = length(x);
	M = length(y);
	x = [x, zeros(1, M-1)]; % zero padding
	y = [y, zeros(1, N-1)]; % zero padding
	ans = ifft(fft(x) .* fft(y));
end

function y = overlap_add(x, h)
    N = length(x);
    M = length(h);
    L = M + 1; % block size
    len = L + M - 1;
    fft_h = fft(h, len);
    num = ceil(N / L); % split x into $num blocks
    y = zeros(1, (num + 1) * L);
    x = [x, zeros(1, (num + 1) * L - N)]; % zero padding to (num + 1) * L
    ol = zeros(1, M - 1); % overlap-add
    for i = 1:L:num * L + 1
        y_k = ifft(fft(x(i:i + L - 1), len) .* fft_h); % calc circle conv
        y_k(1:M - 1) = y_k(1:M - 1) + ol(1:M - 1); % overlap-add
        ol(1:M - 1) = y_k(L + 1:len); % refresh
        y(i:i + L - 1) = y_k(1:L); % save y
    end
    y = y(1:N + M - 1);
end

% conv by overlap-save
function y = overlap_save(x, h)
    % assume h is much shorter than x
    N = length(x);
    M = length(h);
    L = M + 1; % block size
    len = L + M - 1;
    fft_h = fft(h, len);
    num = ceil(N / L); % split x into $num blocks
    y = zeros(1, (num + 1) * L);
    x = [x, zeros(1, (num + 1) * L - N)]; % zero padding
    ol = zeros(1, M - 1); % overlap-save
    for i = 1:L:num * L + 1
        subx = [ol, x(i:i + L - 1)];
        ol = subx(L + 1 : L + M - 1); % refresh overlap-save
        y_k = ifft(fft(subx, len) .* fft_h); % calc circle conv
        y(i:i + L - 1) = y_k(M:M + L - 1); % save y
    end
    y = y(1:N + M - 1);
end

