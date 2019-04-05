time_origin = [];
time_circle = [];
time_save = [];
time_add = [];
M = 1000; % length y
limit = 20000;
for N = 1000:100:limit
	fprintf("testing N = %d, M = %d\n", N, M);
	x = rand([1, N]);
	y = rand([1, M]);
	tmp = clock;
	ans1 = conv_origin(x, y);
	time1 = etime(clock, tmp);
	time_origin = [time_origin, time1];
	tmp = clock;
	ans2 = conv_circle(x, y);
	time2 = etime(clock, tmp);
	time_circle = [time_circle, time2];
	tmp = clock;
	ans3 = overlap_save(x, y);
	time3 = etime(clock, tmp);
	time_save = [time_save, time3];
	tmp = clock;
	ans4 = overlap_add(x, y);
	time4 = etime(clock, tmp);
	time_add = [time_add, time4];
	fprintf("origin: %f s\tcircle: %f s\tosave: %f s\toadd: %f s\n", time1, time2, time3, time4); 
end
x = 1000:100:limit;
plot(x, time_origin, '-', x, time_circle, '-', x, time_save, '-', x, time_add, '-');
legend({'origin conv', 'circle conv', 'overlap-save', 'overlap-add'}, 'Location', 'northwest');
xlabel('M');
ylabel('Runtime/s');