% Generate dtmf wave 
function y = gen_dtmf(keys, per_time, is_disp)
	fs = 44100;
	dtmf.keys = ['1', '2', '3', 'A';
				 '4', '5', '6', 'B';
				 '7', '8', '9', 'C';
				 '*', '0', '#', 'D'];
	dtmf.row = [697; 770; 852; 941] * ones(1, 4);
	dtmf.col = ones(4, 1) * [1209, 1336, 1477, 1633];
	t = 0 : 1 / fs : per_time;
	y = [0];
	for i = 1:length(keys)
		key = keys(i);
		if (ismember(key, dtmf.keys))
			[r, c] = find(key == dtmf.keys);
			tone = sin(2 * pi * dtmf.row(r, c) * t) ...
				 + sin(2 * pi * dtmf.col(r, c) * t);
			y = [y, zeros(1, 0.05 * fs), tone];
		end;
	end
	y = y ./ 2;
	if (is_disp)
		soundsc(y, fs);
	else
		audiowrite([keys, '.wav'], y, 44100);
	disp(size(y));
	end;