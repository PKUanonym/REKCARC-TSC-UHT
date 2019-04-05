clear all;
%dial可以模拟拨号
dial('0123456789');
%readDial判断声音是什么
res = [];
for i = 0:9
    res = [res,readDial(['dtmf-',num2str(i),'.wav'])];
end
disp(res);