function [sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs,optionalParamsS)
%   Synthesis using STRAIGHT parameters with linear modifications
%   [sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs,optionalParamsS)
%   Input parameters
%   f0raw   : fundamental frequency (Hz) 
%   n3sgram : STRAIGHT spectrogram (in absolute value)
%   ap      : aperiodic component (dB re. to total power)
%   fs      : sampling frequency (Hz)
%   optionalParamsS : optional synthesis parameters
%   Output parameters
%   sy      : synthesized speech
%   prmS    : Actually used synthesis parameters
%
%   Usage:
%   Case 1: The simplest method
%   sy = exstraightsynth(f0raw,n3sgram,ap,fs); 
%   Case 2: You can get to know what parameters were used.
%   [sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs);
%   CAse 3: You can have full control of STRAIGHT synthesis.
%       Please use case 2 to find desired parameters to modify.
%   [sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs,optionalParamsS);

%   Designed and coded by Hideki Kawahara
%   15/January/2005
%   01/February/2005 revised for generalization
%   14/February/2005 fixed typo
%	30/April/2005 modification for Matlab v7.0 compatibility
%   11/Sept./2005 display indicator field is defined.
%   27/Nov./2005 enabled setting lower limit of F0
		
%---- Check input parameters
switch nargin
    case 4
        prmS=zinitializeParameters;
    case 5
        prmS=replaceSuppliedParameters(optionalParamsS);
    otherwise
        disp('Number of arguments is not relevant. Type help exstraightsynth.');
        return
end;

%--- Initialize parameters
shiftm = prmS.spectralUpdateInterval; %shiftm=1;       % default frame shift (ms) for spectrogram
delsp = prmS.groupDelayStandardDeviation; %delsp=0.5; 	%  standard deviation of random group delay in ms
gdbw = prmS.groupDelaySpatialBandWidth; %gdbw=70; 	% smoothing window length of random group delay (in Hz)
cornf = prmS.groupDelayRandomizeCornerFrequency; %cornf=4000;  	% corner frequency for random phase (Hz)
delfrac = prmS.ratioToFundamentalPeriod; %delfrac=0.2;  % Fractional group delay (ratio) 
delfracind = prmS.ratioModeIndicator; %delfracind=0; % Use fractional group dealy, if this is set 1.
normalizedOut = prmS.levelNormalizationIndicator; %normalizedOut = 1; % Normalize voiced part level, when this is set 1.
headRoom = prmS.headRoomToClip; %headRoom = 22; % Head room from voiced part rms to the clipping level. (dB)
lsegment = prmS.powerCheckSegmentLength; %lsegment = 15; % Segment length for voiced power check (ms)
imap = prmS.timeAxisMappingTable; % imap = 1 represents identity mapping.
pconv = prmS.fundamentalFrequencyMappingTable; %pconv = 1 represents identity mapping.
fconv = prmS.frequencyAxisMappingTable; %fconv = 1 represents identity mapping.
sconv = prmS.timeAxisStretchingFactor; %sconv = 1; % This is a simple coefficient.
imgi = prmS.DisplayPlots; % default 0, 1: display on
lowestF0 = prmS.lowestF0; % compatible default is 50 Hz

[sy,statusReport] =straightSynthTB07ca(n3sgram,f0raw,shiftm,fs, ...
    pconv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind,ap,imap,imgi,lowestF0); % revised 27/Nov./2005
if normalizedOut
    dBsy=zpowerchk(sy,fs,lsegment); % 23/Sept./1999
    cf=(20*log10(32768)-headRoom)-dBsy;
    sy=sy*(10.0.^(cf/20));
end;
prmS.statusReport = statusReport;

%%%----- Internal functions
function pow=zpowerchk(x,fs,segms);
%	Calculate average power of voiced portion
%	pow=powerchk(x,fs,segms)
%		x	: signal
%		fs	: sampling frequency (Hz)
%		segms	: segment length (ms)

%	23/Sept./1999 updated

x1=x(:);
iv=(1:length(x1))';
x1(isnan(x1))=iv(isnan(x1))*0+0.0000000001;
x2=x1.*x1;
%n=100; % 23/Sept./1999
n=round(segms/1000*fs); % 23/Sept./1999
nw=ceil(length(x)/n);
if rem(length(x),n)>0
%  x2=[x2;zeros(n*nw-length(x),1)];
  x2=[x2;0.000001*randn(n*nw-length(x),1).^2]; % 23/Sept./1999
end;
x2(x2==0)=x2(x2==0)+0.000001;

pw=sum(reshape(x2,n,nw))/n;

pow=10*log10(mean(pw(pw>(mean(pw)/30))));
%keyboard
%%%---- Initialize parameters
function prm=zinitializeParameters
prm.spectralUpdateInterval = 1; %shiftm=1;       % default frame shift (ms) for spectrogram
prm.groupDelayStandardDeviation = 0.5; %delsp=0.5; 	%  standard deviation of random group delay in ms
prm.groupDelaySpatialBandWidth = 70; %gdbw=70; 	% smoothing window length of random group delay (in Hz)
prm.groupDelayRandomizeCornerFrequency = 4000; %cornf=4000;  	% corner frequency for random phase (Hz)
prm.ratioToFundamentalPeriod = 0.2; %delfrac=0.2;  % Fractional group delay (ratio) 
prm.ratioModeIndicator = 0; %delfracind=0; % Use fractional group dealy, if this is set 1.
prm.levelNormalizationIndicator = 1; %normalizedOut = 1; % Normalize voiced part level, when this is set 1.
prm.headRoomToClip = 22; %headRoom = 22; % Head room from voiced part rms to the clipping level. (dB)
prm.powerCheckSegmentLength = 15; %lsegment = 15; % Segment length for voiced power check (ms)
prm.timeAxisMappingTable = 1; % imap = 1 represents identity mapping.
prm.fundamentalFrequencyMappingTable = 1; %pconv = 1 represents identity mapping.
prm.frequencyAxisMappingTable = 1; %fconv = 1 represents identity mapping.
prm.timeAxisStretchingFactor = 1; %sconv = 1; % This is a simple coefficient.
prm.DisplayPlots = 0; % default 0, 1:disply on
prm.lowestF0 = 50; % default that was not as same as the previous version but consistent
return

%%%----
function prm=replaceSuppliedParameters(prmin);
prm=zinitializeParameters;
if isfield(prmin,'spectralUpdateInterval')==1;
    prm.spectralUpdateInterval=prmin.spectralUpdateInterval;end;
if isfield(prmin,'groupDelayStandardDeviation')==1;
    prm.groupDelayStandardDeviation=prmin.groupDelayStandardDeviation;end;
if isfield(prmin,'groupDelaySpatialBandWidth')==1;
    prm.groupDelaySpatialBandWidth=prmin.groupDelaySpatialBandWidth;end;
if isfield(prmin,'groupDelayRandomizeCornerFrequency')==1;
    prm.groupDelayRandomizeCornerFrequency=prmin.groupDelayRandomizeCornerFrequency;end;
if isfield(prmin,'ratioToFundamentalPeriod')==1;
    prm.ratioToFundamentalPeriod=prmin.ratioToFundamentalPeriod;end;
if isfield(prmin,'ratioModeIndicator')==1;
    prm.ratioModeIndicator=prmin.ratioModeIndicator;end;
if isfield(prmin,'levelNormalizationIndicator')==1;
    prm.levelNormalizationIndicator=prmin.levelNormalizationIndicator;end;
if isfield(prmin,'headRoomToClip')==1;
    prm.headRoomToClip=prmin.headRoomToClip;end;
if isfield(prmin,'powerCheckSegmentLength')==1;
    prm.powerCheckSegmentLength=prmin.powerCheckSegmentLength;end;
if isfield(prmin,'timeAxisMappingTable')==1;
    prm.timeAxisMappingTable=prmin.timeAxisMappingTable;end;
if isfield(prmin,'fundamentalFrequencyMappingTable')==1;
    prm.fundamentalFrequencyMappingTable=prmin.fundamentalFrequencyMappingTable;end;
if isfield(prmin,'frequencyAxisMappingTable')==1;
    prm.frequencyAxisMappingTable=prmin.frequencyAxisMappingTable;end;
if isfield(prmin,'timeAxisStretchingFactor')==1;
    prm.timeAxisStretchingFactor=prmin.timeAxisStretchingFactor;end;
if isfield(prmin,'DisplayPlots')==1;
    prm.DisplayPlots=prmin.DisplayPlots;end;
if isfield(prmin,'lowestF0')==1;
    prm.lowestF0=prmin.lowestF0;end;
return;
