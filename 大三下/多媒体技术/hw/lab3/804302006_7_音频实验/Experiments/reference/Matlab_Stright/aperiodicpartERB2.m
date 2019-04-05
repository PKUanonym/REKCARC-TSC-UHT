function [apv,dpv,apve,dpve]=aperiodicpartERB2(x,fs,f0,shiftm,intshiftm,mm,imgi);
%	Relative aperiodic energy estimation with ERB smoothing
%		[apv,dpv,apve,dpve]=aperiodicpartERB2(x,fs,f0,shiftm,intshiftm,mm,imgi)
%		x	: input speech
%		fs	: sampling frequency (Hz)
%		f0	: fundamental frequency (Hz)
%		shiftm	: frame shift (ms) for input F0 data
%		intshiftm 	: frame shift (ms) for internal processing
%		mm	: length of frequency axis (usually 2^N+1)
%		imgi	: display indicator, 1: display on (default) 0: off

%	19/August/1999
%	21/August/1999
%	30/May/2001
%	10/April/2002 completely rewrote
%   07/Dec./2002 waitbar was added
%   13/Jan./2005 bug fix
%   08/April/2005 safe guard
%	10/Aug./2005 modified by Takahashi on wait bar
%	10/Sept./2005 modified by Kawahara on wait bar
%   16/Sept./2005 minor bug fix

if nargin==6; imgi=1; end; % 10/Sept./2005
if imgi==1; hpg=waitbar(0,'ERB-based multiband periodicity calculation'); end;
f0(isnan(f0)>0)=zeros(size(f0(isnan(f0)>0))); % safe guard
lowerF0limit = 40; % safe guard 16/Sept./2005

fftl=2.0.^ceil(log2(6.7*fs/lowerF0limit)+1);  % FFT size selection to be scalable
if length(f0(f0>0))>0;avf0=mean(f0(f0>0));else avf0=180;end; % 08/April/2005
f0bk=f0;
f0(f0==0)=f0(f0==0)+avf0;
f0(f0<lowerF0limit)=f0(f0<lowerF0limit)*0+lowerF0limit;% safe guard 16/Sept./2005
f0=f0(:);
f0i=interp1((0:length(f0)+2)*(shiftm/1000),[f0;f0(end)*ones(3,1)],(0:length(x)-1)/fs);
phr=cumsum(2*pi*f0*shiftm/1000);
phri=interp1((0:length(phr)-1),phr,(0:length(x)-1)/(length(x)-1)*(length(phr)-1));
if imgi==1; waitbar(0.05); end; % 08/Dec./2002%10/Aug./2005
phc=phr(1):2*pi*40/fs:phr(end);
xi=interp1(phri,x,phc);
f0ii=interp1(phri,f0i,phc);
t0=(0:length(x)-1)/fs;
ti=interp1(phri,t0,phc);
if imgi==1; waitbar(0.1); end; % 08/Dec./2002 %10/Aug./2005
tidx=interp1(ti,(0:length(ti)-1),0:(intshiftm/1000):ti(end))+1;
fxa=(0:mm-1)/(mm-1)*fs/2;
fxfi=(0:fftl/2)'/fftl*fs;

bias=fftl;
xii=[zeros(fftl,1);xi(:);zeros(fftl,1)];
xii=xii+randn(length(xii),1)*max(abs(xii))/100000;  % safeguard
%----- window design This is for test
ww=blackman(fftl);
ww=(ww.^4)/sum(ww.^4);
wo=ww;
%----- window design for 40 Hz ------

tt=((1:fftl)-fftl/2)/fs;
w=exp(-pi*(tt*40/1).^2);  % 40/0.2 to 40/2 worked reasonably. But, WATCH fftl !!
wb=max(0,1-abs(tt*40/2));
wb=wb(wb>0);
wcc=fftfilt(wb,[zeros(1,fftl),w,zeros(1,fftl)]);
wcc=wcc/max(wcc);
[dm,mxp]=max(wcc);
%wcc=wcc(wcc>0.00002)-0.00002;
wcc=wcc-wcc(1);
wcc=wcc/sum(wcc);
ww=wcc(round((1:fftl)-fftl/2+mxp))';
%keyboard;
%--------
pwr=zeros(length(tidx),1);
bb=(1:fftl)-fftl/2;

%----- spectrum smoother design
fff=[2:fftl 1];
ffb=[fftl 1:fftl-1];
%----- lifter design
qx=(0:fftl-1)/fs;
lft=1.0./(1+exp((qx-1.4/40)*1000))';
lft(fftl:-1:fftl/2)=lft(2:fftl/2+2);
%------ preparation for EREB smoothing

evv=(0:1024)/1024*HzToErbRate(fs/2); % ERB axis for smoothing
eew=1; % effective smoothing width in ERB
lh=round(2*eew/evv(2)); % number of samples for 2*eew on evv axis
we=hanning(lh)/sum(hanning(lh)); % Hanning window is used for smoothing
bx=(1:length(evv)); % index for extraction
hvv=228.8*(10.0.^(0.0467*evv)-1); % frequency axis represented in Hz
hvv(1)=0; hvv(end)=fs/2; % safeguard

evx=(0:0.5:max(evv));

bss=(1:fftl/2-1);
bss2=1:fftl/2;

apv=zeros(mm,length(tidx));
dpv=zeros(mm,length(tidx));
apve=zeros(length(evx),length(tidx));
dpve=apve;

%keyboard

for ii=1:length(tidx);
	idp=round(tidx(ii))+bias;
%	pwr(ii)=std(xii(idp+bb).*ww)^2;
	sw=abs(fft(xii(idp+bb).*ww));
	sws=(sw*2+sw(ffb)+sw(fff))/4;
	sms=real(ifft(real(fft(log(sws))).*lft))/log(10)*20; %smoothed dB spectrum
	plits=[0; (((diff(sms(bss2)).*diff(sms(bss2+1)))<0).*sms(bss).*(diff(sms(bss2))>0))];
	dlits=[0; (((diff(sms(bss2)).*diff(sms(bss2+1)))<0).*sms(bss).*(diff(sms(bss2))<0))];
	gg=fxfi(abs(plits)>0);
	gfg=(sms(abs(plits)>0));
	afa=sms(abs(plits)>0);
	if length(gfg)>0
		gfg1=gfg(1);
	  else
		gfg1=sms(1);
	end;
	dd=fxfi(abs(dlits)>0);
	dfd=(sms(abs(dlits)>0));
	if length(dfd)>0
		dfd1=dfd(1);
	else
		dfd1=sms(1);
	end;
	gga=[0;gg;fs/2]*f0ii(round(tidx(ii)))/40;
	dda=[0;dd;fs/2]*f0ii(round(tidx(ii)))/40;
	dfda=[dfd(1) ;dfd ;dfd(end)]; % dip level (dB)
	gfga=[gfg(1); gfg ;gfg(end)]; % peak level (dB)
	dfdap=10.0.^(dfda/10); % dip level (power)
	gfgap=10.0.^(gfga/10); % peak level (power)
	ape=interp1(HzToErbRate(gga),gfgap,evv); % Upper power envelope on ERB
	dpe=interp1(HzToErbRate(dda),dfdap,evv); % Lower power envelope on ERB

	apef=[ape(lh:-1:2) ape ape(end-1:-1:end-lh)]; % ape with mirrored ends
	dpef=[dpe(lh:-1:2) dpe dpe(end-1:-1:end-lh)]; % dpe with mirrored ends

	apefs=fftfilt(we,apef); % smoothed ape
	dpefs=fftfilt(we,dpef); % smoothed dpe

	apefs=apefs(bx+lh-1+round(lh/2)); 
	dpefs=dpefs(bx+lh-1+round(lh/2));
	apr=interp1(hvv,apefs,fxa); % smoothed ape on linear axis
	dpr=interp1(hvv,dpefs,fxa); % smoothed dpe on linear axis
%	keyboard;
	dpv(:,ii)=dpr';
	apv(:,ii)=apr';
	dpve(:,ii)=interp1(evv,dpefs,evx)';
	apve(:,ii)=interp1(evv,apefs,evx)';
  if imgi==1 & rem(ii,2)==0 %10/Aug./2005
%    fprintf('o')
     waitbar(0.1+0.9*ii/length(tidx)); %,hpg);
%    if rem(ii,40)==0
%		keyboard
%       fprintf('\n')
%    end;
  end;

end;
if imgi==1; fprintf('\n'); end;%10/Aug./2005
if imgi==1; close(hpg); end;%10/Aug./2005

%keyboard;
