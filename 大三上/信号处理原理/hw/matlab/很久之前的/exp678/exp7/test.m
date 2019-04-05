%–‘ƒ‹≤‚ ‘
lh = 1000;
N = 100;
max = 20000;
time_origin = zeros(1,max);
time_circle = zeros(1,max);
time_save = zeros(1,max);
time_add = zeros(1,max);
for lx = 1000:100:max
    lx
    x = rand([1,lx]);
    h = rand([1,lh]);
    temp = clock;
    ans1 = conv_origin(x, h);
    time_origin(lx) = etime(clock, temp); 
    x = rand([1,lx]);
    h = rand([1,lh]);
    temp = clock;
    ans2 = conv_circle(x, h);
    time_circle(lx) = etime(clock, temp); 
    x = rand([1,lx]);
    h = rand([1,lh]);
    temp = clock;
    ans3 = overlap_save(x, h, N);
    time_save(lx) = etime(clock, temp); 
    x = rand([1,lx]);
    h = rand([1,lh]);
    temp = clock;
    ans4 = overlap_add(x, h, N);
    time_add(lx) = etime(clock, temp); 
end
x = 1:max;
plot(x, time_origin,'-y', x, time_circle,'--m', x, time_save, ':c', x, time_add, '-.r');