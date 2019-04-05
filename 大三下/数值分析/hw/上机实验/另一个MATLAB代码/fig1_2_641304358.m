h=logspace(-16, 0, 33);    % sampling of h
yerr= (sin(1+h)-sin(1))./h; % finite difference
yerr= yerr-cos(1);         % error of finite difference

trunc_err= h/2;            % estimation of truncation error
round_err= eps/2*ones(size(h,1))./h; % estimation of rounding error
% plot the curves
fig=loglog(h, trunc_err, 'k-.', ...
        h, round_err, 'k--', ...
        h, abs(yerr), 'k-', ...
        h, trunc_err+round_err, 'k-');
% set linewidth, axis and ticks for better visibility
set(fig, 'linewidth', 3);
axis([1e-16, 1, 1e-17, 1e1]);
ytick=logspace(-17,1,10);
ytick(1)=1e-17;
set(gca,'xtick',logspace(-16, 0, 9), 'ytick', ytick)

