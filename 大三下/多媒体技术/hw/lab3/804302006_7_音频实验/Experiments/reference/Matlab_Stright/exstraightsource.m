function [f0raw,ap,analysisParams]=exstraightsource(x,fs,optionalParams)
%   Source information extraction for STRAIGHT
%   [f0raw,ap,analysisParams]=exstraightsource(x,fs,optionalParams)
%   Input parameters
%   x   : input signal. if it is multi channel, only the first channel is used
%   fs  : sampling frequency (Hz)
%   optionalParams : Optional parameters for analysis
%   Output parameters
%   f0raw   : fundamental frequency (Hz)
%   ap  : amount of aperiodic component in the time frequency represntation
%       : represented in dB
%   analysisParams : Analysis parameters actually used
%
%   Usage:
%   Case 1: The simplest method
%   [f0raw,ap]=exstraightsource(x,fs); 
%   Case 2: You can get to know what parameters were used.
%   [f0raw,ap,analysisParams]=exstraightsource(x,fs);
%   CAse 3: You can have full control of STRAIGHT synthesis.
%       Please use case 2 to find desired parameters to modify.
%   [f0raw,ap,analysisParams]=exstraightsource(x,fs,optionalParams);

%   Notes on programing style
%   This routine is based on the current (2005.1.31) implementation of
%   STRAIGHT that consist of many legacy fragments. They were intentionally
%   kept for maintaining historic record. Revised functions written in a
%   reasonable stylistic practice will be made available soon.

%   Designed and coded by Hideki Kawahara
%   15/January/2005
%   01/February/2005 extended for user control
%	30/April/2005 modification for Matlab v7.0 compatibility
		
%---Check for number of input parameters
switch nargin
    case 2
        prm=zinitializeParameters;
    case 3
        prm=replaceSuppliedParameters(optionalParams);
    otherwise
        disp('Number of arguments is 2 or 3!');
        return;
end

%   Initialize default parameters
f0floor = prm.F0searchLowerBound; % f0floor
f0ceil = prm.F0searchUpperBound; % f0ceil
framem = prm.F0defaultWindowLength; % default frame length for pitch extraction (ms)
f0shiftm = prm.F0frameUpdateInterval; % shiftm % F0 calculation interval (ms)

fftl=1024;	% default FFT length

framel=framem*fs/1000;

if fftl < framel
    fftl=2^ceil(log(framel)/log(2));
end;
fftl2=fftl/2;

[nr,nc]=size(x);
if nr>nc
    x=x(:,1);
else
    x=x(1,:)';
end;

nvo = prm.NofChannelsInOctave; % nvo=24; % Number of channels in one octave
mu = prm.IFWindowStretch; % mu=1.2; % window stretch from isometric window
imageOn = prm.DisplayPlots; % imgi=1; % image display indicator (1: display image)
smp = prm.IFsmoothingLengthRelToFc; %  smp=1; % smoothing length relative to fc (ratio)
minsm = prm.IFminimumSmoothingLength; %  minm=5; % minimum smoothing length (ms)
pcf0 = prm.IFexponentForNonlinearSum; % pc=0.5; % exponent to represent nonlinear summation
nh = prm.IFnumberOfHarmonicForInitialEstimate; % nc=1; % number of harmonic component to use (1,2,3)
fname= prm.note; %=' '; % Any text to be printed on the source information plot

nvc=ceil(log(f0ceil/f0floor)/log(2)*nvo); % number of channels

% paramaters for F0 refinement
fftlf0r = prm.refineFftLength; %fftlf0r=1024; % FFT length for F0 refinement
tstretch = prm.refineTimeStretchingFactor; %tstretch=1.1; % time window stretching factor
nhmx = prm.refineNumberofHarmonicComponent; %nhmx=3; % number of harmonic components for F0 refinement
iPeriodicityInterval = prm.periodicityFrameUpdateInterval; % frame update interval for periodicity index (ms)

%---- F0 extraction based on a fixed-point method in the frequency domain

[f0v,vrv,dfv,nf,aav]=fixpF0VexMltpBG4(x,fs,f0floor,nvc,nvo,mu,imageOn,f0shiftm,smp,minsm,pcf0,nh);
if imageOn
    title([fname '  ' datestr(now,0)]);
    drawnow;
end;

%---- post processing for V/UV decision and F0 tracking
[nn,mm]=size(f0v);
[pwt,pwh]=zplotcpower(x,fs,f0shiftm,imageOn);

[f0raw,irms,df,amp]=f0track5(f0v,vrv,dfv,pwt,pwh,aav,f0shiftm,imageOn); % 11/Sept./2005
f0t=f0raw;avf0=mean(f0raw(f0raw>0));
f0t(f0t==0)=f0t(f0t==0)*NaN;tt=1:length(f0t);

if imageOn
    subplot(615);plot(tt*f0shiftm,f0t,'g');grid on;
    if ~isnan(avf0)
        axis([1 max(tt)*f0shiftm ...
                min(avf0/sqrt(2),0.95*min(f0raw(f0raw>0)))  ...
                max(avf0*sqrt(2),1.05*max(f0raw(f0raw>0)))]);
    end;
    ylabel('F0 (Hz)');
    hold on;
end;

%---- F0 refinement 
nstp=1; % start position of F0 refinement (samples)
nedp=length(f0raw); % last position of F0 refinement (samples)
dn=floor(fs/(f0ceil*3*2)); % fix by H.K. at 28/Jan./2003
[f0raw,ecr]=refineF06(decimate(x,dn),fs/dn,f0raw,fftlf0r,tstretch,nhmx,f0shiftm,nstp,nedp,imageOn); % 31/Aug./2004% 11/Sept.2005

if imageOn
    f0t=f0raw;avf0=mean(f0raw(f0raw>0));
    f0t(f0t==0)=f0t(f0t==0)*NaN;tt=1:length(f0t);
    subplot(615);plot(tt*f0shiftm,f0t,'k');hold off;
    drawnow 
end;
%----------- 31/July/1999
ecrt=ecr;
ecrt(f0raw==0)=ecrt(f0raw==0)*NaN;

if imageOn
    tirms=irms;
    tirms(f0raw==0)=tirms(f0raw==0)*NaN;
    tirms(f0raw>0)=-20*log10(tirms(f0raw>0));
    subplot(616);hrms=plot(tt*f0shiftm,tirms,'g',tt*f0shiftm,20*log10(ecrt),'r'); %31/July/1999
    set(hrms,'LineWidth',[2]);hold on
    plot(tt*f0shiftm,-10*log10(vrv),'k.');
    grid on;hold off
    axis([1 max(tt)*f0shiftm -10 60]);
    xlabel('time (ms)');ylabel('C/N (dB)');
    drawnow;
    irmsz=irms*0;
end;

%-------------------------------------------------------------------------------------
f0raw(f0raw<=0)=f0raw(f0raw<=0)*0; % safeguard 31/August/2004
f0raw(f0raw>f0ceil)=f0raw(f0raw>f0ceil)*0+f0ceil; % safeguard 31/August/2004

if nargout == 1; return; end;

%----- aperiodicity estimation
[apvq,dpvq,apve,dpve]=aperiodicpartERB2(x,fs,f0raw,f0shiftm,iPeriodicityInterval,fftl/2+1,imageOn); % 10/April/2002$11/Sept./2005
apv=10*log10(apvq); % for compatibility
dpv=10*log10(dpvq); % for compatibility
%- ---------
%   Notes on aperiodicity estimation: The previous implementation of
%   aperiodicity estimation was sensitive to low frequency noise. It is a
%   bad news, because environmental noise usually has its power in the low
%   frequency region. The following corrction uses the C/N information
%   which is the byproduct of fixed point based F0 estimation.
%   by H.K. 04/Feb./2003
%- ---------
dpv=correctdpv(apv,dpv,iPeriodicityInterval,f0raw,ecrt,f0shiftm,fs); % Aperiodicity correction 04/Feb./2003 by H.K.

if imageOn
    bv=boundmes2(apv,dpv,fs,f0shiftm,iPeriodicityInterval,fftl/2+1);
    figure;
    semilogy((0:length(bv)-1)*f0shiftm,0.5./10.0.^(bv));grid on;
    set(gcf,'PaperPosition', [0.634517 0.634517 19.715 28.4084]);
end;

ap=aperiodiccomp(apv,dpv,iPeriodicityInterval,f0raw,f0shiftm,fftl,imageOn); % 11/Sept./2005

switch nargout
    case 2
    case 3
        analysisParams=prm;
    otherwise
        disp('Number of output parameters has to be 2 or 3!')
end;

return;

%%%---- internal functions
function [pw,pwh]=zplotcpower(x,fs,shiftm,imageOn)

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

if imageOn
    subplot(614);
    tt=1:length(pw);
    hhg=plot(tt*shiftm,10*log10(pw),'b');hold on;
    plot(tt*shiftm,10*log10(pwh),'r');grid on;hold off;
    set(hhg,'LineWidth',[2]);
    mp=max(10*log10(pw));
    axis([0 max(tt)*shiftm mp-70 mp+5]);
    ylabel('level (dB)');
    title('thick line: total power thin line:high fq. power (>3kHz) ');
end;
okid=1;

%%%------
function prm=zinitializeParameters;
prm.F0searchLowerBound=40; % f0floor
prm.F0searchUpperBound=800; % f0ceil
prm.F0defaultWindowLength = 40; % default frame length for pitch extraction (ms)
prm.F0frameUpdateInterval=1; % shiftm % F0 calculation interval (ms)
prm.NofChannelsInOctave=24; % nvo=24; % Number of channels in one octave
prm.IFWindowStretch=1.2; % mu=1.2; % window stretch from isometric window
prm.DisplayPlots=0; % imgi=1; % image display indicator (1: display image)
prm.IFsmoothingLengthRelToFc=1; %  smp=1; % smoothing length relative to fc (ratio)
prm.IFminimumSmoothingLength=5; %  minm=5; % minimum smoothing length (ms)
prm.IFexponentForNonlinearSum=0.5; % pc=0.5; % exponent to represent nonlinear summation
prm.IFnumberOfHarmonicForInitialEstimate=1; % nc=1; % number of harmonic component to use (1,2,3)
prm.refineFftLength=1024; %fftlf0r=1024; % FFT length for F0 refinement
prm.refineTimeStretchingFactor=1.1; %tstretch=1.1; % time window stretching factor
prm.refineNumberofHarmonicComponent=3; %nhmx=3; % number of harmonic components for F0 refinement
prm.periodicityFrameUpdateInterval=5; % frame update interval for periodicity index (ms)return
prm.note=' '; % Any text to be printed on the source information plot

%%%--------
function prm=replaceSuppliedParameters(prmin);
prm=zinitializeParameters;
if isfield(prmin,'F0searchLowerBound')==1;
    prm.F0searchLowerBound=prmin.F0searchLowerBound;end;
if isfield(prmin,'F0searchUpperBound')==1;
    prm.F0searchUpperBound=prmin.F0searchUpperBound;end;
if isfield(prmin,'F0defaultWindowLength')==1;
    prm.F0defaultWindowLength=prmin.F0defaultWindowLength;end;
if isfield(prmin,'F0frameUpdateInterval')==1;
    prm.F0frameUpdateInterval=prmin.F0frameUpdateInterval;end;
if isfield(prmin,'NofChannelsInOctave')==1;
    prm.NofChannelsInOctave=prmin.NofChannelsInOctave;end;
if isfield(prmin,'IFWindowStretch')==1;
    prm.IFWindowStretch=prmin.IFWindowStretch;end;
if isfield(prmin,'DisplayPlots')==1;
    prm.DisplayPlots=prmin.DisplayPlots;end;
if isfield(prmin,'IFsmoothingLengthRelToFc')==1;
    prm.IFsmoothingLengthRelToFc=prmin.IFsmoothingLengthRelToFc;end;
if isfield(prmin,'IFminimumSmoothingLength')==1;
    prm.IFminimumSmoothingLength=prmin.IFminimumSmoothingLength;end;
if isfield(prmin,'IFexponentForNonlinearSum')==1;
    prm.IFexponentForNonlinearSum=prmin.IFexponentForNonlinearSum;end;
if isfield(prmin,'IFnumberOfHarmonicForInitialEstimate')==1;
    prm.IFnumberOfHarmonicForInitialEstimate=prmin.IFnumberOfHarmonicForInitialEstimate;end;
if isfield(prmin,'refineFftLength')==1;
    prm.refineFftLength=prmin.refineFftLength;end;
if isfield(prmin,'refineTimeStretchingFactor')==1;
    prm.refineTimeStretchingFactor=prmin.refineTimeStretchingFactor;end;
if isfield(prmin,'refineNumberofHarmonicComponent')==1;
    prm.refineNumberofHarmonicComponent=prmin.refineNumberofHarmonicComponent;end;
if isfield(prmin,'periodicityFrameUpdateInterval')==1;
    prm.periodicityFrameUpdateInterval=prmin.periodicityFrameUpdateInterval;end;
if isfield(prmin,'note')==1;
    prm.note=prmin.note;end;
return
