% FDM HAHAs hsp
function ans = FDM()
	% load data
	[audio1, fs] = audioread('../data/hsp1.wav');
	[audio2, fs] = audioread('../data/hsp2.wav');
	[audio3, fs] = audioread('../data/hsp3.wav');
	fprintf("read freq: %dHz\n", fs);
	duration = 35000; % length of wav
	t = 0 : duration - 1;
	b1 = 5000; % begin addr of audio1
	b2 = 40000; % begin addr of audio2
	b3 = length(audio3) - duration + 1; % begin addr of audio3
	% crop audio
	audio1 = audio1(b1 : b1 + duration - 1);
	audio2 = audio2(b2 : b2 + duration - 1);
	audio3 = audio3(b3 : b3 + duration - 1);
	
	% play origin wav
	fprintf("Playing first audio ...\n");
	soundsc(audio1, fs);
	pause(length(audio1) / fs);
	fprintf("Playing second audio ...\n");
	soundsc(audio2, fs);
	pause(length(audio2) / fs);
	fprintf("Playing third audio ...\n");
	soundsc(audio3, fs);
	pause(length(audio3) / fs);
	% plot origin freq
	figure(1);
	subplot(311);
	stem(t, abs(fft(audio1)), '.');
	subplot(312);
	stem(t, abs(fft(audio2)), '.');
	subplot(313);
	stem(t, abs(fft(audio3)), '.');
	% plot origin audio
	figure(2);
	subplot(311);
	stem(t, audio1, '.');
	subplot(312);
	stem(t, audio2, '.');
	subplot(313);
	stem(t, audio3, '.');

	% encode
	f1 = fft(audio1);
	f2 = fft(audio2);
	f3 = fft(audio3);
	% merge 3 parts of high-freq into one array 
	f = zeros(1, duration);
	f(1:5000) = f1(1:5000);
	f(5001:10000) = f1(30001:35000);
	f(12501:17500) = f2(1:5000);
	f(17501:22500) = f2(30001:35000);
	f(25001:30000) = f3(1:5000);
	f(30001:35000) = f3(30001:35000);
	y = ifft(f); % here y is the transitable data
	% plot encode result
	figure(3);
	subplot(211);
	stem(t, abs(f), '.');
	subplot(212);
	stem(t, real(y), '.');

	% decode
	f = fft(y);
	f1 = zeros(1, duration);
	f1(1:5000) = f(1:5000);
	f1(30001:35000) = f(5001:10000);
	f2 = zeros(1, duration);
	f2(1:5000) = f(12501:17500);
	f2(30001:35000) = f(17501:22500);
	f3 = zeros(1, duration);
	f3(1:5000) = f(25001:30000);
	f3(30001:35000) = f(30001:35000);
	audio1 = real(ifft(f1));
	audio2 = real(ifft(f2));
	audio3 = real(ifft(f3));

	% plot decode freq
	figure(4);
	subplot(311);
	stem(t, abs(f1), '.');
	subplot(312);
	stem(t, abs(f2), '.');
	subplot(313);
	stem(t, abs(f3), '.');
	% plot decode audio
	figure(5);
	subplot(311);
	stem(t, audio1, '.');
	subplot(312);
	stem(t, audio2, '.');
	subplot(313);
	stem(t, audio3, '.');
	% play decode audio
	fprintf("Playing first audio ...\n");
	soundsc(audio1, fs);
	pause(length(audio1) / fs);
	fprintf("Playing second audio ...\n");
	soundsc(audio2, fs);
	pause(length(audio2) / fs);
	fprintf("Playing third audio ...\n");
	soundsc(audio3, fs);
	pause(length(audio3) / fs);
end
