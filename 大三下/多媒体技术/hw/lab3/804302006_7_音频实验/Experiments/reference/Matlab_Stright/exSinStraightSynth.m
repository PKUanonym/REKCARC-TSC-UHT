function [sy,prmS] = exSinStraightSynth(f0raw,n3sgram,fs,optionalParamsS)
%   STRAIGHT synthesis based on sinusoidal plus noise model
%   [sy,prmS] = exSinStraightSynth(f0raw,n3sgram,ap,fs,optionalParams)
%   Input 
%       f0raw   : fundamental frequency (Hz)
%       n3sgram : STRAIGHT spectrogram
%       fs      : sampling frequency
%       optionalParamsS  : optional parameters
%           spectralUpdateInterval : frame rate (ms)
%           initialPhase    : initial phase of sinusoids (radian)
%           initialAmplitude    : initial amplitude for defining waveform
%           lowestF0    : lowest F0 of the synthesized speech (Hz)
%           minimumPhase    : minimum phase indicator (defult 0)
%   Output
%       sy  : synthesized speech waveform
%       prmS    : parameters used in synthesis

%   Originally coded when visiting CNBH on 2003
%   Revised by Hideki Kawahara
%   11/December/2005 by Hideki Kawahara

sy = [];
switch nargin
    case 3
        prmS = zinitializeParameters(fs);
    case 4
        prmS = replaceSuppliedParameters(fs,optionalParamsS);
    otherwise
        help exSinStraightSynth
        fs = 44100;
        prmS = zinitializeParameters(fs);
        return;
end;
shiftm = prmS.spectralUpdateInterval;
initialPhase = prmS.initialPhase;
initialAmplitude = prmS.initialAmplitude;
lowestF0 = prmS.lowestF0; % compatible default is 50 Hz
minimumPhase = prmS.minimumPhase;

cdm = unwrap(zspectrum2minimumphase(n3sgram,fs));
[amx,fmx,cmx]= sinucompgd(f0raw,fs,n3sgram,cdm,shiftm);
amx(isnan(amx))=0;
cmx(isnan(cmx))=0;
deltaPhase = 2*pi*fmx/fs;
phaseDeviation = cmx*minimumPhase;
[nTime,nFrequency] = size(deltaPhase);
lPhaseVector = length(initialPhase);
deltaPhase(1,:) = initialPhase(min(lPhaseVector,1:nFrequency))+deltaPhase(1,:);
amx = amx*diag(initialAmplitude(min(lPhaseVector,1:nFrequency)));
sy=sum(real(amx.*exp(i*(cumsum(deltaPhase)+phaseDeviation)))');
return;

%%%---- internal functions
function prmS = zinitializeParameters(fs);
prmS.spectralUpdateInterval = 1; %shiftm=1;       % default frame shift (ms) for spectrogram
prmS.lowestF0 = 50; % compatible default is 50 Hz
prmS.initialPhase = zeros(1,ceil(fs/prmS.lowestF0/2));
prmS.initialAmplitude = ones(1,ceil(fs/prmS.lowestF0/2));
prmS.minimumPhase = 0;  % default is zero phase
prmS.samplingFrequency = fs;
return;

%%%----
function prmS = replaceSuppliedParameters(fs,prmin);
prmS = zinitializeParameters(fs);
if isfield(prmin,'spectralUpdateInterval')==1;
    prmS.spectralUpdateInterval=prmin.spectralUpdateInterval;end;
if isfield(prmin,'lowestF0')==1;
    prmS.lowestF0=prmin.lowestF0;end;
if isfield(prmin,'initialPhase')==1;
    prmS.initialPhase=prmin.initialPhase;end;
if isfield(prmin,'initialAmplitude')==1;
    prmS.initialAmplitude=prmin.initialAmplitude;end;
if isfield(prmin,'minimumPhase')==1;
    prmS.minimumPhase=prmin.minimumPhase;end;
return;

%%%----
function [amx,fmx,cmx]= sinucompgd(f0raw,fs,n3sgram,cdm,shiftm)

%   [amx,fmx]=sinucomp(f0raw,fs,n3sgram,shiftm)
%   program to generate matrix for sinusoidal synthesis
%

%   Designed and Coded by Hideki Kawahara
%   07/Sept./2003

t=0:1/fs:(length(f0raw)-1)/1000/shiftm;
f0i=interp1((0:length(f0raw)-1)/1000/shiftm,f0raw,t)';
f0l=min(f0raw(f0raw>0));
ng=n3sgram';
ng(:,1) = ng(:,1)*0;
[nn,mm]=size(ng);

%  ---- instantaneous frequency matrix ---
nh=ceil(fs/2/f0l);
nt=length(f0i);
fmx=zeros(nt,nh);
tmx=fmx;
for ii=0:nh-1
    fmx(:,ii+1)=ii*f0i;
    tmx(:,ii+1)=t';
end;

% ---- instantaneous amplitude matrix ---
amx=zeros(nt,nh);
[ff,tt]=meshgrid((0:(mm-1))*fs/((mm-1)*2),(0:(length(f0raw)-1))/1000/shiftm);
amx=interp2(ff,tt,ng,fmx,tmx,'*linear');
cmx=interp2(ff,ff,cdm',fmx,fmx,'*linear');
return;

%%%--- 
function cph=zspectrum2minimumphase(n3sgram,fs)
%   cph=spectrum2minimumphase(n3sgram,fs)
%   function to calculate minimum phase map from 
%   smoothed time frequency representation

%   Designed and coded by Hideki Kawahara
%   7/Sept./2003
%   11/Dec./2005 revised

[nRow,nColumn]=size(n3sgram);
fftl=(nRow-1)*2;

reversedIndex=fftl/2:-1:2;
cph=zeros(nRow,nColumn);
for ii=1:nColumn
    dftSegment=[n3sgram(:,ii);n3sgram(reversedIndex,ii)];
    complexCepstrum=real(fft(log(dftSegment))); 
    causalCepstrum=[complexCepstrum(1);2*complexCepstrum(2:fftl/2);0*complexCepstrum(fftl/2+1:fftl)];
    causalLogSpectrum=ifft(causalCepstrum);
    cph(:,ii)=-imag(causalLogSpectrum(1:fftl/2+1));
end;
