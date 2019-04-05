% conv by overlap-save
% cf. https://zh.wikipedia.org/wiki/%E9%87%8D%E7%96%8A-%E7%9B%B8%E5%8A%A0%E4%B9%8B%E6%91%BA%E7%A9%8D%E6%B3%95
function ans = overlap_add(x, y)
	% assume y is much shorter than x
	N = length(x);
	M = length(y);
	bs = M + 1; % block size
	L = bs + M - 1;
	cache_y = fft(y, L); % pre calc fft for y
	num = ceil(N / bs); % split x into $num blocks
	ans = zeros(1, (num + 1) * bs);
	x = [x, zeros(1, (num + 1) * bs - N)]; % zero padding to (num + 1) * bs
	ol = zeros(1, M - 1); % overlap-add
	for i = 1:bs:num * bs + 1
		suby = ifft(fft(x(i:i + bs - 1), L) .* cache_y); % calc circle conv
		suby(1:M - 1) = suby(1:M - 1) + ol(1:M - 1); % overlap-add
		ol(1:M - 1) = suby(bs + 1:L); % refresh
		ans(i:i + bs - 1) = suby(1:bs); % save ans
	end
	ans = ans(1:N + M - 1);
end