function [n3sgram,analysisParamsSp]=exstraightspec(x,f0raw,fs,optionalParamsSP)
%   Spectral information extraction for STRAIGHT
%   [n3sgram,nalysisParamsSp]=exstraightspec(x,f0raw,fs,optionalParamsSP)
%   Input parameters
%   x   : input signal. only the first channel is analyzed
%   f0raw   : fundamental frequency (Hz) in 1 ms temporal resolution
%           : set 0 for aperiodic part
%   fs  : sampling freuency (Hz)
%   optionalParamsSP : spectrum analysis parameters
%   Output parameters
%   n3sgram : Smoothed time frequency representation (spectrogram)
%   analysisParamsSp :  Actually used parameters
%
%   Usage:
%   Case 1: The simplest method
%   n3sgram = exstraightspec(x,f0raw,fs); 
%   Case 2: You can get to know what parameters were used.
%   [n3sgram,analysisParamsSp]=exstraightspec(x,f0raw,fs);
%   CAse 3: You can have full control of STRAIGHT synthesis.
%       Please use case 2 to find desired parameters to modify.
%   [n3sgram,analysisParamsSp]=exstraightspec(x,f0raw,fs,optionalParamsSP);


%   Designed and coded by Hideki Kawahara
%   15/January/2005
%   01/February/2005
%   11/Sept./2005 waitbar control is fixed.

%---Check for number of input parameters
switch nargin
    case 3
        prm=zinitializeParameters;
    case 4
        prm=replaceSuppliedParameters(optionalParamsSP);
    otherwise
        disp('Number of arguments is 2 or 3!');
        return;
end

%   Initialize parameters
imageOn = prm.DisplayPlots; %imageOn=0; % Display indicator. 0: No graphics, 1: Show graphics
framem = prm.defaultFrameLength; %framem=40;	% default frame length for pitch extraction (ms)
shiftm = prm.spectralUpdateInterval; %shiftm=1;       % default frame shift (ms) for spectrogram
eta = prm.spectralTimeWindowStretch; %eta=1.4;        % time window stretch factor
pc = prm.spectralExponentForNonlinearity; %pc=0.6;         % exponent for nonlinearity
mag = prm.spectralTimeDomainCompensation; %mag=0.2;      % This parameter should be revised.
framel=framem*fs/1000;
fftl=1024;	% default FFT length

if fftl < framel
    fftl=2^ceil(log(framel)/log(2));
end;
fftl2=fftl/2;

[nr,nc]=size(x);
if nr>nc
    xold=x(:,1);
else
    xold=x(1,:)';
end;

%---- Spectral estimation

xamp=std(xold);
scaleconst=2200; % magic number for compatibility 15/Jan./2005
xold=xold/xamp*scaleconst;
f0var=1; f0varL=1; % These are obsolate dummy variables. meaningless
[n2sgrambk,nsgram]=straightBodyC03ma(xold,fs,shiftm,fftl,f0raw,f0var,f0varL,eta,pc,imageOn); % 11/Sept./2005
if mag>0
    n3sgram=specreshape(fs,n2sgrambk,eta,pc,mag,f0raw,imageOn); % 11/Sept./2005
else
    n3sgram=n2sgrambk;
end;
n3sgram=n3sgram/scaleconst*xamp;
analysisParamsSp = prm;
return;

%%%--- Internal functions
function prm=zinitializeParameters
prm.DisplayPlots = 0; %imageOn=0; % Display indicator. 0: No graphics, 1: Show graphics
prm.defaultFrameLength = 40; %framem=40;	% default frame length for pitch extraction (ms)
prm.spectralUpdateInterval = 1; %shiftm=1;       % default frame shift (ms) for spectrogram
prm.spectralTimeWindowStretch = 1.4; %eta=1.4;        % time window stretch factor
prm.spectralExponentForNonlinearity = 0.6; %pc=0.6;         % exponent for nonlinearity
prm.spectralTimeDomainCompensation = 0.2; %mag=0.2;      % This parameter should be revised.

%%%----
function prm=replaceSuppliedParameters(prmin);
prm=zinitializeParameters;
if isfield(prmin,'DisplayPlots')==1;
    prm.DisplayPlots=prmin.DisplayPlots;end;
if isfield(prmin,'defaultFrameLength')==1;
    prm.defaultFrameLength=prmin.defaultFrameLength;end;
if isfield(prmin,'spectralUpdateInterval')==1;
    prm.spectralUpdateInterval=prmin.spectralUpdateInterval;end;
if isfield(prmin,'spectralTimeWindowStretch')==1;
    prm.spectralTimeWindowStretch=prmin.spectralTimeWindowStretch;end;
if isfield(prmin,'spectralExponentForNonlinearity')==1;
    prm.spectralExponentForNonlinearity=prmin.spectralExponentForNonlinearity;end;
if isfield(prmin,'spectralTimeDomainCompensation')==1;
    prm.spectralTimeDomainCompensation=prmin.spectralTimeDomainCompensation;end;
return;