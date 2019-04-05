%读入DTMF音频识别内容
%频率8000
function res = readDial(filename)
audio = audioread(filename);
y = abs(fft(audio,2048));
p = y.*y /10000;
row = find(p(1:250) == max(p(1:250)));
col = 300+find(p(300:380) == max(p(300:380)));
if (row < 180) 
    row = 1;
elseif (row < 200) 
    row = 2;
elseif (row < 220) 
    row = 3;
else
    row = 4;
end

if (col < 320) 
    col = 1;
elseif (col < 340) 
    col = 2;
else
    col = 3;
end

keys = ...
    ['1','2','3','A';
    '4','5','6','B';
    '7','8','9','C';
    '*','0','#','D'];
res = keys(row,col);
end
