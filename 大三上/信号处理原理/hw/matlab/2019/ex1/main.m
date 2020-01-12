% 主函数
function main
    global keys; % 按键表
    global freqs; % 频率表
    keys = ['1', '2', '3', 'A';
            '4', '5', '6', 'B';
            '7', '8', '9', 'C';
            '*', '0', '#', 'D';
            '-', '-', '-', '-'];
    freqs = [697, 770, 852, 941, 1209, 1336, 1477, 1633];

    % 输出到文件 ex1.log
    fout = fopen('./ex1.log', 'w');

    % 单按键测试
    fprintf(fout, "Single button test\n");
    fprintf(fout, "|length |fft-result |fft-time |grt-result |grt-time |time ratio |\n");
    fprintf(fout, "| ----  |   ----    |   ----  |   ----    |   ----  |    ----   |\n");
    for i = 0:11
    	[audio, fs] = audioread(['./data/',num2str(i),'.wav']);
        audio = sum(audio, 2) / 2; % 合并左右声道
        % audio = audio(1:4000);
    	fprintf(fout, "|%5d  ", length(audio));
    	tic
        ans = fft_test(audio, fs);
        fft_time = toc;
        fprintf(fout, "|     %c     |%f ", ans, fft_time);
        tic
        ans = goertzel(audio, fs);
        grt_time = toc;
        fprintf(fout, "|     %c     |%f ", ans, grt_time);
        fprintf(fout, "| %f  |", fft_time/grt_time);
        fprintf(fout, "\n");
    end

    % 一组电话号码测试
    [audio, fs] = audioread('./data/18217569099.wav');
    patch_size = fs/3;
    audio = sum(audio, 2) / 2;
    total_len = size(audio, 1);

    fprintf(fout, "telephone number\n");
    fft_result = [];
    tic
    for i = 1:patch_size:total_len-patch_size
    	fft_result = [fft_result, fft_test(audio(i:i+patch_size), fs)];
    end;
    fprintf(fout, "FFT time_cost: %f s\n", toc);
    fprintf(fout, "ans: %s\n", fft_result);

    grt_result = [];
    tic
    for i = 1:patch_size:total_len-patch_size
    	grt_result = [grt_result, goertzel(audio(i:i+patch_size), fs)];
    end;
    fprintf(fout, "Goertzel time_cost: %f s\n", toc);
    fprintf(fout, "ans: %s\n", grt_result);

    fclose(fout);
end

% FFT Algorithm
function ans = fft_test(audio, fs)
    global keys;
    global freqs;

    y = abs(fft(audio));
    len = length(y);
    % 数组下标是数字频率，需要转换成模拟频率
    l1 = round(650  / fs * len);
    h1 = round(1000 / fs * len);
    l2 = round(1150 / fs * len);
    h2 = round(1700 / fs * len);
    [px, col] = max(y(l2:h2));
    [py, row] = max(y(l1:h1));
    col = col + l2 - 1;
    row = row + l1 - 1;
    fx = col / len * fs;
    fy = row / len * fs;

    ans = '-';
    if (px > 10 || py > 10) % 过滤噪声
        [t, row] = min(abs(freqs(1:4) - fy));
        [t, col] = min(abs(freqs(5:8) - fx));
        ans = keys(row, col);
    end;
end

% Goertzel Algorithm
function ans = goertzel(audio, fs)
    global keys;
    global freqs;

    t_freqs = freqs;
    N = length(audio);
    x = audio;
    v = zeros(1,N+2);
    y = zeros(1, 8);
    t_freqs = round(t_freqs * N / fs);

    % 差分方程
    % v_k[n] = 2cos(2k\pi/N)v_k[n-1] - v_k[n-2] + x[n]
    % y_k[n]^2 = v_k[n] - W_N^k*v_k[n-1]
    for k = 1 : length(t_freqs)
        factor = 2 * cos(2 * pi * t_freqs(k) / N);
        for i = 1 : N
            v(i+2) = factor*v(i+1) - v(i) + x(i);          % v_k[n]
        end
        y(k) = v(N+2)^2 + v(N+1)^2 - factor*v(N+2)*v(N+1); % |y_k[N]|^2
    end
    y = sqrt(abs(y));

    % 过滤噪声
    [t, col] = max(y(5:8));
    [t, row] = max(y(1:4));
    px = y(col+4);
    py = y(row);
    trhld = max(px, py)*0.3;
    if (sum((y-trhld) > 0) > 2)
        row = 5;
    end

    ans = keys(row, col);
end

