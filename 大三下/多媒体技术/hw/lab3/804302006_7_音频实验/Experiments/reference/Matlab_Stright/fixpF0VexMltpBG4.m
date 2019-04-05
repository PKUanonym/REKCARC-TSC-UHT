function [f0v,vrv,dfv,nf,aav]=fixpF0VexMltpBG4(x,fs,f0floor,nvc,nvo,mu,imgi,shiftm,smp,minm,pc,nc)

%	Fixed point analysis to extract F0
%	[f0v,vrv,dfv,nf]=fixpF0VexMltpBG4(x,fs,f0floor,nvc,nvo,mu,imgi,shiftm,smp,minm,pc,nc)
%	x	: input signal
%	fs	: sampling frequency (Hz)
%	f0floor	: lowest frequency for F0 search
%	nvc	: total number of filter channels
%	nvo	: number of channels per octave
%	mu	: temporal stretching factor
%	imgi	: image display indicator (1: display image, default)
%	shiftm	: frame shift in ms
%	smp	: smoothing length relative to fc (ratio)
%	minm	: minimum smoothing length (ms)
%	pc	: exponent to represent nonlinear summation
%	nc	: number of harmonic component to use (1,2,3)

%	Designed and coded by Hideki Kawahara
%	28/March/1999
%	04/April/1999 revised to multi component version
%	07/April/1999 bi-reciprocal smoothing for multi component compensation
%	01/May/1999 first derivative of Amplitude is taken into account
%	17/Dec./2000 display bug fix
%	19/Sep./2002 bug fix (mu information was discarded.)
%   07/Dec./2002 waitbar was added
%	30/April/2005 modification for Matlab v7.0 compatibility
%	10/Aug./2005 modified by Takahashi on waitbar
%	10/Sept./2005 mofidied by Kawahara on waitbar
%   11/Sept./2005 fixed waitbar problem
		
%f0floor=40;
%nvo=12;
%nvc=52;
%mu=1.1;

x=cleaninglownoise(x,fs,f0floor);

fxx=f0floor*2.0.^((0:nvc-1)/nvo)';
fxh=max(fxx);

dn=max(1,floor(fs/(fxh*6.3)));

if nc>2
	pm3=multanalytFineCSPB(decimate(x,dn),fs/dn,f0floor,nvc,nvo,mu,3,imgi); % error crrect 2002.9.19 (mu was fixed 1.1)
	pif3=zwvlt2ifq(pm3,fs/dn);
	[nn,mm]=size(pif3);
	pif3=pif3(:,1:3:mm);
	pm3=pm3(:,1:3:mm);
end;

if nc>1
	pm2=multanalytFineCSPB(decimate(x,dn),fs/dn,f0floor,nvc,nvo,mu,2,imgi);% error crrect 2002.9.19(mu was fixed 1.1)
	pif2=zwvlt2ifq(pm2,fs/dn);
	[nn,mm]=size(pif2);
	pif2=pif2(:,1:3:mm);
	pm2=pm2(:,1:3:mm);
end;

pm1=multanalytFineCSPB(decimate(x,dn*3),fs/(dn*3),f0floor,nvc,nvo,mu,1,imgi);% error crrect 2002.9.19(mu was fixed 1.1)
%%%% safe guard added on 15/Jan./2003
mxpm1=max(max(abs(pm1)));
eeps=mxpm1/10000000;
pm1(pm1==0)=pm1(pm1==0)+eeps;
%%%% safe guard end
pif1=zwvlt2ifq(pm1,fs/(dn*3));
%keyboard;

[nn,mm1]=size(pif1);
mm=mm1;
if nc>1
	[nn,mm2]=size(pif2);
	mm=min(mm1,mm2);
end;

if nc>2
	[nn,mm3]=size(pif3);
	mm=min([mm1 mm2 mm3]);
end;

if nc == 2
	for ii=1:mm
		pif2(:,ii)=(pif1(:,ii).*(abs(pm1(:,ii))).^pc ...
			+pif2(:,ii)/2.*(abs(pm2(:,ii))).^pc )...
			./((abs(pm1(:,ii))).^pc+(abs(pm2(:,ii))).^pc);
	end;
end;
if nc == 3 
	for ii=1:mm
		pif2(:,ii)=(pif1(:,ii).*(abs(pm1(:,ii))).^pc ...
			+pif2(:,ii)/2.*(abs(pm2(:,ii))).^pc ...
			+pif3(:,ii)/3.*(abs(pm3(:,ii))).^pc )... 
			./((abs(pm1(:,ii))).^pc+(abs(pm2(:,ii))).^pc+(abs(pm3(:,ii))).^pc);
	end;
end;
if nc == 1
	pif2=pif1;
end;

		  
%pif2=zwvlt2ifq(pm,fs/dn)*2*pi;
pif2=pif2*2*pi;
dn=dn*3;

[slp,pbl]=zifq2gpm2(pif2,f0floor,nvo);
[nn,mm]=size(pif2);
dpif=[pif2(:,2:mm)-pif2(:,1:mm-1)]*fs/dn;
dpif(:,mm)=dpif(:,mm-1);
[dslp,dpbl]=zifq2gpm2(dpif,f0floor,nvo);

damp=[abs(pm1(:,2:mm))-abs(pm1(:,1:mm-1))]*fs/dn;
damp(:,mm)=damp(:,mm-1);
damp=damp./abs(pm1);

%[c1,c2]=znormwght(1000);
fxx=f0floor*2.0.^((0:nn-1)/nvo)'*2*pi;
mmp=0*dslp;
[c1,c2b]=znrmlcf2(1);
if imgi==1; hpg=waitbar(0,'P/N map calculation'); end; % 07/Dec./2002 by H.K.%10/Aug./2005
for ii=1:nn
%	[c1,c2]=znrmlcf2(fxx(ii)/2/pi); % This is OK, but the next Eq is much faster.
	c2=c2b*(fxx(ii)/2/pi)^2;
	cff=damp(ii,:)/fxx(ii)*2*pi*0;
	mmp(ii,:)=(dslp(ii,:)./(1+cff.^2)/sqrt(c2)).^2+(slp(ii,:)./sqrt(1+cff.^2)/sqrt(c1)).^2;
    if imgi==1; waitbar(ii/nn); end; %,hpg); % 07/Dec./2002 by H.K.%10/Aug./2005
end;
if imgi==1; close(hpg); end;%10/Aug./2005

if smp~=0
	smap=zsmoothmapB(mmp,fs/dn,f0floor,nvo,smp,minm,0.4);
else
	smap=mmp;
end;

fixpp=zeros(round(nn/3),mm);
fixvv=fixpp+100000000;
fixdf=fixpp+100000000;
fixav=fixpp+1000000000;
nf=zeros(1,mm);
if imgi==1; hpg=waitbar(0,'Fixed pints calculation'); end; % 07/Dec./2002 by H.K.%10/Aug./2005
for ii=1:mm
	[ff,vv,df,aa]=zfixpfreq3(fxx,pif2(:,ii),smap(:,ii),dpif(:,ii)/2/pi,pm1(:,ii));
	kk=length(ff);
	fixpp(1:kk,ii)=ff;
	fixvv(1:kk,ii)=vv;
	fixdf(1:kk,ii)=df;
	fixav(1:kk,ii)=aa;
	nf(ii)=kk;
    if imgi==1 & rem(ii,10)==0; waitbar(ii/mm); end;% 07/Dec./2002 by H.K.%10/Aug./2005
end;
if imgi==1; close(hpg); end; % 07/Dec./2002 by H.K.%10/Aug./2005
fixpp(fixpp==0)=fixpp(fixpp==0)+1000000;

%keyboard
%[vvm,ivv]=min(fixvv);
%
%for ii=1:mm
%	ff00(ii)=fixpp(ivv(ii),ii);
%	esgm(ii)=fixvv(ivv(ii),ii);
%end;
np=max(nf);
f0v=fixpp(1:np,round(1:shiftm/dn*fs/1000:mm))/2/pi;
vrv=fixvv(1:np,round(1:shiftm/dn*fs/1000:mm));
dfv=fixdf(1:np,round(1:shiftm/dn*fs/1000:mm));
aav=fixav(1:np,round(1:shiftm/dn*fs/1000:mm));
nf=nf(round(1:shiftm/dn*fs/1000:mm));

if imgi==1
	okid=cnmap(fixpp,smap,fs,dn,nvo,f0floor,shiftm);
end;
%ff00=ff00(round(1:shiftm/dn*fs/1000:mm));
%esgm=sqrt(esgm(round(1:shiftm/dn*fs/1000:mm)));
%keyboard;

return;
%------------------------------------------------------------------
function okid=cnmap(fixpp,smap,fs,dn,nvo,f0floor,shiftm)

% 	This function had a bug in map axis.
%	17/Dec./2000 bug fix by Hideki Kawahara.

dt=dn/fs;
[nn,mm]=size(smap);
aa=figure;
set(aa,'PaperPosition',[0.3 0.25 8 10.9]);
set(aa,'Position',[30 130 520 680]);
subplot(211);
imagesc([0 (mm-1)*dt*1000],[1 nn],20*log10(smap(:,round(1:shiftm/dn*fs/1000:mm))));axis('xy')
hold on;
tx=((1:shiftm/dn*fs/1000:mm)-1)*dt*1000;
plot(tx,(nvo*log(fixpp(:,round(1:shiftm/dn*fs/1000:mm))/f0floor/2/pi)/log(2)+0.5)','ko');
plot(tx,(nvo*log(fixpp(:,round(1:shiftm/dn*fs/1000:mm))/f0floor/2/pi)/log(2)+0.5)','w.');
hold off
xlabel('time (ms)');
ylabel('channel #');
colormap(jet);

okid=1;
return;

%------------------------------------------------------------------

function pm=zmultanalytFineCSPm(x,fs,f0floor,nvc,nvo,mu,mlt);

%       Dual waveleta analysis using cardinal spline manipulation
%               pm=multanalytFineCSP(x,fs,f0floor,nvc,nvo);
%       Input parameters 
%               
%               x       : input signal (2kHz sampling rate is sufficient.)
%               fs      : sampling frequency (Hz)
%               f0floor : lower bound for pitch search (60Hz suggested)
%               nvc     : number of total voices for wavelet analysis
%               nvo     : number of voices in an octave
%				mu		: temporal stretch factor
%       Outpur parameters
%               pm      : wavelet transform using iso-metric Gabor function
%
%       If you have any questions,  mailto:kawahara@hip.atr.co.jp
%
%       Copyright (c) ATR Human Information Processing Research Labs. 1996
%       Invented and coded by Hideki Kawahara
%       30/Oct./1996

t0=1/f0floor;
lmx=round(6*t0*fs*mu);
wl=2^ceil(log(lmx)/log(2));
x=x(:)';
nx=length(x);
tx=[x,zeros(1,wl)];
gent=((1:wl)-wl/2)/fs;

%nvc=18;

wd=zeros(nvc,wl);
wd2=zeros(nvc,wl);
ym=zeros(nvc,nx);
pm=zeros(nvc,nx);
mpv=1;
%mu=1.0;
for ii=1:nvc
  t=gent*mpv;
  t=t(abs(t)<3.5*mu*t0);
  wbias=round((length(t)-1)/2);
  wd1=exp(-pi*(t/t0/mu).^2);%.*exp(i*2*pi*t/t0); 
  wd2=max(0,1-abs(t/t0/mu));
  wd2=wd2(wd2>0);
  wwd=conv(wd2,wd1);
  wwd=wwd(abs(wwd)>0.0001);
  wbias=round((length(wwd)-1)/2);
  wwd=wwd.*exp(i*2*pi*mlt*t(round((1:length(wwd))-wbias+length(t)/2))/t0);
  pmtmp1=fftfilt(wwd,tx);
  pm(ii,:)=pmtmp1(wbias+1:wbias+nx)*sqrt(mpv);
  mpv=mpv*(2.0^(1/nvo));
%  keyboard;
end;
%[nn,mm]=size(pm);
%pm=pm(:,1:mlt:mm);

%----------------------------------------------------------------
function pif=zwvlt2ifq(pm,fs)
%	Wavelet to instantaneous frequency map
%	fqv=wvlt2ifq(pm,fs)

%	Coded by Hideki Kawahara
%	02/March/1999

[nn,mm]=size(pm);
pm=pm./(abs(pm));
pif=abs(pm(:,:)-[pm(:,1),pm(:,1:mm-1)]);
pif=fs/pi*asin(pif/2);
pif(:,1)=pif(:,2);

%----------------------------------------------------------------

function [slp,pbl]=zifq2gpm2(pif,f0floor,nvo)
%	Instantaneous frequency 2 geometric parameters
%	[slp,pbl]=ifq2gpm(pif,f0floor,nvo)
%	slp		: first order coefficient
%	pbl		: second order coefficient

%	Coded by Hideki Kawahara
%	02/March/1999

[nn,mm]=size(pif);
fx=f0floor*2.0.^([0:nn-1]/nvo)*2*pi;

c=2.0^(1/nvo);
g=[1/c/c 1/c 1;1 1 1;c*c c 1];
h=inv(g);

%slp=pif(1:nn-2,:)*h(1,1)+pif(2:nn-1,:)*h(1,2)+pif(3:nn,:)*h(1,3);
slp=((pif(2:nn-1,:)-pif(1:nn-2,:))/(1-1/c) ...
    +(pif(3:nn,:)-pif(2:nn-1,:))/(c-1))/2;
slp=[slp(1,:);slp;slp(nn-2,:)];

pbl=pif(1:nn-2,:)*h(2,1)+pif(2:nn-1,:)*h(2,2)+pif(3:nn,:)*h(2,3);
pbl=[pbl(1,:);pbl;pbl(nn-2,:)];

for ii=1:nn
	slp(ii,:)=slp(ii,:)/fx(ii);
	pbl(ii,:)=pbl(ii,:)/fx(ii);
end;

%------------------------------------------

%function [c1,c2]=znormwght(n)

%zz=0:1/n:3;
%hh=[diff(zGcBs(zz,0)) 0]*n;
%c1=sum((zz.*hh).^2)/n;
%c2=sum((2*pi*zz.^2.*hh).^2)/n;

%-------------------------------------------

function p=zGcBs(x,k)

tt=x+0.0000001;
p=tt.^k.*exp(-pi*tt.^2).*(sin(pi*tt+0.0001)./(pi*tt+0.0001)).^2;


%--------------------------------------------
function smap=zsmoothmapB(map,fs,f0floor,nvo,mu,mlim,pex)

[nvc,mm]=size(map);
%mu=0.4;
t0=1/f0floor;
lmx=round(6*t0*fs*mu);
wl=2^ceil(log(lmx)/log(2));
gent=((1:wl)-wl/2)/fs;

smap=map;
mpv=1;
zt=0*gent;
iiv=1:mm;
for ii=1:nvc
	t=gent*mpv; %t0*mu/mpv*1000
	t=t(abs(t)<3.5*mu*t0);
	wbias=round((length(t)-1)/2);
	wd1=exp(-pi*(t/(t0*(1-pex))/mu).^2);
	wd2=exp(-pi*(t/(t0*(1+pex))/mu).^2);
	wd1=wd1/sum(wd1);
	wd2=wd2/sum(wd2);
	tm=fftfilt(wd1,[map(ii,:) zt]);
	tm=fftfilt(wd2,[1.0./tm(iiv+wbias) zt]);
	smap(ii,:)=1.0./tm(iiv+wbias);
	if t0*mu/mpv*1000 > mlim
		mpv=mpv*(2.0^(1/nvo));
	end;
end;

%--------------------------------------------
function [ff,vv,df]=zfixpfreq2(fxx,pif2,mmp,dfv)

nn=length(fxx);
iix=(1:nn)';
cd1=pif2-fxx;
cd2=[diff(cd1);cd1(nn)-cd1(nn-1)];
cdd1=[cd1(2:nn);cd1(nn)];
fp=(cd1.*cdd1<0).*(cd2<0);
ixx=iix(fp>0);
ff=pif2(ixx)+(pif2(ixx+1)-pif2(ixx)).*cd1(ixx)./(cd1(ixx)-cdd1(ixx));
%vv=mmp(ixx);
vv=mmp(ixx)+(mmp(ixx+1)-mmp(ixx)).*(ff-fxx(ixx))./(fxx(ixx+1)-fxx(ixx));
df=dfv(ixx)+(dfv(ixx+1)-dfv(ixx)).*(ff-fxx(ixx))./(fxx(ixx+1)-fxx(ixx));

%--------------------------------------------
function [ff,vv,df,aa]=zfixpfreq3(fxx,pif2,mmp,dfv,pm)

aav=abs(pm);
nn=length(fxx);
iix=(1:nn)';
cd1=pif2-fxx;
cd2=[diff(cd1);cd1(nn)-cd1(nn-1)];
cdd1=[cd1(2:nn);cd1(nn)];
fp=(cd1.*cdd1<0).*(cd2<0);
ixx=iix(fp>0);
ff=pif2(ixx)+(pif2(ixx+1)-pif2(ixx)).*cd1(ixx)./(cd1(ixx)-cdd1(ixx));
%vv=mmp(ixx);
vv=mmp(ixx)+(mmp(ixx+1)-mmp(ixx)).*(ff-fxx(ixx))./(fxx(ixx+1)-fxx(ixx));
df=dfv(ixx)+(dfv(ixx+1)-dfv(ixx)).*(ff-fxx(ixx))./(fxx(ixx+1)-fxx(ixx));
aa=aav(ixx)+(aav(ixx+1)-aav(ixx)).*(ff-fxx(ixx))./(fxx(ixx+1)-fxx(ixx));

%--------------------------------------------
function [c1,c2]=znrmlcf2(f)

n=100;
x=0:1/n:3;
g=zGcBs(x,0);
dg=[diff(g) 0]*n;
dgs=dg/2/pi/f;
xx=2*pi*f*x;
c1=sum((xx.*dgs).^2)/n*2;
c2=sum((xx.^2.*dgs).^2)/n*2;

%--------------------------------------------
function x=cleaninglownoise(x,fs,f0floor);

flm=50;
flp=round(fs*flm/1000);
nn=length(x);
wlp=fir1(flp*2,f0floor/(fs/2));
wlp(flp+1)=wlp(flp+1)-1;
wlp=-wlp;

tx=[x(:)' zeros(1,2*length(wlp))];
ttx=fftfilt(wlp,tx);
x=ttx((1:nn)+flp);

return;

