% conv by overlap-save
% cf. https://zh.wikipedia.org/wiki/%E9%87%8D%E7%96%8A-%E5%84%B2%E5%AD%98%E4%B9%8B%E6%91%BA%E7%A9%8D%E6%B3%95
function ans = overlap_save(x, y)
	% assume y is much shorter than x
	N = length(x);
	M = length(y);
	bs = M + 1; % block size
	L = bs + M - 1;
	cache_y = fft(y, L); % pre calc fft for y
	num = ceil(N / bs); % split x into $num blocks
	ans = zeros(1, (num + 1) * bs);
	x = [x, zeros(1, (num + 1) * bs - N)]; % zero padding to (num + 1) * bs
	ol = zeros(1, M - 1); % overlap-save
	for i = 1:bs:num * bs + 1
		subx = [ol, x(i:i + bs - 1)];
		ol = subx(bs + 1 : bs + M - 1); % refresh overlap-save
		suby = ifft(fft(subx, L) .* cache_y); % calc circle conv
		ans(i:i + bs - 1) = suby(M:M + bs - 1); % save ans
	end
	ans = ans(1:N + M - 1);
end