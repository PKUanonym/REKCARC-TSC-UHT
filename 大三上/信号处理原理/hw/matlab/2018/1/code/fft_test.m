% Solving dtmf by FFT Algorithm
function ans = fft_test(audio, fs)
	% init
	dtmf.keys = ['1', '2', '3', 'A';
				 '4', '5', '6', 'B';
				 '7', '8', '9', 'C';
				 '*', '0', '#', 'D'];
	dtmf.row = [697, 770, 852, 941];
	dtmf.col = [1209, 1336, 1477, 1633];
	% [audio, fs] = audioread(filename);

	p = abs(fft(audio, fs));
	p = reshape(p, fs, 1);
	row = find(p(650:1000) == max(p(650:1000))) + 649; % 1st peak
	col = find(p(1150:1500) == max(p(1150:1500))) + 1149; % 2nd peak
	% fprintf("find %f %f\n", p(row), p(col));
	ans = '';
	if (p(row) > 10 || p(col) > 10)
		rf = abs(dtmf.row - row);
		cf = abs(dtmf.col - col);
		row = find(rf == min(rf)); % closest row
		col = find(cf == min(cf)); % closest col
		ans = dtmf.keys(row, col);
	end;
end