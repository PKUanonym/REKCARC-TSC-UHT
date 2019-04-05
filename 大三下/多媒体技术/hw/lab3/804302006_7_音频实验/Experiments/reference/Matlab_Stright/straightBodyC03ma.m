function [n2sgram,nsgram]=straightBodyC03ma(x,fs,shiftm,fftl,f0raw,f0var,f0varL,eta,pc,imgi);
%  [n2sgram,nsgram]=straightBodyC03ma(x,fs,shiftm,fftl,f0raw,f0var,f0varL,eta,pc,imgi)
%	n2sgram		: smoothed spectrogram
%	nsgram		: isometric spectrogram
%	x		: input waveform
%	fs		: sampling frequency (Hz)
%	shiftm		: frame shift (ms)
%	fftl		: length of FFT
%	f0raw		: Pitch information to gude analysis (TEMPO) assumed
%	f0var		: expected f0 variance including zerocross information
%	f0varL		: expected f0 variance 
%	eta		: 
%	pc		:
%	imgi	: display indicator 1: display on (default), 0: off

%	f0shiftm	: frame shift (ms) for F0 analysis

%	STRAIGHT body:  Interporation using adaptive gaussian weighting
%	and 2-dimensional Bartlett window
%	by Hideki Kawahara
%	02/July/1996
%	07/July/1996
%	07/Sep./1996 
%	09/Sep./1996 guiding F0 information can be coarse
%	14/Oct./1996 correction for over smoothing
%	19/Oct./1996 Alternating Gaussian Correction
%	01/Nov./1996 Temporal integration using Fluency theory (didn't work)
%	03/Nov./1996 Temporal integration using Fluency theory
%	25/Dec./1996 Quasi optimum smooting
%	01/Feb./1997 Minimum variance analysis
%	03/Feb./1997 Clean up
%	08/Feb./1997 Fine tuning for onset enhancement
%	13/Feb./1997 another fine temporal structure
%	16/Feb./1997 better alternating Gaussian
%	21/Feb./1997 no need for temporal interpolation!
%	19/June/1997 Control of Analysis Paramters
%	21/July/1997 Discard of optimum comp. and introduction TD compensation
%	11/Aug./1997 Re-installation of temporal smooting
%	08/Feb./1998 debug and speed up using closed form
%	22/April/1999 Compatible with new F0 extraction routine
%	31/March/2002 modified for ICSLP2002
%   03/Feb./2003 Bug fix in the modification on 31/March/2002
%	10/Aug./2005 modified by Takahashi on waitbar
%	10/Sept./2005 modified by Kawahara on waitbar
%   05/Oct./2005 bug fix on smoothing (both in time and frequency)

if nargin==9; imgi=1; end; % 10/Sept./2005
f0l=f0raw(:);
framem=40;
fx=((1:fftl)-fftl/2-1)/fftl*fs;
framel=round(framem*fs/1000);
if fftl<framel
  disp('Warning! fftl is too small.');
  fftl=2^ceil(log(framel)/log(2) );
  disp(['New length:' num2str(fftl) ' is used.']);
end;
x=x(:)';
smoothinid=1;
if shiftm >1.5
  disp('Frame shift has to be small enough. (Less than 1 ms is recommended.)');
  disp('Temporal smoothing will be disabled');
  smoothinid=0;
end;
smoothinid=0; % modificatin for ICSLP'2002
shiftl=shiftm*fs/1000;

%   High-pass filtering using 70Hz cut-off butterworth filter

[b,a]=butter(6,70/fs*2,'high');
xh=filter(b,a,x);
rmsp=std(xh);

%xh=x;  % mod for ICSLP 2002

[b,a]=butter(6,300/fs*2,'high');  % 08/Sept./1999
xh2=filter(b,a,x);


%	High-pass filter using 3000Hz cut-off butterworth filter
[b,a]=butter(6,3000/fs*2,'high');
xhh=filter(b,a,x);

tx=[randn(1,framel/2)*rmsp/4000,xh,randn(1,framel)*rmsp/4000];
txs=tx;

%datalength=length(tx);
%nframe=floor((datalength-framel)/shiftl);
nframe=min(length(f0l),round(length(x)/shiftl));

nsgram=zeros(fftl/2+1,nframe);  % adaptive spectrogram
n2sgram=zeros(fftl/2+1,nframe);

t=([1:framel]-framel/2)/framel*2;
wx=(exp(-(4*t).^2/2));
tt=([1:framel]-framel/2)/fs;
refw=sum(wx);

bbase=1:fftl/2+1;

zerobase=zeros(1,fftl);
ist=1; % ii=1;
f0x=f0l*0;

% Optimum blending table for interference free spec.
cfv=[1.03 0.83 0.67 0.54 0.43 0.343 0.2695];
muv=[1    1.1  1.2  1.3  1.4  1.5   1.6];

bcf=spline(muv,cfv,eta);

% Calculate the optimum smoothing function coefficients

ovc=optimumsmoothing(eta,pc);

% Design windows for unvoiced

fc= 300;  % default frequency resolution for unvoiced signal
fc= 160;  % default frequency resolution for unvoiced signal (13/April/1999)
c0=4*exp(-pi/2);
t0=1/fc;
wxec=exp(-pi*(tt*fc).^2);
cfc=sqrt(sum(wxec.^2));
wxec=wxec/cfc;  
wxdc=bcf*wxec.*sin(pi*tt/t0); 

ttm=[0.00001 1:fftl/2 -fftl/2+1:-1]/fs;
bfq=fftl:-1:2;
ffq=2:fftl;

lft=1.0./(1+exp(-(abs((1:fftl)-fftl/2-1)-fftl/30)/2)); % safeguard 05/Oct./2005 by HK

if imgi==1; hpg=waitbar(0,'F0 adaptive time-frequency analysis.'); end;% 10/Aug./2005
%while (ist+framel<datalength) & (ii<=min(length(f0l),nframe))
for ii=1:nframe
%  tic;
  if imgi==1 & rem(ii,10)==0 % 10/Aug./2005
%    fprintf('o')
%    if rem(ii,200)==0
%       fprintf('\n')
%    end;
     waitbar(ii/nframe);
  end;
  f0=f0l(max(1,ii));
  if f0==0 
     f0=200; %

     f0=160; % 09/Sept./1999
  end;
  
  f0x(ii)=f0;
  t0=1/f0;

  wxe=exp(-pi*(tt/t0/eta).^2);
  wxe=wxe/sqrt(sum(wxe.^2));
  wxd=bcf*wxe.*sin(pi*tt/t0);

  iix=round(ist:ist+framel-1);
  pw=sqrt(abs(fft((tx(iix)-mean(tx(iix))).*wxe,fftl)).^2+ ...
          abs(fft((tx(iix)-mean(tx(iix))).*wxd,fftl)).^2).^pc;

  nsgram(:,ii)=pw(bbase)';
% mod for ICSLP2002  
%% Warning!! this part introduced additional low frequency noise!!
% It introduced quantization effects
%% (3/Feb./2003) found by Hideki Kawahara
%   Notes for the following 9 lines. Low to middle frequency aperiodic
%   noisy clusters were observed when a very high quality alto recording
%   was resynthesized using STRAIGHTv30kr205. The follwing lines were
%   originally designed to circumvent group delay fluctuations due to
%   unreliable estimate of low frequency power spectrum. (Situation was
%   made worse, because the lack of the DC component introduces an apparent
%   sharp spectral transition which results into very long group delay.
%   This huge group delay acts as an ampifier of group delay induced jitter
%   due to small spectral fluctuations. The basic idea was to add
%   relatively stabel DC component by mirroring the first component to the
%   DC component. Generally it worked reasonable, but due to the sloppy
%   imiplementation, it suffered from quantization in making mirror image.
%   The following codes use a linear interpolation, instead of the sloppy
%   indexing approximation. (3/Feb./2003 by H.K.)
%
%- -------------------------------------
%  f0p2=round((f0/fs*fftl)/2+1); % removed by H.K. on 3/Feb./2003
%  f0p=round((f0/fs*fftl)+1); % removed by H.K. on 3/Feb./2003
  f0p2=floor((f0/fs*fftl)/2+1); % modified by H.K. on 3/Feb./2003
  f0p=ceil((f0/fs*fftl)+1); % modified by H.K. on 3/Feb./2003
  f0pr=f0/fs*fftl+1; % added by H.K. on 3/Feb./2003
  tmppw=interp1(1:f0p,pw(1:f0p),f0pr-((1:f0p2)-1)); % added by H.K. on 3/Feb./2003
  pw(1:f0p2)=tmppw; % modified by H.K. on 3/Feb./2003
  %%pw(1:f0p2)=pw(f0p:-1:f0p-f0p2+1); % removed by H.K. on 3/Feb./2003
  pw(fftl:-1:fftl-f0p2+2)=pw(2:f0p2);

%  local level equalization

  ww2t=(sin(ttm/(t0/3)*pi)./(ttm/(t0/3)*pi)).^2;
  spw2=real(ifft(ww2t.*fft(pw).*lft));
  spw2(spw2==0)=spw2(spw2==0)+eps;  %%% safe guard added on 15/Jan./2003

%	Optimum weighting

  wwt=(sin(ttm/t0*pi)./(ttm/t0*pi)).^2.*(ovc(1)+ovc(2)*2*cos(ttm/t0*2*pi) ...
     +ovc(3)*2*cos(ttm/(t0/2)*2*pi));
  spw=real(ifft(wwt.*fft(pw./spw2)))/wwt(1);

%   smooth half wave rectification

  n2sgram(:,ii) = (spw2(bbase).*(0.25*(log(2*cosh(spw(bbase)*4/1.4))*1.4+spw(bbase)*4)/2))';

%  ii=ii+1;
  ist=ist+shiftl;
%  toc*1000
end;
if imgi==1; close(hpg); end; % added 06/Dec./2002% 10/Aug./2005
f0x(ii:length(f0l))=f0+f0x(ii:length(f0l))*0;
if imgi==1; fprintf('\n'); end;% 10/Aug./2005

nsgram=nsgram.^(1/pc);
n2sgram=n2sgram.^(2/pc);

[snn,smm]=size(n2sgram);
[nii,njj]=size(n2sgram);

lamb=0.25./(f0var+0.25);
lambL=0.25./(f0varL+0.25);

fqx=(0:snn-1)/snn*fs/2;
chigh=1.0./(1+exp(-(fqx-600)/100))';
clow=1.0-chigh;

tx=txs;

%for ii=1:min(length(f0l),njj)
% ----- strat disabling 03/Oct./1999
%for ii=1:njj
%  if rem(ii,10)==0
%    fprintf('*')
%    if rem(ii,200)==0
%       fprintf('\n')
%    end;
%  end;
%%  ist=min((ii-1)*fs*shiftm/1000+1,datalength-framel-1);
%  ist=(ii-1)*fs*shiftm/1000+1;
%  tma=fft((tx(round(ist:ist+framel-1))-mean(tx(round(ist:ist+framel-1)))).*wxec,fftl);
%  tmb=fft((tx(round(ist:ist+framel-1))-mean(tx(round(ist:ist+framel-1)))).*wxdc,fftl);
%  pw=abs(tma).^2+abs(tmb).^2;
%  n2sgram(:,ii)=chigh.*(lamb(ii)*n2sgram(:,ii)+(1-lamb(ii))*pw(bbase)') ...
%               +clow.*(lambL(ii)*n2sgram(:,ii)+(1-lambL(ii))*pw(bbase)');
%%  f0x(ii)=lambL(ii)*f0x(ii)+(1-lambL(ii))*300;
%end;
%------ end of disabling

if smoothinid
  nssgram=n2sgram;

  lowestf0=40;

  tunitw=ceil(1.1*(1000/shiftm)/lowestf0);
  tx=(-tunitw:tunitw)';
  cumfreq=cumsum(f0x)/(1000/shiftm);
  t0x=(1000/shiftm)./f0x;

  bb=(1:length(tx))';
  for jj=1:min(length(f0l),njj)
    txx=cumfreq(min(njj,max(1,jj+tx)))-cumfreq(jj);
    txt=(tx+jj>0).*(tx+jj<=njj);
    idx=(abs(txx)<=1.1).*bb.*txt;
    idx=idx(idx>0);
    txx=txx(idx);
    wt=max(0,1-abs(txx));
    wt=wt.*f0x(min(njj,max(1,jj+tx(idx)+1)));
    wt=wt.*(abs(f0x(jj)-f0x(jj+tx(idx)))/f0x(jj)<0.25);
    n2sgram(:,jj)=nssgram(:,min(njj,max(1,jj+tx(idx))))*wt/sum(wt);
  end;
end;

%-----------------------------------------------------
%	Dirty hack for controling time constant in
%	unvoiced part analysis
%-----------------------------------------------------
if imgi==1; hpg=waitbar(0,'spline-based F0 adaptive smooting'); end;% 10/Aug./2005
ttlv=sum(sum(n2sgram));
ncw=round(2*fs/1000);

lbb=round(300/fs*fftl);  % 22/Sept./1999

%pwc=fftfilt(hanning(ncw*2+1),abs([xh, zeros(1,ncw*10)]).^2);
h3=(conv(hanning(round(fs/1000)),exp(-1400/fs*(0:ncw*2))));  % 30/July/1999
pwc=fftfilt(h3,abs([xh2, zeros(1,ncw*10)]).^2); % 30/July/1999,   % 08/Sept./1999
if imgi==1; waitbar(0.1); end; % 08/Dec./2002% 10/Aug./2005
pwc=pwc(round(1:fs/(1000/shiftm):length(pwc)));
[nn,mm]=size(n2sgram);
pwc=pwc(1:mm);
pwc=pwc/sum(pwc)*sum(sum(n2sgram(lbb:nn,:)));
if imgi==1; waitbar(0.2); end; % 08/Dec./2002% 10/Aug./2005

%pwch=fftfilt(hanning(ncw*2+1),abs([xhh, zeros(1,ncw*10)]).^2);
pwch=fftfilt(h3,abs([xhh, zeros(1,ncw*10)]).^2);% 30/July/1999
if imgi==1; waitbar(0.3); end; % 08/Dec./2002% 10/Aug./2005
pwch=pwch(round(1:fs/(1000/shiftm):length(pwch)));
[nn,mm]=size(n2sgram);
pwch=pwch(1:mm);
pwch=pwch/sum(pwch)*ttlv;

ipwm=7;	% impact detection window size
ipl=round(ipwm/shiftm);
ww=hanning(ipl*2+1);
ww=ww/sum(ww);
apwt=fftfilt(ww,[pwch(:)' zeros(1,length(ww)*2)]);
apwt=apwt((1:length(pwch))+ipl);
dpwt=fftfilt(ww,[diff(pwch(:)').^2 zeros(1,length(ww)*2)]);
dpwt=dpwt((1:length(pwch))+ipl);
mmaa=max(apwt);
apwt(apwt<=0)=apwt(apwt<=0)*0+mmaa;  % bug fix 03/Sept./1999
rr=(sqrt(dpwt)./apwt);
lmbd=(1.0./(1+exp(-(sqrt(rr)-0.75)*20)));

pwc=pwc.*lmbd+(1-lmbd).*sum(n2sgram);  %  time constant controller

%	Shaping amplitude envelope

for ii=1:mm
	if f0raw(ii)==0
		n2sgram(:,ii)=pwc(ii)*n2sgram(:,ii)/sum(n2sgram(:,ii));
	end;
	if imgi==1 & rem(ii,10)==0% 10/Aug./2005
		waitbar(0.4+0.5*ii/mm); % 08/Dec./2002
	end;
end;

n2sgram=abs(n2sgram+0.0000000001);
n2sgram=sqrt(n2sgram);
if imgi==1; waitbar(1); end; % 08/Dec./2002% 10/Aug./2005
if imgi==1; fprintf('\n'); end;
if imgi==1; close(hpg); end;
