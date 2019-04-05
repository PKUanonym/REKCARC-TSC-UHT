% single button test bench
fprintf("Single button test\n");
for i = 0:9
	[audio, fs] = audioread(['../data/dtmf-', num2str(i), '.wav']);
	fprintf("test %d audio length %d\n", i, length(audio));
	tic
    fprintf("FFT gives %c\n", fft_test(audio, fs));
    toc
    tic
    fprintf("Goertzel gives %c\n", goertzel(audio, fs));
    toc
    fprintf("\n");
end

% synthesis wave by gen_dtmf
patch_size = 5000;
[audio, fs] = audioread('../data/18750763198.wav');
total_len = size(audio, 1);

fprintf("Synthesis wave test\n");
fprintf("FFT: ");
ans_fft = [];
tic
for i = 1:patch_size:total_len-patch_size
	ans_fft = [ans_fft, fft_test(audio(i:i+patch_size), fs)];
end;
toc
fprintf("FFT gives %s\n", ans_fft);

fprintf("Goertzel: ");
ans_grt = [];
tic
for i = 1:patch_size:total_len-patch_size
	ans_grt = [ans_grt, goertzel(audio(i:i+patch_size), fs)];
end;
toc
fprintf("Goertzel gives %s\n", ans_grt);

% real stereo wave test
patch_size = 1000;
[audio, fs] = audioread('../data/zhw.wav');
total_len = size(audio, 1);
audio = (audio(:, 1) + audio(:, 2)) ./ 2;

fprintf("\nReal stereo wave test\n");
fprintf("FFT: ");
ans_fft = [];
tic
for i = 1:patch_size:total_len-patch_size
	ans_fft = [ans_fft, fft_test(audio(i:i+patch_size), fs)];
end;
toc
fprintf("FFT gives %s\n", ans_fft);

fprintf("Goertzel: ");
ans_grt = [];
tic
for i = 1:patch_size:total_len-patch_size
	ans_grt = [ans_grt, goertzel(audio(i:i+patch_size), fs)];
end;
toc
fprintf("Goertzel gives %s\n", ans_grt);
