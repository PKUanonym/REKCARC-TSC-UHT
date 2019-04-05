function [f0r,ecr]=refineF06(x,fs,f0raw,fftl,eta,nhmx,shiftm,nl,nu,imgi);
%	F0 estimation refinement
%	[f0r,ecr]=refineF06(x,fs,f0raw,fftl,nhmx,shiftm,nl,nu,imgi)
%		x		: input waveform
%		fs		: sampling frequency (Hz)
%		f0raw	: F0 candidate (Hz)
%		fftl	: FFT length
%		eta		: temporal stretch factor
%		nhmx	: highest harmonic number
%		shiftm	: frame shift period (ms)
%		nl		: lower frame number
%		nu		: uppter frame number
%		imgi	: display indicator, 1: display on (default), 0: off
%
%	Example of usage (with STRAIGHT)
%
%	global xold fs f0shiftm f0raw
%
%	dn=floor(fs/(800*3*2));
%	[f0raw,ecr]=refineF02(decimate(xold,dn),fs/dn,f0raw,512,1.1,3,f0shiftm,1,length(f0raw));

%	Designed and coded by Hideki Kawahara
%	28/July/1999
%	29/July/1999 test version using power weighting
%	30/July/1999 GcBs is added (bug fix)
%	07/August/1999 small bug fix
%   07/Dec./2002 wqitbar was added
%   13.May/2005 minor vulnerability fix
%	10/Aug./2005 modified by Takahashi on waitbar
%	10/Sept./2005 modified by Kawahara on waitbar
%   16/Sept./2005 minor bug fix
%   26/Sept./2005 bug fix

if nargin==9; imgi=1; end;
f0i=f0raw(:);
f0i(f0i==0)=f0i(f0i==0)+160;
fx=(0:fftl-1)/fftl;
fax=(0:fftl-1)/fftl*fs;
xlinms=length(x)/fs*1000;
%nfr=min(length(f0i),round(xlinms/shiftm));
nfr=length(f0i); % 07/August/1999 

shiftl=shiftm/1000*fs;
fmx=zeros(nfr,nhmx);
vx=zeros(nfr,nhmx);
fvi=zeros(nu-nl+1,fftl/2+1);
vfs=zeros(nfr,nhmx);
avi=fvi*0;
lenx=length(x);
x=[zeros(fftl,1); x(:) ; zeros(fftl,1)]';

tt=((1:fftl)-fftl/2)/fs;
th=(0:fftl-1)/fftl*2*pi;
rr=exp(-i*th);

f0t=100;
w1=max(0,1-abs(tt'*f0t/eta));
w1=w1(w1>0);
wg=exp(-pi*(tt*f0t/eta).^2);
wgg=(wg(abs(wg)>0.0002));
wo=fftfilt(wgg,[w1; zeros(length(wgg),1)])';

xo=(0:length(wo)-1)/(length(wo)-1);
nlo=length(wo)-1;
xi=0:1/nlo*200/100:1;
wa=interp1(xo,wo,xi,'*linear');

if nl*nu <0
	nl=1;
	nu=nfr;
end;

bx=1:fftl/2+1;
pif=zeros(fftl/2+1,nfr);
dpif=zeros(fftl/2+1,nfr);
pwm=zeros(fftl/2+1,nfr);
rmsValue = std(x); % 26/Sept./2005 by HK

if imgi==1; hpg=waitbar(0,'F0 refinement using F0 adaptive analysis'); end; % 07/Dec./2002 by H.K.%10/Aug./2005
for kk=nl:nu
		if f0i(kk) < 40
		f0i(kk)=40;
	end;
	nf0=fftl/(fs/f0i(kk));
	f0t=f0i(kk);
	xi=0:1/nlo*f0t/100:1;
	wa=interp1(xo,wo,xi,'*linear');
	wal=length(wa);
	bb=1:wal;
	bias=round(fftl-wal/2+(kk-1)*shiftl);
    if std(x(bb+bias))*std(x(bb+bias-1))*std(x(bb+bias+1)) == 0 % 26/Sept./2005 by HK
        x(bb+bias) = randn(length(bb),1)*rmsValue/100000;
    end;
	dcl=mean(x(bb+bias));
	ff0=fft((x(bb+bias-1)-dcl).*wa,fftl);
	ff1=fft((x(bb+bias)-dcl).*wa,fftl);
	ff2=fft((x(bb+bias+1)-dcl).*wa,fftl);
	fd=ff2.*rr-ff1;
	fd0=ff1.*rr-ff0;
	crf=fax+(real(ff1).*imag(fd)-imag(ff1).*real(fd))./(abs(ff1).^2)*fs/pi/2;
	crf0=fax+(real(ff0).*imag(fd0)-imag(ff0).*real(fd0))./(abs(ff0).^2)*fs/pi/2;
	pif(:,kk)=crf(bx)'*2*pi;
	dpif(:,kk)=(crf(bx)-crf0(bx))'*2*pi;
	pwm(:,kk)=abs(ff1(bx)'); % 29/July/1999
        if imgi==1; waitbar((kk-nl)/(nu-nl)); end; % ,hpg) % 07/Dec./2002 by H.K.%10/Aug./2005
%	keyboard;
end;
if imgi==1; close(hpg); end;
slp=([pif(2:fftl/2+1,:);pif(fftl/2+1,:)]-pif)/(fs/fftl*2*pi);
dslp=([dpif(2:fftl/2+1,:);dpif(fftl/2+1,:)]-dpif)/(fs/fftl*2*pi)*fs;
mmp=slp*0;

%[c1,c2]=znrmlcf2(1);
[c1,c2]=znrmlcf2(shiftm);
fxx=((0:fftl/2)+0.5)/fftl*fs*2*pi;

%--- calculation of relative noise level

if imgi==1; hpg=waitbar(0,'P/N calculation'); end; % 07/Dec./2002 by H.K.%10/Aug./2005
for ii=1:fftl/2+1;
	c2=c2*(fxx(ii)/2/pi)^2;
	mmp(ii,:)=(dslp(ii,:)/sqrt(c2)).^2+(slp(ii,:)/sqrt(c1)).^2;
    if imgi==1 & rem(ii,10)==0;waitbar(ii/(fftl/2+1));end;  % 07/Dec./2002 by H.K.%10/Aug./2005
end;
if imgi==1; close(hpg); end; % 07/Dec./2002 by H.K.%10/Aug./2005

%--- Temporal smoothing

%sml=round(6*fs/1000/2)*2+1; % 12 ms, and odd number
%sml=round(4*fs/1000/2)*2+1; % 8 ms, and odd number
sml=round(1.5*fs/1000/2/shiftm)*2+1; % 3 ms, and odd number
smb=round((sml-1)/2); % bias due to filtering

if imgi==1; hpg=waitbar(0,'P/N smoothing'); end; % 07/Dec./2002 by H.K.%10/Aug./2005
%This smoothing is modified (30 Nov. 2000).
smmp=fftfilt((hanning(sml).^2)/sum((hanning(sml).^2)), ...
    [mmp zeros(fftl/2+1,sml*2)]'+max(max(mmp((~isnan(mmp))&(mmp<Inf))))*0.0000001)'; % 26/Sept./2005 by H.K.
if imgi==1; waitbar(0.2); end;%10/Aug./2005
smmp=1.0./fftfilt(hanning(sml)/sum(hanning(sml)),1.0./smmp')';
if imgi==1; waitbar(0.4); end;
smmp=smmp(:,max(1,(1:nfr)+sml-2)); % fixed by H.K. on 10/Dec./2002

%--- Power adaptive weighting (29/July/1999)

spwm=fftfilt(hanning(sml)/sum(hanning(sml)),[pwm zeros(fftl/2+1,sml*2)]'+0.00001)';
if imgi==1; waitbar(0.6); end;%10/Aug./2005
spfm=fftfilt(hanning(sml)/sum(hanning(sml)),[pwm.*pif zeros(fftl/2+1,sml*2)]'+0.00001)';
if imgi==1; waitbar(0.8); end;%10/Aug./2005
spif=spfm./spwm;
spif=spif(:,(1:nfr)+smb);

%keyboard;

idx=max(0,f0i/fs*fftl);
%iidx=idx+(0:nfr-1)*(fftl/2+1)+1;
%vv=smmp(floor(iidx))+(iidx-floor(iidx)).*(smmp(floor(iidx)+1)-smmp(floor(iidx)));
%iidx2=iidx+idx;
%iidx3=iidx+2*idx;
%vv2=smmp(floor(iidx2))+(iidx2-floor(iidx2)).*(smmp(floor(iidx2)+1)-smmp(floor(iidx2)));
%vv3=smmp(floor(iidx3))+(iidx3-floor(iidx3)).*(smmp(floor(iidx3)+1)-smmp(floor(iidx3)));
%fq1=(pif(floor(iidx))+(iidx-floor(iidx)).*(pif(floor(iidx)+1)-pif(floor(iidx))))/2/pi;
%fq2=(pif(floor(iidx2))+(iidx2-floor(iidx2)).*(pif(floor(iidx2)+1)-pif(floor(iidx2))))/2/pi;
%fq3=(pif(floor(iidx3))+(iidx3-floor(iidx3)).*(pif(floor(iidx3)+1)-pif(floor(iidx3))))/2/pi;
%ffq=(fq1./sqrt(vv)+fq2./sqrt(vv2/4)/2+fq3./sqrt(vv3/9)/3)./(1.0./sqrt(vv)+1.0./sqrt(vv2/4)+1.0./sqrt(vv3/9));
%vvt=1.0./(1.0./vv+1.0./vv2*4+1.0./vv3*9);

fqv=zeros(nhmx,nfr);
vvv=zeros(nhmx,nfr);

iidx=(0:nfr-1)*(fftl/2+1)+1;
for ii=1:nhmx
	iidx=idx(:)'+iidx;
	vvv(ii,:)=(smmp(floor(iidx))+(iidx-floor(iidx)).*(smmp(floor(iidx)+1)-smmp(floor(iidx))))/(ii*ii);
%	fqv(ii,:)=(pif(floor(iidx))+(iidx-floor(iidx)).*(pif(floor(iidx)+1)-pif(floor(iidx))))/2/pi/ii;
	fqv(ii,:)=(spif(floor(iidx))+(iidx-floor(iidx)).*(spif(floor(iidx)+1)-spif(floor(iidx))))/2/pi/ii; % 29/July/199
end;
if imgi==1; waitbar(1); end;%10/Aug./2005
vvvf=1.0./sum(1.0./vvv);
f0r=sum(fqv./sqrt(vvv))./sum(1.0./sqrt(vvv)).*(f0raw(:)'>0);
ecr=sqrt(1.0./vvvf).*(f0raw(:)'>0)+(f0raw(:)'<=0);
if imgi==1; close(hpg); end;%10/Aug./2005

%keyboard;

%--------------------
function [c1,c2]=znrmlcf2(f)

n=100;
x=0:1/n:3;
g=GcBs(x,0);
dg=[diff(g) 0]*n;
dgs=dg/2/pi/f;
xx=2*pi*f*x;
c1=sum((xx.*dgs).^2)/n;
c2=sum((xx.^2.*dgs).^2)/n;

%---------------------
function p=GcBs(x,k)

tt=x+0.0000001;
p=tt.^k.*exp(-pi*tt.^2).*(sin(pi*tt+0.0001)./(pi*tt+0.0001)).^2;


