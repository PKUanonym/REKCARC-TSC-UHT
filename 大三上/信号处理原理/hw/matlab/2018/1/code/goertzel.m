% Solving dtmf by Goertzel Algorithm
function ans = goertzel(audio, fs)
	% init
	dtmf.keys = ['1', '2', '3', 'A';
				 '4', '5', '6', 'B';
				 '7', '8', '9', 'C';
				 '*', '0', '#', 'D'];
	dtmf.freq = [697, 770, 852, 941, 1209, 1336, 1477, 1633];
	% [audio, fs] = audioread(fileName);

	N = length(audio);
	tmp = zeros(1, N);
	P = zeros(1, length(dtmf.freq));
	dtmf.freq = dtmf.freq * N / fs; % 8 freq correspond to current array

	for m = 1 : length(dtmf.freq)
		filter = 2 * cos(2 * pi * dtmf.freq(m) / N);
		for i = 3 : N - 3
			tmp(i) = filter .* tmp(i-1) - tmp(i-2) + audio(i); % Goertzel
		end
		P(m) = tmp(N-3).^2 + tmp(N-4).^2 - filter * tmp(N-3) * tmp(N-4); % calc power
	end
	P = abs(P);
	col = find(P(5:8) == max(P(5:8))); % find col
	row = find(P(1:4) == max(P(1:4))); % find row
	ans = dtmf.keys(row, col);
end
