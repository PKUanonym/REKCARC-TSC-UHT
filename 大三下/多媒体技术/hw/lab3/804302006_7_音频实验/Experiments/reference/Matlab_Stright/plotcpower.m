function [pw,pwh]=plotcpower(x,fs,shiftm)
%	30/April/2005 modification for Matlab v7.0 compatibility

flm=4;  % temporal resolution in ms
flm=8;  % 01/August/1999 
fl=round(flm*fs/1000);
w=hanning(2*fl+1);
w=w/sum(w);
nn=length(x);

flpm=40;
flp=round(flpm*fs/1000);
wlp=fir1(flp*2,70/(fs/2));
wlp(flp+1)=wlp(flp+1)-1;
wlp=-wlp;

tx=[x(:)' zeros(1,2*length(wlp))];
ttx=fftfilt(wlp,tx);
ttx=ttx((1:nn)+flp);
tx=[ttx(:)' zeros(1,2*length(w))];

pw=fftfilt(w,tx.^2);
pw=pw((1:nn)+fl);
mpw=max(pw);
pw=pw(round(1:shiftm*fs/1000:nn));
pw(pw<mpw/10000000)=pw(pw<mpw/10000000)+mpw/10000000; % safeguard 15/Jan./2003

b=fir1(2*fl+1,[0.0001 3000/(fs/2)]);
b(fl+1)=b(fl+1)-1;
xh=fftfilt(b,tx);
xh=xh((1:nn)+fl);
tx=[xh(:)' zeros(1,10*length(w))];
pwh=fftfilt(w,tx.^2);
pwh=pwh((1:nn)+fl);
pwh=pwh(round(1:shiftm*fs/1000:nn)); 
pwh(pwh<mpw/10000000)=pwh(pwh<mpw/10000000)+mpw/10000000;% safeguard 15/Jan./2003

subplot(614);
tt=1:length(pw);
hhg=plot(tt*shiftm,10*log10(pw),'b');hold on;
plot(tt*shiftm,10*log10(pwh),'r');grid on;hold off;
set(hhg,'LineWidth',[2]);
mp=max(10*log10(pw));
axis([0 max(tt)*shiftm mp-70 mp+5]);
ylabel('level (dB)');
title('thick line: total power thin line:high fq. power (>3kHz) ');
okid=1;
