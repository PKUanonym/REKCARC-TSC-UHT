% conv by FFT
function ans = conv_circle(x, y)
	N = length(x);
	M = length(y);
	x = [x, zeros(1, M-1)]; % zero padding to (N + M - 1)
	y = [y, zeros(1, N-1)];
	ans = ifft(fft(x) .* fft(y));
end