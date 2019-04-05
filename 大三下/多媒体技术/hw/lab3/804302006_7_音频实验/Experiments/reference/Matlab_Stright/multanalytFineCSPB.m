function pm=multanalytFineCSPB(x,fs,f0floor,nvc,nvo,mu,mlt,imgi);

%       Dual waveleta analysis using cardinal spline manipulation
%               pm=multanalytFineCSPB(x,fs,f0floor,nvc,nvo,mu,mlt)
%       Input parameters 
%               
%               x       : input signal (2kHz sampling rate is sufficient.)
%               fs      : sampling frequency (Hz)
%               f0floor : lower bound for pitch search (60Hz suggested)
%               nvc     : number of total voices for wavelet analysis
%               nvo     : number of voices in an octave
%				mu		: temporal stretch factor
%				mlt		: harmonic ID#
%				imgi	: display indicator, 1: dispaly on (default), 0: display off
%       Outpur parameters
%               pm      : wavelet transform using iso-metric Gabor function
%
%       If you have any questions,  mailto:kawahara@hip.atr.co.jp
%
%       Copyright (c) ATR Human Information Processing Research Labs. 1996
%       Invented and coded by Hideki Kawahara
%       30/Oct./1996
%       07/Dec./2002 waitbar was added
%		10/Aug./2005 modified by Takahashi on waitbar
%		10/Sept./2005 modified by Kawahara on waitbar

if nargin==7; imgi=1; end;%10/Sept./2005
t0=1/f0floor;
lmx=round(6*t0*fs*mu);
wl=2^ceil(log(lmx)/log(2));
x=x(:)';
nx=length(x);
tx=[x,zeros(1,wl)];
txx=tx;
gent=((1:wl)-wl/2)/fs;

%nvc=18;

wd=zeros(nvc,wl);
wd2=zeros(nvc,wl);
ym=zeros(nvc,nx);
pm=zeros(nvc,nx);
mpv=1;
%fs
%mu=1.0;
if imgi==1; hpg=waitbar(0,['wavelet analysis for initial F0 and P/N estimation with HM#:' num2str(mlt)]); end; % 07/Dec./2002 by H.K.%10/Aug./2005
for ii=1:nvc
  tb=gent*mpv;
  t=tb(abs(tb)<3.5*mu*t0);
  wbias=round((length(t)-1)/2);
  wd1=exp(-pi*(t/t0/mu).^2);%.*exp(i*2*pi*t/t0); 
  wd2=max(0,1-abs(t/t0/mu));
  wd2=wd2(wd2>0);
  wwd=conv(wd2,wd1);
  wwd=wwd(abs(wwd)>0.00001);
  wbias=round((length(wwd)-1)/2);
  wwd=wwd.*exp(i*2*pi*mlt*t(round((1:length(wwd))-wbias+length(t)/2))/t0);
  pmtmp1=fftfilt(wwd,tx);
%  ampp=abs(pmtmp1(wbias+1:wbias+nx));
%  txx=[x./ampp,zeros(1,wl)];
%  txx=tx;
%  pmtmp1=fftfilt(wwd,txx);  
%  disp(['ii= ' num2str(ii) '  sum=' num2str(sum(abs(wwd)),6)]);
  pm(ii,:)=pmtmp1(wbias+1:wbias+nx)*sqrt(mpv);
  mpv=mpv*(2.0^(1/nvo));
  if imgi==1; waitbar(ii/nvc); end; %,hpg);% 07/Dec./2002 by H.K.%10/Aug./2005
%  keyboard;
end;
if imgi==1; close(hpg); end; % 07/Dec./2002 by H.K.%10/Aug./2005
%[nn,mm]=size(pm);
%pm=pm(:,1:mlt:mm);
