%²úÉúDTMFÐÅºÅ
function y = dial(keyNames)
fs = 8000;
dtmf.keys = ... 
    ['1','2','3','A';
    '4','5','6','B';
    '7','8','9','C';
    '*','0','#','D'];
dtmf.col = ones(4,1)*[1209,1336,1477,1633]; 
dtmf.row = [697;770;852;941]*ones(1,4); 
dur = 0.25;
t = 0:1/fs:dur;
y = 0;
for i = 1:length(keyNames) 
    keyName = keyNames(i); 
    if (keyName~='1' && keyName~='2' && keyName~='3' && keyName~='A' && keyName~='4' && keyName~='5' && keyName~='6' && keyName~='B' && keyName~='7' && keyName~='8' && keyName~='9' && keyName~='C' && keyName~='#' && keyName~='0' && keyName~='*' && keyName~='D')
        continue
    end;
    [r,c] = find(dtmf.keys==keyName);
    tone = sin(2*pi*dtmf.row(r,c)*t) + sin(2*pi*dtmf.col(r,c)*t);
    y = [y,zeros(1,0.05*fs),tone];
end
soundsc(y,8000);