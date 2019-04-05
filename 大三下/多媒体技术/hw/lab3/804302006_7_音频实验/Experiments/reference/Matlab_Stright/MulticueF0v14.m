function [f0raw,vuv,auxouts,prm]=MulticueF0v14(x,fs,f0floor,f0ceil)
%   Source information extraction using multiple cues
%   Default values are used when other arguments are missing.
%   You can modify specific parameters by assigning them.
%   The control parameters open to user in this version are
%   F0 search range.
%   Examples:
%   f0=MulticueF0v14(x,fs);
%       x: input signal (monaural signal)
%       fs: sampling frequency (Hz)
%       f0: fundamental frequency (Hz)
%           f0 is set to zero when unvoiced.
%   f0=MulticueF0v14(x,fs,f0floor,f0ceil)
%       f0floor: Lower limit of F0 search (Hz)
%       f0ceil: Upper limit of F0 search (Hz)
%   [f0raw,vuv,auxouts]=MulticueF0v14(x,fs,f0floor,f0ceil)
%       f0raw: fundamental frequency without V/UV information
%       vuv: V/UV indicator, 1:voiced, 0: unvoiced
%       auxouts: base information for f0 extraction (structure variable)
%
%   [f0raw,vuv,auxouts,prmouts]=MulticueF0v14(x,fs,prmin)
%       prmin: structure variable for control parameters
%       f0raw: fundamental frequency without V/UV information
%       vuv: V/UV indicator, 1:voiced, 0: unvoiced
%       auxouts: base information for f0 extraction (structure variable)
%       prmouts: structure variable showing used control parameters
%
%   Copyright(c) Wakayama University, 2004
%   This version is very experimental. No warranty.
%   Please contact: kawahara@sys.wakayama-u.ac.jp

%   Designed and coded by Hideki Kawahara
%   31/August/2004 first conceiled version
%   27/September/2004 revised version v10
%   14/November/2004 revised version v11
%   12/January/2005 revised version v12
%   13/January/2005 graphics disabled version
%   10/May/2005 added control input


switch nargin
    case {2,4}
    case 3
        if ~isstruct(f0floor)
            ok=displayusage;
            f0raw=[];vuv=[];
            return;
        else
            prmin = f0floor;
        end;
    otherwise
        ok=displayusage;
        f0raw=[];vuv=[];
        return;
end
switch nargin
    case 3
    case 4
        prmin.F0searchLowerBound=f0floor;
        prmin.F0searchUpperBound=f0ceil;
        prmin.DisplayPlots=0;
    otherwise
        prmin.DisplayPlots=0;
end;
[f0raw,vuv,auxouts,prm]=SourceInfobyMultiCues050111(x,fs,prmin);
nn=min(length(vuv),length(f0raw));
f0raw=f0raw(1:nn)';
vuv=vuv(1:nn)';
switch nargout
    case 1
        f0raw=f0raw.*vuv;
    case {3,4}
    otherwise
        ok=displayusage;
        return;
end
return;

function ok=displayusage;
fprintf('   Source information extraction using multiple cues\n');
fprintf('   Default values are used when other arguments are missing.\n');
fprintf('   You can modify specific parameters by assigning them.\n');
fprintf('   The control parameters open to user in this version are\n');
fprintf('   F0 search range.\n');
fprintf('   Example:1\n');
fprintf('   f0=MulticueF0v14(x,fs);\n');
fprintf('       x: input signal (monaural signal)\n');
fprintf('       fs: sampling frequency (Hz)\n');
fprintf('       f0: fundamental frequency (Hz)\n');
fprintf('           f0 is set to zero when unvoiced.\n');
fprintf('   f0=MulticueF0v14(x,fs,f0floor,f0ceil)\n');
fprintf('       f0floor: Lower limit of F0 search (Hz)\n');
fprintf('       f0ceil: Upper limit of F0 search (Hz)\n');
fprintf('   [f0raw,vuv,auxouts]=MulticueF0v14(x,fs,f0floor,f0ceil)\n');
fprintf('       f0raw: fundamental frequency without V/UV information\n');
fprintf('       vuv: V/UV indicator, 1:voiced, 0: unvoiced\n');
fprintf('       auxouts: base information for f0 extraction (structure variable)\n');
fprintf('   [f0raw,vuv,auxouts,prmouts]=MulticueF0v14(x,fs,prmin)\n');
fprintf('       prmin: structure variable for control parameters\n');
fprintf('       f0raw: fundamental frequency without V/UV information\n');
fprintf('       vuv: V/UV indicator, 1:voiced, 0: unvoiced\n');
fprintf('       auxouts: base information for f0 extraction (structure variable)\n');
fprintf('       prmouts: structure variable showing used control parameters\n');
fprintf('\n');
fprintf('   Copyright(c) Wakayama University, 2004,2005\n');
fprintf('   This version is very experimental. No warranty.\n');
fprintf('   Please contact: kawahara@sys.wakayama-u.ac.jp\n');
ok=1;

function [f0raw,vuv,auxouts,prm]=SourceInfobyMultiCues050111(x,fs,prmin)
% Source information extraction function
%   with combined source information
%   minimum requisite is to provide x and fs and receive f0.
%   Default values are used when other arguments are missing.
%   You can modify specific parameters by assigning using prmin.
%   Example:1
%   SourceInfobyMultiCues050111(x,fs);
%       Simplest usage
%   Example:2
%   f0raw=SourceInfobyMultiCues050111(x,fs); 
%       F0 for voiced segment is what you get.
%   Example:3
%   [f0raw,vuv,auxouts,prm]=SourceInfobyMultiCues050111(x,fs);
%       You can check what defaults were and raw information.
%   Example:4
%   [f0raw,vuv,auxouts,prm]=SourceInfobyMultiCues050111(x,fs,prmin);
%       You have full control (and responsibility).

% Designed and coded by Hideki Kawahara
%   24/June/2004
%   26/June/2004
%   30/June/2004
%   01/July/2004
%   04/July/2004 New mixing method without mixed map
%   05/July/2004 Revised tracking measure
%   06/July/2004 Revised tracking lgorithm further and bug fix
%   07/July/2004 Revised tracking, funcamental bug fix
%   10/July/2004 Revised proprocessing for fs independence
%   15/July/2004 Bug fix for batch job
%   16/July/2004 Revised for better initial position
%   17/July/2004 Updated default values to improve robustness
%   18/July/2004 Bug fix in tracking (boundary value)
%   19/July/2004 Bug fix in tracking revised default parameters
%   21/July/2004 Bug fix in tracking revised default parameters
%   23/July/2004 New deconvolution of autocorrelation
%   25/July/2004 Bug fix in tracking
%   25/July/2004 Revised map merge procedure
%   27/July/2004 Straightforward tracking routine
%   29/July/2004 Combined tracking and fine tuning parameters
%   02/Aug./2004 New tracking algorithm
%   07/Aug./2004 Yet other tracking (segment selection) algorithm
%   14/Aug./2004 Added missing segment recovary
%   15/Aug./2004 New V/UV decision logic was integrated
%   31/Aug./2004 minor bug fix
%   25/Aug./2004 bug fix and revised when no output is assigned
%   11/Jan./2005 minor bug fix for boundary logic
%   12/Jan./2005 bug fix for all zero segment

% Assuming x consists of data
% Assuming fs consists of sampling frequency (Hz)

%------ check input arguments
prm=zsetdefaultparams;

switch nargin
    case {2,3}
    otherwise
        help SourceInfobyMultiCues040701
        f0raw=[];vuv=[];
        return;
end
[nn,mm]=size(x);
if min(nn,mm)>1
    display('Using only the first channel.');
    if nn<mm
        x=x(1,:);
    else
        x=x(:,1);
    end;
end;
x=x(:); % make sure x is a column vector.

%--- safe guard for all zero segments 12/Jan./2005

l1ms=round(fs/1000);
if length(x==0)>l1ms
    zv=randn(size(x(x==0)));
    zv=cumsum(zv-mean(zv));
    zv=zv/std(zv)*std(x)/10000;
    x(x==0)=zv;
end;

%------ set initial parameters

if nargin==3
    if isfield(prmin,'F0searchLowerBound')==1;
        prm.F0searchLowerBound=prmin.F0searchLowerBound;end;
    if isfield(prmin,'F0searchUpperBound')==1;
        prm.F0searchUpperBound=prmin.F0searchUpperBound;end;
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
    if isfield(prmin,'TimeConstantForPowerCalculation')==1;
        prm.TimeConstantForPowerCalculation=prmin.TimeConstantForPowerCalculation;end;
    if isfield(prmin,'ACtimeWindowLength')==1;
        prm.ACtimeWindowLength=prmin.ACtimeWindowLength;end;
    if isfield(prmin,'ACnumberOfFrequencySegments')==1;
        prm.ACnumberOfFrequencySegments=prmin.ACnumberOfFrequencySegments;end;
    if isfield(prmin,'ACfrequencyDomainWindowWidth')==1;
        prm.ACfrequencyDomainWindowWidth=prmin.ACfrequencyDomainWindowWidth;end;
    if isfield(prmin,'ACpowerExponentForNonlinearity')==1;
        prm.ACpowerExponentForNonlinearity=prmin.ACpowerExponentForNonlinearity;end;
    if isfield(prmin,'ACamplitudeCompensationInShortLag')==1;
        prm.ACamplitudeCompensationInShortLag=prmin.ACamplitudeCompensationInShortLag;end;
    if isfield(prmin,'ACexponentForACdistance')==1;
        prm.ACexponentForACdistance=prmin.ACexponentForACdistance;end;
    if isfield(prmin,'AClagSmoothingLength')==1;
        prm.AClagSmoothingLength=prmin.AClagSmoothingLength;end;
    if isfield(prmin,'ACtemporalSmoothingLength')==1;
        prm.ACtemporalSmoothingLength=prmin.ACtemporalSmoothingLength;end;
    if isfield(prmin,'ThresholdForSilence')==1;
        prm.ThresholdForSilence=prmin.ThresholdForSilence;end;
    if isfield(prmin,'ThresholdForVUV')==1;
        prm.ThresholdForVUV=prmin.ThresholdForVUV;end;
    if isfield(prmin,'WeightForAutocorrelationMap')==1;
        prm.WeightForAutocorrelationMap=prmin.WeightForAutocorrelationMap;end;
    if isfield(prmin,'WeightForInstantaneousFqMap')==1;
        prm.WeightForInstantaneousFqMap=prmin.WeightForInstantaneousFqMap;end;
    if isfield(prmin,'VUVthresholdOfAC1')==1;
        prm.VUVthresholdOfAC1=prmin.VUVthresholdOfAC1;end;
    if isfield(prmin,'SDforNormalizeMixingDistance')==1;
        prm.SDforNormalizeMixingDistance=prmin.SDforNormalizeMixingDistance;end;
    if isfield(prmin,'SDforTrackingNormalization')==1;
        prm.SDforTrackingNormalization=prmin.SDforTrackingNormalization;end;
    if isfield(prmin,'MaxumumPermissibleOctaveJump')==1;
        prm.MaxumumPermissibleOctaveJump=prmin.MaxumumPermissibleOctaveJump;end;
    if isfield(prmin,'ThresholdToStartSearch')==1;
        prm.ThresholdToStartSearch=prmin.ThresholdToStartSearch;end;
    if isfield(prmin,'ThresholdToQuitSearch')==1;
        prm.ThresholdToQuitSearch=prmin.ThresholdToQuitSearch;end;
    if isfield(prmin,'ThresholdForReliableRegion')==1;
        prm.ThresholdForReliableRegion=prmin.ThresholdForReliableRegion;end;
end;
    
%----- copy modified analysis conditions to internal variables
f0floor=prm.F0searchLowerBound; % f0floor
f0ceil=prm.F0searchUpperBound; % f0ceil
shiftm=prm.F0frameUpdateInterval; %  % F0 calculation interval (ms)
nvo=prm.NofChannelsInOctave; % nvo=24; % Number of channels in one octave
mu=prm.IFWindowStretch; % mu=1.2; % window stretch from isometric window
imgi=prm.DisplayPlots; % imgi=1; % image display indicator (1: display image)
smp=prm.IFsmoothingLengthRelToFc; %  smp=1; % smoothing length relative to fc (ratio)
minm=prm.IFminimumSmoothingLength; %  minm=5; % minimum smoothing length (ms)
pcIF=prm.IFexponentForNonlinearSum; % pc=0.5; % exponent to represent nonlinear summation
ncIF=prm.IFnumberOfHarmonicForInitialEstimate; % nc=1; % number of harmonic component to use (1,2,3)
tcpower=prm.TimeConstantForPowerCalculation;  % tcpower=10; % time constant for power calculation (ms)
wtlm=prm.ACtimeWindowLength; % Time window length for Autocorrelation based method (ms)
ndiv=prm.ACnumberOfFrequencySegments; % for Autocorrelation method
wflf=prm.ACfrequencyDomainWindowWidth; % for Autocorrelation method (Hz)
pcAC=prm.ACpowerExponentForNonlinearity; % for Autocorrelation method
ampAC=prm.ACamplitudeCompensationInShortLag; % for Autocorrelation method (ratio)
betaAC=prm.ACexponentForACdistance; % Nonlinear distance measure for post processing
lagslAC=prm.AClagSmoothingLength; % Lag smoothing length for post processing (s) !!
timeslAC=prm.ACtemporalSmoothingLength; % Temporal smoothing length for post processing (ms)
thsilence=prm.ThresholdForSilence; % for silence decision above average noise level (dB)
thvuv=prm.ThresholdForVUV; % for V/UV decision based on first autocorrelation and C/N
wAC=prm.WeightForAutocorrelationMap; % weight for combining maps (Autocorrelation)
wIF=prm.WeightForInstantaneousFqMap; % weight for combining maps (Instantaneous Frequency)
ac1th=prm.VUVthresholdOfAC1;
mixsd=prm.SDforNormalizeMixingDistance; % Normalization factor for mixing F0 distance (octave)
nsd=prm.SDforTrackingNormalization;
f0jump=prm.MaxumumPermissibleOctaveJump;
strel=prm.ThresholdToStartSearch;
endrel=prm.ThresholdToQuitSearch;
endrel2=prm.ThresholdForReliableRegion;

nvc=ceil(log(f0ceil/f0floor)/log(2)*nvo); ...
    % Number of channels in whole search range

%------- extract fixed points of frequency to instantaneous frequency map
[f0v,vrv,dfv,nf,aav]= ...
    zfixpF0VexMltpBG4(x,fs,f0floor,nvc,nvo,mu,imgi,shiftm,smp,minm,pcIF,ncIF);
[val,pos]=zmultiCandIF(f0v,vrv);
[y,ind,fq]=zremoveACinduction(x,fs,pos);
%------- Pre processing of AC induction if necessary
if ind==1
    xbak=x;x=y;
    [f0v,vrv,dfv,nf,aav]= ...
        zfixpF0VexMltpBG4(x,fs,f0floor,nvc,nvo,mu,imgi,shiftm,smp,minm,pcIF,ncIF);
end;

%---- selecting multiple F0 candidates based on IF
[val,pos]=zmultiCandIF(f0v,vrv);
if imgi==1
    hh=figure;semilogy(pos,'+');grid on;hold on;
    set(gca,'fontsize',16);
    axis([0 length(x)/fs*1000 f0floor f0ceil]);
end;
%---- selecting multiple F0 candidates based on modified Autocorrelation
dn=max(1,floor(fs/max(8000,3*2*f0ceil)));
if imgi==1;
    h1=figure;
else
    h1=-1;
end;
[lagspec,lx]= ...
    zlagspectestnormal(decimate(x,dn),fs/dn,shiftm,length(x)/fs*1000,shiftm,wtlm,ndiv,wflf,pcAC,ampAC,h1);
[f02,pl2]=zmultiCandAC(lx,lagspec,betaAC,lagslAC,timeslAC);
if imgi==1
    figure(hh);semilogy(f02,'o');hold off
    xlabel('time (ms)');ylabel('frequency (Hz)');
    title('F0 candidates: o:autocorrelation  +:instantaneous frequency')
end;

%----- Combine multiple source information with dynamic range normalization
%[f0mapIF,f0mapAC,fx]=zCombineSourceInfoNorm(val,pos,f02,pl2,f0floor,f0ceil,nvo);
%----- selecting multiple F0 candidates based on multiple source
%[f0cand,relv]=zmultiCandf0map(fx,wIF*f0mapIF+wAC*f0mapAC);
auxouts.F0candidatesByIF=pos;
auxouts.CNofcandidatesByIF=val;
auxouts.F0candidatesByAC=f02;
auxouts.ACofcandidatesByAC=pl2;
[f0cand,relv]=zcombineRanking4(auxouts,mixsd,wAC,wIF,prm); % New mixing routine
%f0cand=f0cand(:,1:3);
%relv=relv(:,1:3);
if imgi==1
    figure
    semilogy(f0cand,'+');grid on;
    set(gca,'fontsize',16);
    axis([0 length(f0cand) f0floor f0ceil]);
    title('F0 candidates by mixed source information');
    xlabel('time (ms)')
    ylabel('frequency (Hz)')
end;
%keyboard
%----- Calculate power envelope
pws=zVpowercalc(x,fs,tcpower,shiftm,2000);
pwsdb=10*log10(abs(pws)+0.00000000001);
mxpwsdb=max(pwsdb);
[hstgrm,binlvl]=hist(pwsdb,mxpwsdb+(-60:2));
q10=interp1(cumsum(hstgrm+0.000000001)/sum(hstgrm)*100,binlvl,10); % 10% quantile level
[dmy1,minid]=min(abs(q10-binlvl));
bb=max(1,min(length(binlvl),minid+(-5:5))); % search range 10 dB % safeguard
noiselevel=sum(hstgrm(bb).*binlvl(bb))/sum(hstgrm(bb)); 
if imgi==1
    figure
    plot(pwsdb);grid on;
    set(gca,'fontsize',16);
    axis([0 length(pwsdb) noiselevel-10 max(pwsdb)]);
    hold on;
    plot([0 length(pwsdb)],noiselevel*[1 1],'r');
    plot([0 length(pwsdb)],noiselevel*[1 1]+3,'r-.');
    title('Instantaneous power  solid line:noise level, dash-dot line:threshold')
    xlabel('time (ms)');ylabel('power (dB)')
end;
%----- F0 tracking
ac1=zeros(1,length(f0cand));
for ii=1:length(f0cand)
ac1(ii)=zfirstac(x,fs,round(ii/1000*fs),30);
end;
auxouts.F0candidatesByMix=f0cand;
auxouts.RELofcandidatesByMix=relv;
auxouts.FirstAutoCorrelation=ac1;
auxouts.InstantaneousPower=pwsdb;
%f0raw0=zf0trackmulti(auxouts,ac1th,f0jump,nsd);
%[f0raw0,segb]=zf0trackmulti25(auxouts,ac1th,f0jump,nsd,prm);  %
%27/July/2004
%[f0s,rels,csegs]=contiguousSegment6(auxouts,strel,endrel,endrel2,prm);
[f0s,rels,csegs]=zcontiguousSegment10(auxouts,prm);
[f0raw0,relc]=zfillf0gaps6(auxouts,f0s,rels,csegs,prm);
%[f0s,rels,csegs]=zcontiguousSegment2(auxouts,0.55,0.16,0.4);% first param. was 0.5 (by 3AM 28)
%f0raw0(f0s>0)=f0s(f0s>0);

if imgi==1;
    figure
    semilogy(f0raw0,'c');grid on;
    set(gca,'fontsize',16);
    axis([0 length(f0raw0) f0floor f0ceil]);
    drawnow;
end;
%------ F0 refinement using first three harmonic components
f0raw0(isnan(f0raw0))=zeros(size(f0raw0(isnan(f0raw0))));
f0raw0(f0raw0>f0ceil)=f0raw0(f0raw0>f0ceil)*0+f0ceil;
f0raw0((f0raw0<f0floor)&(f0raw0>0))=f0raw0((f0raw0<f0floor)&(f0raw0>0))*0+f0floor;
%dn2=floor(fs/(f0ceil*3*2));
[f0raw2,ecr,ac1]=zrefineF06m(decimate(x,dn),fs/dn,f0raw0,1024,1.1,3,1,1,length(f0raw0));
if imgi==1;
    hold on;
    semilogy(f0raw2,'g');grid on;
end;
%------ Threshoulding for silence and V/UV
%thsilence=3; % for silence
%thvuv=0.6; % for V/UV
%f00=f0raw2;
%f00(pwsdb(1:length(f00))<(noiselevel+thsilence))=f00(pwsdb(1:length(f00))<(noiselevel+thsilence))*0;
%f0raw3=f00;
%f0raw3((zdB(ecr)/100+ac1)<thvuv)=f0raw3((zdB(ecr)/100+ac1)<thvuv)*0;
%----- new V/UV decision routine 15/Aug./2004
auxouts.BackgroundNoiselevel=noiselevel;
vuv=zvuvdecision4(f0raw2,auxouts);
nnll=min(length(f0raw2),length(vuv));
f0raw3=f0raw2(1:nnll).*vuv(1:nnll);
if imgi==1
    semilogy(f0raw3,'k');hold off
    title('F0 estimates,  cyan:initial, greeen:fine-tuned, black:voiced part')
    xlabel('time (ms)');ylabel('frequency (Hz)');
end;
%vuv=zdB(ecr)/100+ac1;
f0raw=f0raw2(1:nnll);vuv=vuv(1:nnll);
auxouts.F0candidatesByIF=pos;
auxouts.CNofcandidatesByIF=val;
auxouts.F0candidatesByAC=f02;
auxouts.ACofcandidatesByAC=pl2;
auxouts.F0candidatesByMix=f0cand;
auxouts.RELofcandidatesByMix=relv;
auxouts.RefinedCN=ecr;
auxouts.FirstAutoCorrelation=ac1;
auxouts.F0initialEstimate=f0raw0;
auxouts.BackgroundNoiselevel=noiselevel;
auxouts.InstantaneousPower=pwsdb;
auxouts.RefinedF0estimates=f0raw;
auxouts.VUVindicator=vuv;
if imgi==1; displaysummary(auxouts,f0floor,f0ceil); end;
switch nargout
    case 0
        f0raw=auxouts;eval(['help ' mfilename]);
    case 1
        f0raw=f0raw3;
    case 2
    case {3,4}
    otherwise
        eval(['help ' mfilename]);
        return;
end

%------
function prm=zsetdefaultparams;
prm.F0searchLowerBound=40; % f0floor
prm.F0searchUpperBound=800; % f0ceil
prm.F0frameUpdateInterval=1; % shiftm % F0 calculation interval (ms)
prm.NofChannelsInOctave=24; % nvo=24; % Number of channels in one octave
prm.IFWindowStretch=1.2; % mu=1.2; % window stretch from isometric window
prm.DisplayPlots=0; % imgi=1; % image display indicator (1: display image)
prm.IFsmoothingLengthRelToFc=1; %  smp=1; % smoothing length relative to fc (ratio)
prm.IFminimumSmoothingLength=5; %  minm=5; % minimum smoothing length (ms)
prm.IFexponentForNonlinearSum=0.5; % pc=0.5; % exponent to represent nonlinear summation
prm.IFnumberOfHarmonicForInitialEstimate=1; % nc=1; % number of harmonic component to use (1,2,3)
prm.TimeConstantForPowerCalculation=10;  % tcpower=10; % time constant for power calculation (ms)
prm.ACtimeWindowLength=60; % Time window length for Autocorrelation based method (ms)
prm.ACnumberOfFrequencySegments=8; % for Autocorrelation method
prm.ACfrequencyDomainWindowWidth=2200; % for Autocorrelation method (Hz)
prm.ACpowerExponentForNonlinearity=0.5; % for Autocorrelation method
prm.ACamplitudeCompensationInShortLag=1.6; %2.2; % for Autocorrelation method (ratio) 23/July/2004
prm.ACexponentForACdistance=4; % Nonlinear distance measure for post processing
prm.AClagSmoothingLength=0.0001; % Lag smoothing length for post processing (s) !! 0.01 to 0.0001 23/July/2004
prm.ACtemporalSmoothingLength=20; % Temporal smoothing length for post processing (ms)
prm.ThresholdForSilence=3; % for silence decision above average noise level (dB)
prm.ThresholdForVUV=0.6; % for V/UV decision based on first autocorrelation and C/N
prm.WeightForAutocorrelationMap=1; % weight for combining maps (Autocorrelation)
prm.WeightForInstantaneousFqMap=1; % weight for combining maps (Instantaneous Frequency)
prm.VUVthresholdOfAC1=-0.1; % First autocorrelation thershould for VUV in segment search
prm.SDforNormalizeMixingDistance=0.3; % Normalization factor for mixing F0 distance (octave)
prm.SDforTrackingNormalization=0.2;
prm.MaxumumPermissibleOctaveJump=0.4; 
prm.ThresholdToStartSearch=0.3;
prm.ThresholdToQuitSearch=0.35;
prm.ThresholdForReliableRegion=0.25;
prm.WhoAmI=mfilename;
return;

%%%------------
function oki=displaysummary(f,f0floor,f0ceil)
oki=1;
nn=length(f.RefinedF0estimates);
figure
subplot(211);
semilogy(f.F0initialEstimate,'c');grid on;
hold on;
semilogy(f.RefinedF0estimates.*f.VUVindicator,'b');grid on;
set(gca,'fontsize',14);
xlabel('time (ms)');
ylabel('frequency (Hz)');
axis([1 nn f0floor f0ceil]);
subplot(212);
plot(f.RELofcandidatesByMix,'.');grid on;
set(gca,'fontsize',14);
xlabel('time (ms)');
ylabel('relative periodicity');
axis([1 nn 0 1]);
drawnow

%%%------------
function [f0v,vrv,dfv,nf,aav]=zfixpF0VexMltpBG4(x,fs,f0floor,nvc,nvo,mu,imgi,shiftm,smp,minm,pc,nc)

%	Fixed point analysis to extract F0
%	[f0v,vrv,dfv,nf]=fixpF0VexMltpBG4(x,fs,f0floor,nvc,nvo,mu,imgi,shiftm,smp,minm,pc,nc)
%	x	: input signal
%	fs	: sampling frequency (Hz)
%	f0floor	: lowest frequency for F0 search
%	nvc	: total number of filter channels
%	nvo	: number of channels per octave
%	mu	: temporal stretching factor
%	imgi	: image display indicator (1: display image)
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

%f0floor=40;
%nvo=12;
%nvc=52;
%mu=1.1;

x=cleaninglownoise(x,fs,f0floor);

fxx=f0floor*2.0.^((0:nvc-1)/nvo)';
fxh=max(fxx);

dn=max(1,floor(fs/(fxh*6.3)));

if nc>2
	pm3=zmultanalytFineCSPB(decimate(x,dn),fs/dn,f0floor,nvc,nvo,mu,3); % error crrect 2002.9.19 (mu was fixed 1.1)
	pif3=zwvlt2ifq(pm3,fs/dn);
	[nn,mm]=size(pif3);
	pif3=pif3(:,1:3:mm);
	pm3=pm3(:,1:3:mm);
end;

if nc>1
	pm2=zmultanalytFineCSPB(decimate(x,dn),fs/dn,f0floor,nvc,nvo,mu,2);% error crrect 2002.9.19(mu was fixed 1.1)
	pif2=zwvlt2ifq(pm2,fs/dn);
	[nn,mm]=size(pif2);
	pif2=pif2(:,1:3:mm);
	pm2=pm2(:,1:3:mm);
end;

pm1=zmultanalytFineCSPB(decimate(x,dn*3),fs/(dn*3),f0floor,nvc,nvo,mu,1);% error crrect 2002.9.19(mu was fixed 1.1)
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
%%%hpg=waitbar(0,'P/N map calculation'); % 07/Dec./2002 by H.K.
for ii=1:nn
%	[c1,c2]=znrmlcf2(fxx(ii)/2/pi); % This is OK, but the next Eq is much faster.
	c2=c2b*(fxx(ii)/2/pi)^2;
	cff=damp(ii,:)/fxx(ii)*2*pi*0;
	mmp(ii,:)=(dslp(ii,:)./(1+cff.^2)/sqrt(c2)).^2+(slp(ii,:)./sqrt(1+cff.^2)/sqrt(c1)).^2;
    %%%waitbar(ii/nn);%,hpg); % 07/Dec./2002 by H.K.
end;
%%%close(hpg);

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
%%%hpg=waitbar(0,'Fixed pints calculation'); % 07/Dec./2002 by H.K.
for ii=1:mm
	[ff,vv,df,aa]=zfixpfreq3(fxx,pif2(:,ii),smap(:,ii),dpif(:,ii)/2/pi,pm1(:,ii));
	kk=length(ff);
	fixpp(1:kk,ii)=ff;
	fixvv(1:kk,ii)=vv;
	fixdf(1:kk,ii)=df;
	fixav(1:kk,ii)=aa;
	nf(ii)=kk;
    %%%if rem(ii,10)==0; waitbar(ii/mm); end;% 07/Dec./2002 by H.K.
end;
%%%close(hpg); % 07/Dec./2002 by H.K.
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
%set(aa,'PaperPosition',[0.3 0.25 8 10.9]);
%set(aa,'Position',[30 130 520 680]);
%subplot(211);
imagesc([0 (mm-1)*dt*1000],[1 nn],zdB(smap(:,round(1:shiftm/dn*fs/1000:mm))));axis('xy')
set(gca,'fontsize',16);
hold on;
tx=((1:shiftm/dn*fs/1000:mm)-1)*dt*1000;
plot(tx,(nvo*log(fixpp(:,round(1:shiftm/dn*fs/1000:mm))/f0floor/2/pi)/log(2)+0.5)','ko');
plot(tx,(nvo*log(fixpp(:,round(1:shiftm/dn*fs/1000:mm))/f0floor/2/pi)/log(2)+0.5)','w.');
hold off
xlabel('time (ms)');
ylabel('channel #');
title('Instantaneous frequency-based fixed points')
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

%%%---------
function pm=zmultanalytFineCSPB(x,fs,f0floor,nvc,nvo,mu,mlt);

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
%       Outpur parameters
%               pm      : wavelet transform using iso-metric Gabor function
%
%       If you have any questions,  mailto:kawahara@hip.atr.co.jp
%
%       Copyright (c) ATR Human Information Processing Research Labs. 1996
%       Invented and coded by Hideki Kawahara
%       30/Oct./1996
%       07/Dec./2002 waitbar was added

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
%%%hpg=waitbar(0,['wavelet analysis for initial F0 and P/N estimation with HM#:' num2str(mlt)]); % 07/Dec./2002 by H.K.
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
  %%%waitbar(ii/nvc);%,hpg); % 07/Dec./2002 by H.K.
%  keyboard;
end;
%%%close(hpg); % 07/Dec./2002 by H.K.
%[nn,mm]=size(pm);
%pm=pm(:,1:mlt:mm);

%%%----
function x=zdB(y)
x=20*log10(y);

%%%-----
function [val,pos]=zmultiCandIF(f0v,vrv)
%   [val,pos]=multiCandIF(f0v,vrv)
%   F0 candidates based on instantaneous frequency
%   fixed points
%   f0v : fixed point frequencies (Hz)
%   vrv : fixed point N/C (ratio)

%   by Hideki Kawahara
%   23/June/2004

[nr,nc]=size(f0v);
[nr2,nc2]=size(vrv);
if (nr~=nr2) | (nc~=nc2);val=[];pos=[];return;end;
vrvdb=-zdBpower(vrv);

mxfq=100000;
val=zeros(nc,3);
pos=ones(nc,3);
for ii=1:nc
    f=f0v(:,ii)';
    v=vrvdb(:,ii)';
    v=v(f<mxfq);
    f=f(f<mxfq);
    [mx,mxp]=max(v);
    if length(mxp)>0
        pos(ii,1)=f(mxp);
        val(ii,1)=v(mxp);
    else
        pos(ii,1)=1;
        val(ii,1)=1;
    end;
    if length(f)>1
        v(mxp)=v(mxp)*0-50;
        [mx,mxp]=max(v);
        pos(ii,2)=f(mxp);
        val(ii,2)=v(mxp);
        if length(f)>2
            v(mxp)=v(mxp)*0-50;
            [mx,mxp]=max(v);
            pos(ii,3)=f(mxp);
            val(ii,3)=v(mxp);
        else
            pos(ii,3)=pos(ii,2);val(ii,3)=val(ii,2);
        end;
    else
        pos(ii,2)=pos(ii,1);val(ii,2)=val(ii,1);
    end;
end;

%%%------
function y=zdBpower(x)
y=10*log10(x);

%%%------
function [y,ind,fq]=zremoveACinduction(x,fs,pos);
%   [y,ind,fq]=removeACinduction(x,fs,pos);
%   Function to remove AC induction
%   x   : input speech signal 
%   fs  : sampling frequency (Hz)
%   pos : Locations of Top-three F0 candidates (Hz)
%   Output parameter
%   y   : speech signal without AC induction
%   ind : 1 indicates AC induction was detected
%   fq  : frequency of AC induction

%   Designed and coded by Hideki Kawahawra, 
%   24/June/2004

x=x(:);
ind=0;
f=pos(:);
h50=sum(abs(f-50)<5)/sum(f>0);
h60=sum(abs(f-60)<5)/sum(f>0);
if (h50<0.2) & (h60<0.2);y=x;fq=0;return;end;
ind=1;
if h50>h60
    fq=50;
else
    fq=60;
end;
tx=(1:length(x))'/fs;
fqv=([-0.3:0.025:0.3]+fq);
txv=tx*fqv;
fk=x'*exp(-j*2*pi*txv)/length(x);
[fkm,ix]=max(abs(fk));
fq=fqv(ix);
y=x-2*real(fk(ix)*exp(j*2*pi*fq*tx));

%%%----
function [lagspec,lx]=zlagspectestnormal(x,fs,stp,edp,shiftm,wtlm,ndiv,wflf,pc,amp,h)
%   Lag spectrogram for F0 extraction
%   [lagspec,lx]=lagspectestnormal(x,fs,stp,edp,shiftm,wtlm,ndiv,wflf,pc,amp,h)
%   x   : waveform
%   fs  : sampling frequency (Hz)
%   stp : starting position (ms)
%   edp : end position (ms)
%   shiftm  : frame shift for analysis (ms)
%   wtlm    : time window length (ms)
%   ndiv    : number of segment in the frequency domain
%   wflf    : frequency domain window length (Hz)
%   pc      : power exponent for nonlinearity
%   amp : amount of lag window compensation

%   h       : handle for graph

%   16/June/2004 Simplified version
%   17/June/2004 with normalization

nftm=floor((edp-stp)/shiftm);
pm=stp;
[acc,abase,fx,lx]=ztestspecspecnormal(x,fs,pm,wtlm,ndiv,wflf,pc,amp);
nlx=length(lx);
lagspec=zeros(nlx,nftm);
for ii=1:nftm
    pmmul=stp+(ii-1)*shiftm;
    [acc,abase,fx,lx]=ztestspecspecnormal(x,fs,pmmul,wtlm,ndiv,wflf,pc,amp);%keyboard;
    lagspec(:,ii)=mean(acc')'/mean(acc(1,:));
end;
if h>0
    figure(h);
    imagesc([stp edp],[0 max(lx)]*1000,max(0,lagspec));
    axis('xy')
    axis([stp edp 0 40]);
    set(gca,'fontsize',16);
    xlabel('time (ms)')
    ylabel('lag (ms)')
    title(['wtl=' num2str(wtlm) 'ms ndiv=' num2str(ndiv) ' wfl=' num2str(wflf) 'Hz PC=' num2str(pc) ...
            ' fs=' num2str(fs) 'Hz amp=' num2str(amp)]);
    drawnow;
end;

%%%------
function [acc,abase,fx,lx]=ztestspecspecsimple(x,fs,pm,wtlm,ndiv,wflf,pc,amp);
%   Modified auto correlation 
%   [acc,abase,fx,lx]=testspecspecsimple(x,fs,pm,wtlm,ndiv,wflf,pc,amp);
%   input parameters
%   x   : signal to be analyzed
%   fs  : sampling frequency (Hz)
%   pm   : position to be tested (ms)
%   wtlm    : time window length (ms)
%   ndiv    : number of division on frequency axis
%   wflf    : frequency window length (hz)
%   pc  : power exponent
%   amp : amount of lag window compensation
%   output parameters
%   acc : spectrogram on frequency axis
%       : (periodicity gram on local frequency area)
%   fx  : frequency axis
%   lx  : lag axis

%  Test program for spectrum check
%   by Hideki Kawahara 27 March 2004
%   29/March/2004 streamlined
%   12/June/2004 Bias term removed
%   16/June/2004 Simplified version
%   17/June/2004 Spectral normalization version

%[x,fs]=wavread('m01.wav');
x=x(:);  % make x a column vector

wtlms=round(wtlm/1000*fs);  % windowlength in samples
wtlmso=floor(wtlms/2)*2+1;
bb=(1:wtlmso)-(wtlmso-1)/2; % time base for window;

fftl=2^ceil(log2(wtlmso)); % set FFT length to 2's exponent
x=[zeros(fftl,1);x;zeros(fftl,1)]; % safeguard

p=round(pm/1000*fs); % analysis position in samples
fx=(0:fftl-1)/fftl*fs;
tx=(0:fftl-1);
tx(tx>fftl/2)=tx(tx>fftl/2)-fftl;
tx=tx/fs;
lagw=exp(-(tx/0.004).^2);
lagw=exp(-(tx/0.003).^2); % EGGF0testn11
lagw=exp(-(tx/0.0035).^2); % EGGF0testn12

lagw2=exp(-(tx/0.0012).^2);
lagw2=exp(-(tx/0.0016).^2);% EGGF0testn12

xt=x(fftl+bb+p); % waveform segment to be analyzed
abase=abs(fft(xt.*blackman(wtlmso),fftl));
mxab=max(abase);
ac=ifft(abase.^2);
npw=real(fft(ac.*lagw'));
pw=abase.^2.0./real(npw);

fsp=fs/fftl;
wflfs=round(wflf/fsp); % frequency window length in bins
wflfso=floor(wflfs/2)*2+1;
bbf=(1:wflfso)-(wflfso-1)/2; % index for frequency window
fftlf=2^ceil(log2(wflfso)+2);
lx=(0:fftlf/2-1)/(fsp*fftlf);
nsht=fftl/2/ndiv;
acc=zeros(fftlf/2,ndiv+1);
w2=hanning(wflfso);
ampw=1-lagw*(1-1/amp);
ampw=(1-lagw2(1:fftlf/2)'*(1-1/amp))./ampw(1:fftlf/2)';
for ii=1:ndiv+1
    p=rem(round(fftl/2+bbf+(ii-1)*nsht),fftl)+1;
    ac=abs(fft((pw(p)).*w2,fftlf))*(npw(p((wflfso-1)/2))).^pc;
    acc(:,ii)=ac(1:fftlf/2).*ampw;
end;

%%%------
function [acc,abase,fx,lx]=ztestspecspecnormal(x,fs,pm,wtlm,ndiv,wflf,pc,amp);
%   Modified auto correlation 
%   [acc,abase,fx,lx]=testspecspecnormal(x,fs,pm,wtlm,ndiv,wflf,pc,amp);
%   input parameters
%   x   : signal to be analyzed
%   fs  : sampling frequency (Hz)
%   pm   : position to be tested (ms)
%   wtlm    : time window length (ms)
%   ndiv    : number of division on frequency axis
%   wflf    : frequency window length (hz)
%   pc  : power exponent
%   amp : amount of lag window compensation
%   output parameters
%   acc : spectrogram on frequency axis
%       : (periodicity gram on local frequency area)
%   fx  : frequency axis
%   lx  : lag axis

%  Test program for spectrum check
%   by Hideki Kawahara 27 March 2004
%   29/March/2004 streamlined
%   12/June/2004 Bias term removed
%   16/June/2004 Simplified version
%   17/June/2004 Spectral normalization version

%[x,fs]=wavread('m01.wav');
x=x(:);  % make x a column vector

wtlms=round(wtlm/1000*fs);  % windowlength in samples
wtlmso=floor(wtlms/2)*2+1;
bb=(1:wtlmso)-(wtlmso-1)/2; % time base for window;

fftl=2^ceil(log2(wtlmso)); % set FFT length to 2's exponent
x=[zeros(fftl,1);x;zeros(fftl,1)]; % safeguard

p=round(pm/1000*fs); % analysis position in samples
fx=(0:fftl-1)/fftl*fs;
tx=(0:fftl-1);
tx(tx>fftl/2)=tx(tx>fftl/2)-fftl;
tx=tx/fs;
lagw=exp(-(tx/0.004).^2);
lagw=exp(-(tx/0.003).^2); % EGGF0testn11
lagw=exp(-(tx/0.0035).^2); % EGGF0testn12

lagw2=exp(-(tx/0.0012).^2);
lagw2=exp(-(tx/0.0016).^2);% EGGF0testn12

xt=x(fftl+bb+p); % waveform segment to be analyzed
if sum(abs(xt))<1e-10 % bug fix 11/Jan./2005
    xt=xt+randn(size(xt));
end;
abase=abs(fft(xt.*blackman(wtlmso),fftl));
mxab=max(abase);
ac=ifft(abase.^2);
npw=real(fft(ac.*lagw'));
%efeps=min(npw(npw>0)); % bug fix 11/Jan./2005
%npw(npw==0)=npw(npw==0)+efeps; % bug fix 11/Jan./2005
pw=abase.^2.0./real(npw);

fsp=fs/fftl;
wflfs=round(wflf/fsp); % frequency window length in bins
wflfso=floor(wflfs/2)*2+1;
bbf=(1:wflfso)-(wflfso-1)/2; % index for frequency window
fftlf=2^ceil(log2(wflfso)+2);
lx=(0:fftlf/2-1)/(fsp*fftlf);
nsht=fftl/2/ndiv;
acc=zeros(fftlf/2,ndiv+1);
w2=hanning(wflfso);
ampw=1-lagw*(1-1/amp);
ampw=(1-lagw2(1:fftlf/2)'*(1-1/amp))./ampw(1:fftlf/2)';
for ii=1:ndiv+1
    p=rem(round(fftl/2+bbf+(ii-1)*nsht),fftl)+1;
    ac=abs(fft((pw(p)).*w2,fftlf))*(npw(p((wflfso-1)/2))).^pc;
    acc(:,ii)=ac(1:fftlf/2).*ampw;
end;

%%%----
function [f0,pl]=zmultiCand(lx,lagspec,beta,lagsp,timesp)
%   F0 candidates extraction from time-lag representation
%   using palabolic interpolation
%   [f0,pl]=multiCand(lx,lagspec,beta,lagsp,timesp)
%   lx  : lag axis
%   lagspec : time-lag representation
%   beta    : nonlinear distance measure
%   lagsp   : lag smoothing parameter (ms)
%   timesp  : temporal smoothing parameter (ms)
%   output parameters
%   f0  : fundamental frequency (Hz)
%   pl  : peak level

%   Designed and coded by Hideki Kawahara
%   30/March/2004
%   16/June/2004 Peak picking first
%   17/June/2004 Peak selection taking into interaction account

[nr,nc]=size(lagspec);
imm=diff([lagspec(1,:);lagspec]).*(diff([lagspec;lagspec(end,:)]));
dlag=diff([lagspec(1,:);lagspec]);
lagspecz=lagspec;
lagspecz(lx<0.001,:)=lagspec(lx<0.001,:)*0.0001;
%keyboard;
tls=[lagspecz;lagspecz(end,:);lagspecz(end:-1:2,:)].^beta;

llx=[lx lx(end) lx(end:-1:2)]';
lagw=exp(-(llx/(lagsp/1000)).^2); % This should be propotional to lag.
lagw=lagw/sum(lagw);
flagw=real(fft(lagw));
for ii=1:nc
    tls(:,ii)=real(ifft(fft(tls(:,ii)).*flagw));
end;

tmsm=round((timesp-1)/2)*2+1; % temporal smoothing (ms) assuming shift=1 ms
wt=hanning(tmsm);
wt=wt/sum(wt);
% temporal smoothing using 
lagsms=fftfilt(wt,[zeros(nr,tmsm) tls(1:nr,:) zeros(nr,tmsm)]')';
lagsms=lagsms(:,(1:nc)+(tmsm-1)/2*3);

lagsms=abs(lagsms).^(1/beta);
%figure;imagesc(lagsms);axis('xy');
f0=zeros(nc,3);
pl=zeros(nc,3);
for ii=1:nc
    ix=find((imm(:,ii)<0)&(dlag(:,ii)>0));
    [mx,mxp]=max(lagsms(ix,ii));
    [pl(ii,1),pos]=zParabolicInterp(lagspec((-1:1)+ix(mxp),ii),ix(mxp));
    f0(ii,1)=pos/lx(2);
    if length(ix)>1
        lagsms(ix(mxp),ii)=lagsms(ix(mxp),ii)*0;
        [mx,mxp]=max(lagsms(ix,ii));
        [pl(ii,2),pos]=zParabolicInterp(lagspec((-1:1)+ix(mxp),ii),ix(mxp));
        f0(ii,2)=pos/lx(2);
        if length(ix)>2
            lagsms(ix(mxp),ii)=lagsms(ix(mxp),ii)*0;
            [mx,mxp]=max(lagsms(ix,ii));
            [pl(ii,3),pos]=zParabolicInterp(lagspec((-1:1)+ix(mxp),ii),ix(mxp));
            f0(ii,3)=pos/lx(2);
        else
            f0(ii,3)=f0(ii,2);pl(ii,3)=pl(ii,2);
        end;
    else
        f0(ii,2)=f0(ii,1);pl(ii,2)=pl(ii,1);
    end;
end;

function [val,pos]=zParabolicInterp(yv,xo)
lp=diff(yv);
a=lp(1)-lp(2);
b=(lp(1)+lp(2))/2;
xp=b/a+xo;
val=yv(2)+0.5*a*(b/a)^2+b*(b/a);
pos=1/(xp-1);

%%%-----
function [f0mapIF,f0mapAC,fx]=zCombineSourceInfoNorm(val,pos,f02,pl2,f0floor,f0ceil,nvo);
%   [f0mapIF,f0mapAC,fx]=CombineSourceInfo(val,pos,f02,pl2,f0floor,f0ceil,nvo);
%   val : C/N based on reliablity (dB)
%   pos : candidate frequency (Hz) based on Instantaneous frequency
%   f02 : Summary autocorrelation based candidate frequency (Hz)

[nrowIF,nc1]=size(val);
[nrowAC,nc2]=size(f02);

nn=min(nrowIF,nrowAC);
%f0floor=40;
%f0ceil=800;
%nvo=24;
nvc=ceil(log2(f0ceil/f0floor)*nvo);
fx=f0floor*2.0.^((0:nvc)/nvo)';
f0mapIF=zeros(length(fx),nn);
f0mapAC=zeros(length(fx),nn);

lb1=min(val(:,1));
lb2=min(pl2(:,1));
ub1=max(val(:,1));
ub2=max(pl2(:,1));

for ii=1:nn
    for jj=1:nc1
        f0mapIF(:,ii)=f0mapIF(:,ii)+((max(lb1,val(ii,jj))-lb1)/(ub1-lb1)).^2*exp(-(log2(pos(ii,jj)./fx)*6).^2);
        f0mapAC(:,ii)=f0mapAC(:,ii)+((max(lb2,pl2(ii,jj))-lb2)/(ub2-lb2)).^2*exp(-(log2(f02(ii,jj)./fx)*6).^2);
    end;
end;

%%%-----
function [f0,pl]=zmultiCandf0map(lfx,f0map)
%   F0 candidates extraction from time-lag representation
%   using palabolic interpolation
%   [f0,pl]=multiCand(fx,f0map)
%   lfx  : logarithmically linear frequency axis
%   f0map : time-frequency representation
%   output parameters
%   f0  : fundamental frequency (Hz)
%   pl  : peak level

%   Designed and coded by Hideki Kawahara
%   30/March/2004
%   16/June/2004 Peak picking first
%   17/June/2004 Peak selection taking into interaction account
%   26/June/2004 converted to f0map manipulation (vanilla version)

fx=log2(lfx)-log2(lfx(1));

[nr,nc]=size(f0map);
imm=diff([f0map(1,:);f0map]).*(diff([f0map;f0map(end,:)]));
dlag=diff([f0map(1,:);f0map]);
f0mapbak=f0map;
f0=zeros(nc,3);
pl=zeros(nc,3);
for ii=1:nc
    ix=find((imm(:,ii)<0)&(dlag(:,ii)>0));
    if length(ix)>0
        [mx,mxp]=max(f0map(ix,ii));
        [pl(ii,1),pos]=zParabolicInterp2(f0mapbak((-1:1)+ix(mxp),ii),ix(mxp));
    else
        pos=round(nr/4);
        pl(ii,1)=0;
    end;
    f0(ii,1)=pos*fx(2);
    if length(ix)>1
        f0map(ix(mxp),ii)=f0map(ix(mxp),ii)*0;
        [mx,mxp]=max(f0map(ix,ii));
        [pl(ii,2),pos]=zParabolicInterp2(f0mapbak((-1:1)+ix(mxp),ii),ix(mxp));
        f0(ii,2)=pos*fx(2);
        if length(ix)>2
            f0map(ix(mxp),ii)=f0map(ix(mxp),ii)*0;
            [mx,mxp]=max(f0map(ix,ii));
            [pl(ii,3),pos]=zParabolicInterp2(f0mapbak((-1:1)+ix(mxp),ii),ix(mxp));
            f0(ii,3)=pos*fx(2);
        else
            f0(ii,3)=f0(ii,2);pl(ii,3)=pl(ii,2);
        end;
    else
        f0(ii,2)=f0(ii,1);pl(ii,2)=pl(ii,1);
    end;
end;
f0=lfx(1)*2.0.^(f0);

function [val,pos]=zParabolicInterp2(yv,xo)
lp=diff(yv);
a=lp(1)-lp(2);
b=(lp(1)+lp(2))/2;
xp=b/a+xo;
val=yv(2)+0.5*a*(b/a)^2+b*(b/a);
pos=xp-1;

%%%-------
function pws=zVpowercalc(x,fs,wtc,shiftm,fc)
%   pws=Vpowercalc(x,fs,wtc,shiftm,fc)
%   x   : waveform
%   fs  : sampling frequency (Hz)
%   wtc : window time constatnt (ms)
%   shifrm  : frame update interval (ms)
%   fc  : LPF cut-off frequency (Hz)

%---- window design for pwer smoothing
t=(0:1/fs:wtc*5/1000);
w=exp(-t/(wtc/1000));
w=w-w(end);
w=w/sum(w);

%----- window for preprocesing LPF
lw=round(fs/fc*2);
b=fir1(lw-1,2*fc/fs);
nn=length(x);
x=fftfilt(b,[x(:);zeros(lw,1)]);
x=x((1:nn)+round(lw/2)-1);

yf=fftfilt(w,x.^2);
yb=fftfilt(w,x(end:-1:1).^2);
yb=yb(end:-1:1);
y=min(yf,yb);
nn=length(x);

pws=interp1((0:nn-1)/fs*1000,y,0:shiftm:(nn-1)/fs*1000);

%%%-----
function [f0r,ecr,ac1]=zrefineF06m(x,fs,f0raw,fftl,eta,nhmx,shiftm,nl,nu)
%	F0 estimation refinement
%	[f0r,ecr]=refineF06m(x,fs,f0raw,fftl,nhmx,shiftm,nl,nu)
%		x		: input waveform
%		fs		: sampling frequency (Hz)
%		f0raw	: F0 candidate (Hz)
%		fftl	: FFT length
%		eta		: temporal stretch factor
%		nhmx	: highest harmonic number
%		shiftm	: frame shift period (ms)
%		nl		: lower frame number
%		nu		: uppter frame number
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
%   30/June/2004 debug

f0raw=f0raw(:)';
f0i=f0raw;
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

ec1=cos(2*pi*(0:fftl-1)/fftl); % first auto correlation basis function
ac1=f0raw*0;

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

%%%hpg=waitbar(0,'F0 refinement using F0 adaptive analysis'); % 07/Dec./2002 by H.K.
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
	dcl=mean(x(bb+bias));
    txm1=x(bb+bias-1);
    tx0=x(bb+bias);
    txp1=x(bb+bias+1);
    if (sum(abs(txm1))<1e-20)|(sum(abs(txm1))<1e-20)|(sum(abs(txm1))<1e-20)|(sum(abs(txm1))<1e-20)
        xtmp=x+randn(size(x)); % this if clause is a bug fix. 11/Jan./2005
        dcl=mean(xtmp(bb+bias));
        txm1=xtmp(bb+bias-1);
        tx0=xtmp(bb+bias);
        txp1=xtmp(bb+bias+1);
    end;
    %if sum(abs(txm1))==0;txm1=randn(size(txm1));end;
    %if sum(abs(tx0))==0;tx0=randn(size(tx0));end;
    %if sum(abs(txp1))==0;txp1=randn(size(txp1));end;
	%ff0=fft((x(bb+bias-1)-dcl).*wa,fftl);
	%ff1=fft((x(bb+bias)-dcl).*wa,fftl);
	%ff2=fft((x(bb+bias+1)-dcl).*wa,fftl);
	ff0=fft((txm1-dcl).*wa,fftl);
	ff1=fft((tx0-dcl).*wa,fftl);
	ff2=fft((txp1-dcl).*wa,fftl);
    ff0(ff0==0)=ff0(ff0==0)+0.000000001;
    ff1(ff1==0)=ff1(ff1==0)+0.000000001;
    ff2(ff2==0)=ff2(ff2==0)+0.000000001;
	fd=ff2.*rr-ff1;
	fd0=ff1.*rr-ff0;
	crf=fax+(real(ff1).*imag(fd)-imag(ff1).*real(fd))./(abs(ff1).^2)*fs/pi/2;
	crf0=fax+(real(ff0).*imag(fd0)-imag(ff0).*real(fd0))./(abs(ff0).^2)*fs/pi/2;
	pif(:,kk)=crf(bx)'*2*pi;
	dpif(:,kk)=(crf(bx)-crf0(bx))'*2*pi;
	pwm(:,kk)=abs(ff1(bx)'); % 29/July/1999
    %%%waitbar((kk-nl)/(nu-nl));% ,hpg) % 07/Dec./2002 by H.K.
    ac1(kk)=sum(abs(ff1).^2.0.*ec1)/sum(abs(ff1).^2);
%	keyboard;
end;
%%%close(hpg);
slp=([pif(2:fftl/2+1,:);pif(fftl/2+1,:)]-pif)/(fs/fftl*2*pi);
dslp=([dpif(2:fftl/2+1,:);dpif(fftl/2+1,:)]-dpif)/(fs/fftl*2*pi)*fs;
mmp=slp*0;

%[c1,c2]=znrmlcf2(1);
[c1,c2]=znrmlcf3(shiftm);
fxx=((0:fftl/2)+0.5)/fftl*fs*2*pi;

%--- calculation of relative noise level

%%%hpg=waitbar(0,'P/N calculation'); % 07/Dec./2002 by H.K.
for ii=1:fftl/2+1;
	c2=c2*(fxx(ii)/2/pi)^2;
	mmp(ii,:)=(dslp(ii,:)/sqrt(c2)).^2+(slp(ii,:)/sqrt(c1)).^2;
    %%%if rem(ii,10)==0;waitbar(ii/(fftl/2+1));end;  % 07/Dec./2002 by H.K.
end;
%%%close(hpg); % 07/Dec./2002 by H.K.

%--- Temporal smoothing

%sml=round(6*fs/1000/2)*2+1; % 12 ms, and odd number
%sml=round(4*fs/1000/2)*2+1; % 8 ms, and odd number
sml=round(1.5*fs/1000/2/shiftm)*2+1; % 3 ms, and odd number
smb=round((sml-1)/2); % bias due to filtering

%%%hpg=waitbar(0,'P/N smoothing'); % 07/Dec./2002 by H.K.
%This smoothing is modified (30 Nov. 2000).
smmp=fftfilt((hanning(sml).^2)/sum((hanning(sml).^2)),[mmp zeros(fftl/2+1,sml*2)]'+0.00001)';
smmp(smmp==0)=smmp(smmp==0)+0.0000000001;
%%waitbar(0.2);
smmp=1.0./fftfilt(hanning(sml)/sum(hanning(sml)),1.0./smmp')';
%%waitbar(0.4);
smmp=smmp(:,max(1,(1:nfr)+sml-2)); % fixed by H.K. on 10/Dec./2002

%--- Power adaptive weighting (29/July/1999)

spwm=fftfilt(hanning(sml)/sum(hanning(sml)),[pwm zeros(fftl/2+1,sml*2)]')';
spwm(spwm==0)=spwm(spwm==0)+0.00000001;
%%%waitbar(0.6);
spfm=fftfilt(hanning(sml)/sum(hanning(sml)),[pwm.*pif zeros(fftl/2+1,sml*2)]'+0.00001)';
%%%waitbar(0.8);
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
	iidx=idx+iidx;
	vvv(ii,:)=(smmp(floor(iidx))+(iidx-floor(iidx)).*(smmp(floor(iidx)+1)-smmp(floor(iidx))))/(ii*ii);
%	fqv(ii,:)=(pif(floor(iidx))+(iidx-floor(iidx)).*(pif(floor(iidx)+1)-pif(floor(iidx))))/2/pi/ii;
	fqv(ii,:)=(spif(floor(iidx))+(iidx-floor(iidx)).*(spif(floor(iidx)+1)-spif(floor(iidx))))/2/pi/ii; % 29/July/199
end;
%%%waitbar(1);
vvvf=1.0./sum(1.0./vvv);
f0r=sum(fqv./sqrt(vvv))./sum(1.0./sqrt(vvv)).*(f0raw>0);
ecr=sqrt(1.0./vvvf).*(f0raw>0)+(f0raw<=0);
%%%close(hpg);

%keyboard;

%--------------------
function [c1,c2]=znrmlcf3(f)

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

%%%----------------
function [f0,pl]=zcombineRanking4(p,beta,wAC,wIF,prm)

%        F0candidatesByIF: [2978x3 double]
%      CNofcandidatesByIF: [2978x3 double]
%        F0candidatesByAC: [2977x3 double]
%      ACofcandidatesByAC: [2977x3 double]
%               RefinedCN: [1x2977 double]
%    FirstAutoCorrelation: [1x2977 double]
%       F0initialEstimate: [2977x1 double]
%    BackgroundNoiselevel: -69.1041
%      InstantaneousPower: [1x2979 double]

f0floor=prm.F0searchLowerBound; % f0floor
f0ceil=prm.F0searchUpperBound; % f0ceil

n=min([length(p.F0candidatesByIF) length(p.F0candidatesByAC)]);
nr=n;

nvo=24;
nvc=ceil(log2(f0ceil/f0floor))*nvo;
fx=f0floor*2.0.^((0:nvc-1)/nvo);
lfx=log2(fx);
v1=[1;1;1];
r1=[1 1 1];
logf0if=log2(p.F0candidatesByIF);
logf0ac=log2(p.F0candidatesByAC);
relif=max(0.000000001,(p.CNofcandidatesByIF-min(p.CNofcandidatesByIF(:,1)))./ ...
    (max(p.CNofcandidatesByIF(:,1))-min(p.CNofcandidatesByIF(:,1))));
relac=max(0.000000001,((p.ACofcandidatesByAC-min(p.ACofcandidatesByAC(:,1)))./ ...
    (max(p.ACofcandidatesByAC(:,1))-min(p.ACofcandidatesByAC(:,1)))));
f0=zeros(n,6);
pl=zeros(n,6);
initv=0*lfx;
for ii=1:n
    IFmap=initv;
    ACmap=initv;
    for jj=1:3
        IFmap=IFmap+relif(ii,jj)^2*exp(-((logf0if(ii,jj)-lfx)/beta).^2); % 27/July/2004 ^2
        ACmap=ACmap+relac(ii,jj)^2*exp(-((logf0ac(ii,jj)-lfx)/beta).^2); % 27/July/2004 ^2
    end;
    %f0map=wIF*IFmap+wAC*ACmap;% 22/July/2004
    %f0map=sqrt(IFmap.*ACmap); % 22/July/2004 sqrt
    f0map=sqrt(wIF*IFmap+wAC*ACmap)/sqrt(2); % 27/July/2004 Addition
    f0mapbak=f0map;
    ix=find((diff([f0map(1) f0map]).*diff([f0map f0map(end)]))<0);
    if length(ix)>0
        [mx,mxp]=max(f0map(ix));
        [pl(ii,1),pos]=zzParabolicInterp2(f0mapbak((-1:1)+ix(mxp)),ix(mxp));
        [tpl,idsrt]=sort(-f0map(ix));
        nix=length(ix);
        for jj=1:6
            if jj>nix
                pl(ii,jj)=pl(ii,jj-1);
                f0(ii,jj)=f0(ii,jj-1);
            else
                [pl(ii,jj),f0(ii,jj)]=zzParabolicInterp2(f0mapbak((-1:1)+ix((idsrt(jj)))),ix((idsrt(jj))));
            end;
        end;
    else
        pos=round(nr/4);
        pl(ii,1)=0;
    end;
end;
f0=f0floor*2.0.^(f0/nvo);

%-------
function [val,pos]=zzParabolicInterp2(yv,xo)
lp=diff(yv);
a=lp(1)-lp(2);
b=(lp(1)+lp(2))/2;
xp=b/a+xo;
val=yv(2)+0.5*a*(b/a)^2+b*(b/a);
pos=xp-1;

%%%---
function ac1=zfirstac(x,fs,ix,wlms);

wl=round(fs*wlms/1000);
fftl=2.0^ceil(log2(wl));
xx=x(:);
idx=ix+(1:wl)-round(wl/2);
xt=xx(min(length(xx),max(1,idx)));
if sum(abs(xt))<1e-20  % bug fix 11/Jan./2005
    xt=xt+randn(size(xt));
end;
fw=abs(fft(xt.*hanning(wl),fftl)).^2;
fx=(0:fftl-1)/fftl*fs;
[dmy,ixx]=min(abs(fx-4000));
if ixx>fftl/2
    ixx=fftl/2;
end;
c=cos(2*pi*fx(1:ixx)/(fx(ixx)*2));
ac1=sum(c'.*fw(1:ixx))/sum(fw(1:ixx));

%%%-------

function [f0raw,segb]=zf0trackmulti25(p,ac1th,f0jump,nsd,prm)

%       F0candidatesByMix: [2789x3 double]
%    RELofcandidatesByMix: [2789x3 double]
%               RefinedCN: [1x2789 double]
%    FirstAutoCorrelation: [1x2789 double]
%       F0initialEstimate: [2789x1 double]
%    BackgroundNoiselevel: -51.0845
%      InstantaneousPower: [1x2791 double]

f0floor=prm.F0searchLowerBound; % f0floor
f0ceil=prm.F0searchUpperBound; % f0ceil

pwsdb=p.InstantaneousPower;
f0cand=p.F0candidatesByMix;
relv=p.RELofcandidatesByMix;
relv(relv==0)=relv(relv==0)+0.00001;
acv=p.FirstAutoCorrelation;
nn=min(length(pwsdb),length(f0cand));
DispOn=prm.DisplayPlots;
f0jumpt=f0jump;
nsdt=nsd;

if DispOn==1
    figure;
    semilogy(f0cand,'+');grid on;
    axis([0 length(f0cand) f0floor f0ceil]);
    drawnow
    hold on
end;

%---- noiselevel
%pwsdb=10*log10(pws+0.00000000001);
pws=10.0.^(pwsdb/10);
mxpwsdb=max(pwsdb);
[hstgrm,binlvl]=hist(pwsdb,mxpwsdb+(-60:2));
q10=interp1(cumsum(hstgrm+0.000000001)/sum(hstgrm)*100,binlvl,10); % 10% quantile level
[dmy1,minid]=min(abs(q10-binlvl));
%bb=minid+(-5:5); % search range 10 dB
bb=max(1,min(length(binlvl),minid+(-5:5))); % search range 10 dB % safeguard
noiselevel=sum(hstgrm(bb).*binlvl(bb))/sum(hstgrm(bb)); 

%----- mark syllable centers
wsml=81;
pwsdbl=[ones(wsml,1)*pwsdb(1);pwsdb(:);ones(2*wsml,1)*pwsdb(end)];
pwsdbs=fftfilt(hanning(wsml)/sum(hanning(wsml)),pwsdbl);
pwsdbs=pwsdbs((1:length(pwsdb))+round(3*wsml/2));
dpwsdbs=diff([pwsdbs(1);pwsdbs]);
dpwsdbsm=diff([pwsdbs;pwsdbs(end)]);
pv=find((dpwsdbs.*dpwsdbsm<0)&(dpwsdbsm<=0));
dv=find((dpwsdbs.*dpwsdbsm<0)&(dpwsdbsm>0));
%pv=pv(pwsdbs(pv)>(noiselevel+3));
% -------

[nr,nc]=size(f0cand);
nn=min(nr,length(pws));
dv=[1;dv(:);nn]; % safe guard
f0raw0=zeros(nn,1);
relf0=f0raw0;
%f0jump=0.3;
%kk=0;
%lastsegf0=0;
%for ii=1:length(pv)
%    ac1=zfirstac(x,fs,round(pv(ii)/1000*fs),30);
%    if ac1>0.4
%        kk=kk+1;
%        lastsegf0=f0cand(pv(ii),1)+lastsegf0;
%    end;
%end;
%lastsegf0=lastsegf0/kk
%lastsegf0=sum(pws(1:nn)'.*f0cand(1:nn,1))/sum(pws(1:nn));

lastsegf0=2.0^(sum(pws(1:nn)'.*log2(f0cand(1:nn,1)))/sum(pws(1:nn)));

lastpos=1;
segb=zeros(length(pv),1);
finalf0=lastsegf0;
for ii=1:length(pv)
    %    [mxv,mxp]=max(relv((-10:10)+pv(ii),1)); % This OPs may be fragile.
    %    fqs=sort(f0cand((-10:10)+pv(ii),1));
    %    [mxv,mxp]=min(abs(fqs(10)-f0cand((-10:10)+pv(ii),1)));
    %    acp=mxp+pv(ii)-11;
    acp=pv(ii);
    lb=max(dv(dv<acp));
    if lb>lastpos
        lb=lastpos;
    end;
    ub=min(dv(dv>acp));
    if length(lb)==0;lb=1;end;
    if length(ub)==0;ub=nn;end;
    fqs=sort(f0cand(lb:ub,1));
    medianf0=fqs(round((ub-lb)/2));
    [mxv,mxp]=min(abs(lastsegf0-f0cand(max(lb,min(ub,(-10:10)+pv(ii))),1)));
    acp=max(lb,min(ub,mxp+pv(ii)-11));
    f0raw0(acp)=f0cand(acp,1);%f0cand(acp,1);
    lastf0=f0raw0(acp);
    %    ac1=zfirstac(x,fs,round(pv(ii)/1000*fs),30);
    ac1=acv(acp);
    %    lb
    %    if (ub-lb)>12; 
    %        std(diff(log2(f0cand((lb+5):(ub-5),1))))
    %    end;
    segb(ii)=lb;
    forwardind=1;
    if DispOn==1
        semilogy([lb lb],[f0floor f0ceil]);
        semilogy([ub ub],[f0floor f0ceil],'r');
        hf=semilogy(acp,lastf0,'ro');
        set(hf,'MarkerSize',10,'LineWidth',2)
    end;
    %[pv(ii),lb,ub,acp]
    %    lastsegf0=lastf0;
    f0bak=f0raw0;
    f0raw1=f0raw0;
    f0raw2=f0raw0;
    f0raw3=f0raw0;
    [f0rawm,sprob0]=ztraceInAsegment(f0raw0,f0cand,relv,pwsdb,acp,lastf0,lb,ub,nn,f0jumpt,nsdt,noiselevel);
    f0raw1(acp)=f0cand(acp,2);%f0cand(acp,1);
    lastf0=f0raw1(acp);
    [f0raw1,sprob1]=ztraceInAsegment(f0raw1,f0cand,relv,pwsdb,acp,lastf0,lb,ub,nn,f0jumpt,nsdt,noiselevel);
    f0raw2(lb)=f0cand(lb,1);%f0cand(acp,1);
    lastf0=f0raw2(lb);
    [f0raw2,sprob2]=ztraceInAsegment(f0raw2,f0cand,relv,pwsdb,lb,lastf0,lb,ub,nn,f0jumpt,nsdt,noiselevel);
    f0raw2(ub)=f0cand(ub,1);%f0cand(acp,1);
    lastf0=f0raw2(ub);
    [f0raw3,sprob3]=ztraceInAsegment(f0raw3,f0cand,relv,pwsdb,ub,lastf0,lb,ub,nn,f0jumpt,nsdt,noiselevel);
%    f0raw0=f0bak;
%    sprob1=0;
    %[[lb ub]/1000 sprob0 sprob1 sprob2 sprob3]
    [mx,imx]=max([sprob0 sprob1 sprob2 sprob3]);
%    if sprob1>sprob0
%        f0raw0=f0raw1;
%    end;
    switch imx
        case 1
            f0raw0=f0rawm;
        case 2
            f0raw0=f0raw1;
        case 3
            f0raw0=f0raw2;
        case 4
            f0raw0=f0raw3;
    end;
    %[lb ub lastpos finalf0  f0raw0(lb)]
    reliablepowerth=max([noiselevel+10, min([(2*mxpwsdb+noiselevel)/3])]);%, mxpwsdb+max(pwsdb(lb:ub))-5])]); %24/July/2004 #2
    %[lb ub mxpwsdb noiselevel max(pwsdb(lb:ub)) reliablepowerth]
    if (abs(log2(finalf0)-log2(f0raw0(lb)))>0.4)&(ii>1)&(pwsdb(lb)>reliablepowerth) %&(0==1) % (mxpwsdb+noiselevel)/2)
        disp(['hit! at ' num2str(lb)]);
        f0raw4=f0raw0;
        lastf0=f0raw0(lb);
        [f0raw4,sprob4]=ztraceInAsegment(f0raw4,f0cand,relv,pwsdb,lb,lastf0,segb(ii-1),lb,nn,f0jumpt,nsdt,noiselevel);
        %sprob4
        %[ finalf0 f0rawm(lb) f0raw1(lb) f0raw2(lb) f0raw3(lb)]
        %abs(log2(finalf0)-log2([f0rawm(lb) f0raw1(lb) f0raw2(lb) f0raw3(lb)]))
        [secondCand,idsec]=min(abs(log2(finalf0)-log2([f0rawm(lb) f0raw1(lb) f0raw2(lb) f0raw3(lb)])));
        switch idsec
            case 1
                secprob=sprob0;
                f0sec=f0rawm;
            case 2
                secprob=sprob1;
                f0sec=f0raw1;
            case 3
                secprob=sprob2;
                f0sec=f0raw2;
            case 4
                secprob=sprob3;
                f0sec=f0raw3;
        end;
        jprob1=exp(-((log2(finalf0)-log2(f0raw0(lb)))/nsd)^2);
        jprob2=exp(-(secondCand/nsd)^2);
        %[mx*lastprob*jprob1 sprob4*mx lastprob*jprob2*secprob]
        [mx2,imx2]=max([mx*lastprob*jprob1 sprob4*mx lastprob*jprob2*secprob]);
        switch imx2
            case 1
                % do nothing
            case 2
                f0raw0(segb(ii-1):lb)=f0raw4(segb(ii-1):lb);
            case 3
                f0raw0(lb:ub)=f0sec(lb:ub);
        end;
    end;
    lastpos=ub;
    lastprob=mx;
    finalf0=f0raw0(ub);
end;
segb=[segb;nn];
f0raw=f0raw0;

%----
function [f0raw0,sprob]=ztraceInAsegment(f0rawin,f0cand,relv,pwsdb,acp,lastf0in,lb,ub,nn,f0jump,nsd,noiselevel)

forwardind=1;
lastf0=lastf0in;
f0raw0=f0rawin;
maxpower=max(pwsdb); %(pwsdb(acp)+max(pwsdb))/2;
%reliablepowerth=maxpower-12;
%reliablepowerth=(maxpower+3*noiselevel)/4;
reliablepowerth=(2*maxpower+noiselevel)/3; % 23/July/2004
reliablepowerth=(4*pwsdb(acp)+noiselevel)/5; % 24/July/2004
reliablepowerth=max([noiselevel+10, min([(3*maxpower+noiselevel)/4])]);%, max(pwsdb(lb:ub))-5])]); %24/July/2004 #2
sprob=0; % initial probability
if acp==ub;f0raw0(ub)=lastf0in;end;
if acp==lb;f0raw0(lb)=lastf0in;end;
for jj=acp-1:-1:lb
    bsb=max(1,jj:-1:jj-3); % seraching bound
    [dmy,idx]=max(exp(-((log2(f0cand(bsb,:)')-log2(lastf0))/nsd).^2).*(relv(bsb,:)'));
    [dmy2,idxx]=max(dmy);
    idx=idx(idxx);
    jjmx=bsb(idxx);
    if abs(log2(f0cand(jjmx,idx))-log2(lastf0))<f0jump
        dd=abs(jjmx-jj);
        if dd==0;
            f0raw0(jj)=f0cand(jjmx,idx);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;
        else 
            f0raw0(jj)=lastf0+(1/(dd+1))*(f0cand(jjmx,idx)-lastf0);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;%-0.1;end;
        end;
    else
        f0raw0(jj)=lastf0;
        if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2)-10;end;
    end
    lastf0=f0raw0(jj);
end;
lastf0=lastf0in;%f0cand(acp,1);
for jj=acp+1:ub
    bsb=min(nn,jj:jj+3); % seraching bound
    [dmy,idx]=max(exp(-((log2(f0cand(bsb,:)')-log2(lastf0))/nsd).^2).*(relv(bsb,:)'));
    [dmy2,idxx]=max(dmy);
    idx=idx(idxx);
    jjmx=bsb(idxx);
    if abs(log2(f0cand(jjmx,idx))-log2(lastf0))<f0jump
        dd=abs(jjmx-jj);
        if dd==0;
            f0raw0(jj)=f0cand(jjmx,idx);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;
        else 
            f0raw0(jj)=lastf0+(1/(dd+1))*(f0cand(jjmx,idx)-lastf0);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;%-0.1;end;
        end;
    else
        f0raw0(jj)=lastf0;
        if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2)-10;end;
    end
    lastf0=f0raw0(jj);
end;
sprob=2.0.^(sprob/(ub-lb));
%f0raw0(f0raw0==0)=f0raw0(f0raw0==0)+40;

function [f0,pl]=zmultiCandAC(lx,lagspec,beta,lagsp,timesp)
%   F0 candidates extraction from time-lag representation
%   using palabolic interpolation
%   and a new harmonic supression technique
%   [f0,pl]=multiCandAC(lx,lagspec,beta,lagsp,timesp)
%   lx  : lag axis
%   lagspec : time-lag representation
%   beta    : nonlinear distance measure
%   lagsp   : lag smoothing parameter (ms)
%   timesp  : temporal smoothing parameter (ms)
%   output parameters
%   f0  : fundamental frequency (Hz)
%   pl  : peak level

%   Designed and coded by Hideki Kawahara
%   30/March/2004
%   16/June/2004 Peak picking first
%   17/June/2004 Peak selection taking into interaction account

[nr,nc]=size(lagspec);
imm=diff([lagspec(1,:);lagspec]).*(diff([lagspec;lagspec(end,:)]));
dlag=diff([lagspec(1,:);lagspec]);
lagspecz=lagspec;
%lagspecz(lx<0.001,:)=lagspec(lx<0.001,:)*0.0001;
nl=length(lx(lx<0.002));
lagspecz(lx<0.002,:)=lagspecz(lx<0.002,:)-(ones(nc,1)*exp(-(lx(lx<0.002)/0.00055).^2))';

%------ Harmonic supression
mapm=zgendeconvmatrix(nr,0.6);
%lagspecz=max(0,lagspecz-mapm*lagspecz);
lagspecz=log(exp((lagspecz-mapm*lagspecz)*20)+1)/20;
lagspec=lagspecz;
%keyboard;
tls=[lagspecz;lagspecz(end,:);lagspecz(end:-1:2,:)].^beta;

llx=[lx lx(end) lx(end:-1:2)]';
lagw=exp(-(llx/(lagsp/1000)).^2); % This should be propotional to lag.
lagw=lagw/sum(lagw);
flagw=real(fft(lagw));
for ii=1:nc
    tls(:,ii)=real(ifft(fft(tls(:,ii)).*flagw));
end;

tmsm=round((timesp-1)/2)*2+1; % temporal smoothing (ms) assuming shift=1 ms
wt=hanning(tmsm);
wt=wt/sum(wt);
% temporal smoothing using 
lagsms=fftfilt(wt,[zeros(nr,tmsm) tls(1:nr,:) zeros(nr,tmsm)]')';
lagsms=lagsms(:,(1:nc)+(tmsm-1)/2*3);

lagsms=abs(lagsms).^(1/beta);
%figure;imagesc(lagsms);axis('xy');
f0=zeros(nc,3);
pl=zeros(nc,3);
for ii=1:nc
    ix=find((imm(:,ii)<0)&(dlag(:,ii)>0));
    [mx,mxp]=max(lagsms(ix,ii));
    [pl(ii,1),pos]=ParabolicInterp(lagspec((-1:1)+ix(mxp),ii),ix(mxp));
    f0(ii,1)=pos/lx(2);
    if length(ix)>1
        lagsms(ix(mxp),ii)=lagsms(ix(mxp),ii)*0;
        [mx,mxp]=max(lagsms(ix,ii));
        [pl(ii,2),pos]=ParabolicInterp(lagspec((-1:1)+ix(mxp),ii),ix(mxp));
        f0(ii,2)=pos/lx(2);
        if length(ix)>2
            lagsms(ix(mxp),ii)=lagsms(ix(mxp),ii)*0;
            [mx,mxp]=max(lagsms(ix,ii));
            [pl(ii,3),pos]=ParabolicInterp(lagspec((-1:1)+ix(mxp),ii),ix(mxp));
            f0(ii,3)=pos/lx(2);
        else
            f0(ii,3)=f0(ii,2);pl(ii,3)=pl(ii,2);
        end;
    else
        f0(ii,2)=f0(ii,1);pl(ii,2)=pl(ii,1);
    end;
end;

function [val,pos]=ParabolicInterp(yv,xo)
lp=diff(yv);
a=lp(1)-lp(2);
b=(lp(1)+lp(2))/2;
xp=b/a+xo;
val=yv(2)+0.5*a*(b/a)^2+b*(b/a);
if xp>max(xo)+1
    xp=max(xo)+1;
    val=yv(end);
end;
if xp<min(xo)-1
    xp=min(xo)-1;
    val=yv(1);
end;
pos=1/(xp-1);

function mapm=zgendeconvmatrix(n,a);
%   function mapm=gendeconvmatrix(n,a);
%   n   : size of the matrix
%   a   : reductio ncoefficient

mapm=zeros(n,n);
for ii=3:n
    for k=[2 3 5]
        bet=(ii-1)/k+1;
        lbet=floor(bet);
        ubet=lbet+1;
        mapm(ii,lbet)=mapm(ii,lbet)+(1-(bet-lbet))*a^(k-1);
        mapm(ii,ubet)=mapm(ii,ubet)+(1-(ubet-bet))*a^(k-1);
    end;
end;

%%%--------------
function [f0,rel,cseg]=zcontiguousSegment4(p,strel,endrel,endrel2,prm)
%   Selecting contiguous reliable voiced segments
%   [f0,rel,cseg]=contiguousSegment(p,strel,endrel)
%   p   : structure, initial analysis results
%   strel   : reliability threshold for start search
%   endrel  : reliability threshold for terminate search

%   Designed and coded by Hideki Kawahara
%   27/July/2004

f0v=p.F0candidatesByMix;
f0cand=f0v;
relv=p.RELofcandidatesByMix;
pwrdb=p.InstantaneousPower;
%pwsdb=pwrdb;
f0jumpt=prm.MaxumumPermissibleOctaveJump;
nsdt=prm.SDforTrackingNormalization;

%---- noiselevel
%pwsdb=10*log10(pws+0.00000000001);
pws=10.0.^(pwrdb/10);
mxpwsdb=max(pwrdb);
[hstgrm,binlvl]=hist(pwrdb,mxpwsdb+(-60:2));
q10=interp1(cumsum(hstgrm+0.000000001)/sum(hstgrm)*100,binlvl,10); % 10% quantile level
[dmy1,minid]=min(abs(q10-binlvl));
%bb=minid+(-5:5); % search range 10 dB
bb=max(1,min(length(binlvl),minid+(-5:5))); % search range 10 dB % safeguard
noiselevel=sum(hstgrm(bb).*binlvl(bb))/sum(hstgrm(bb)); 

%noiselevel=p.BackgroundNoiselevel;
stpwr=(max(pwrdb)+noiselevel)/2;
endpwrrel=(max(pwrdb)+2*noiselevel)/3;
endpwr=noiselevel;

nseg=0;
[nr,nc]=size(f0v);
f0=zeros(nr,1);
rel=zeros(nr,1);
f0raw0=f0;

cpos=1;
lastpos=1;
while cpos<nr
    if (relv(cpos,1)>strel) & (pwrdb(cpos)>stpwr)
        nseg=nseg+1;
        %--- forward search for maximum liliable point
        bp=cpos;ep=bp;
        for ii=cpos:nr
            if ((relv(ii,1)<endrel) & (pwrdb(ii)<endpwrrel))|(relv(ii,1)<endrel2)
                break;
            else
                ep=ii;
            end;
        end;
        [mxr,ixmx]=max(relv(bp:ep,1));
        cpos=bp+ixmx-1;
        f0bak=f0raw0;
        f0raw1=f0raw0;
        f0raw2=f0raw0;
        f0raw3=f0raw0;
        f0raw0(cpos)=f0cand(cpos,1);
        lastf0=f0cand(cpos,1);
        [f0rawm,sprob0]=ztraceInAsegment2(f0raw0,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nr,f0jumpt,nsdt,noiselevel);
        f0raw1(cpos)=f0cand(cpos,2);%f0cand(acp,1);
        lastf0=f0raw1(cpos);
        [f0raw1,sprob1]=ztraceInAsegment2(f0raw1,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nr,f0jumpt,nsdt,noiselevel);
        f0raw2(bp)=f0cand(bp,1);%f0cand(acp,1);
        lastf0=f0raw2(bp);
        [f0raw2,sprob2]=ztraceInAsegment2(f0raw2,f0cand,relv,pwrdb,bp,lastf0,bp,ep,nr,f0jumpt,nsdt,noiselevel);
        f0raw3(ep)=f0cand(ep,1);%f0cand(acp,1);
        lastf0=f0raw3(ep);
        [f0raw3,sprob3]=ztraceInAsegment2(f0raw3,f0cand,relv,pwrdb,ep,lastf0,bp,ep,nr,f0jumpt,nsdt,noiselevel);
        %    f0raw0=f0bak;
        %    sprob1=0;
        %[[lb ub]/1000 sprob0 sprob1 sprob2 sprob3]
        [mx,imx]=max([sprob0 sprob1 sprob2 sprob3]);
        %    if sprob1>sprob0
        %        f0raw0=f0raw1;
        %    end;
        %display([num2str(imx) ' in (' num2str(bp,7) ':' num2str(ep,7) ') with ' num2str(cpos,7) ])
        switch imx
            case 1
                f0raw0=f0rawm;
            case 2
                f0raw0=f0raw1;
            case 3
                f0raw0=f0raw2;
            case 4
                f0raw0=f0raw3;
        end;
        f0(bp:ep)=f0raw0(bp:ep);
        %if max(abs(diff(log2(f0(bp:ep)))))>0.1
        %    disp(['disjoint! at ' num2str(bp,7) ':' num2str(ep,7) ])
        %end;
        for ii=bp:ep-1
            if abs(log2(f0(ii))-log2(f0(ii+1)))>0.1
                display(['disjoint at ' num2str(ii,7) ' (ms) in (' num2str(bp,7) ':' num2str(ep,7) ')']);
                ep=ii;
                break
            end;
        end;
        cpos=bp;
        %f0(cpos)=f0v(cpos,1);
        lastf0=f0(cpos);
        [mx,ix]=min(abs(log2(lastf0)-log2(f0v(cpos,:))));
        rel(cpos)=relv(cpos,ix);
        cseg(nseg,1)=cpos;
        for ii=max(lastpos,cpos-1):-1:lastpos % backward search
            [mx,ix]=min(abs(log2(lastf0)-log2(f0v(ii,:))));
            if (mx>0.1)|(((relv(ii,1)<endrel) & (pwrdb(ii)<endpwr))|(relv(ii,1)<endrel2))
                break;
            else
                f0(ii)=f0v(ii,ix);
                rel(ii)=relv(ii,ix);
                lastf0=f0(ii);
                cseg(nseg,1)=ii;
            end;
        end;
        cpos=ep;
        %f0(cpos)=f0(cpos);
        lastf0=f0(cpos);
        [mx,ix]=min(abs(log2(lastf0)-log2(f0v(cpos,:))));
        rel(cpos)=relv(cpos,ix);
        cseg(nseg,2)=cpos+1;
        for ii=min(nr,cpos+1):nr
            [mx,ix]=min(abs(log2(lastf0)-log2(f0v(ii,:))));
            if (mx>0.1)|(((relv(ii,1)<endrel) & (pwrdb(ii)<endpwr))|(relv(ii,1)<endrel2))
                cseg(nseg,2)=ii-1;
                cpos=ii+1;
                break;
            else
                f0(ii)=f0v(ii,ix);
                rel(ii)=relv(ii,ix);
                lastf0=f0(ii);
                cseg(nseg,2)=ii;
                cpos=ii;
            end;
        end;
        lastpos=cpos;
    else
        cpos=cpos+1;
    end;
end;

%%%---------------
function [f0c,relc]=zfillf0gaps6(p,f0,rel,cseg,prm)

f0c=f0;
relc=rel;
f0v=p.F0candidatesByMix;
f0cand=f0v;
relv=p.RELofcandidatesByMix;
pwrdb=p.InstantaneousPower;
%pwsdb=pwrdb;
f0jumpt=prm.MaxumumPermissibleOctaveJump;
nsdt=prm.SDforTrackingNormalization;

%---- noiselevel
%pwsdb=10*log10(pws+0.00000000001);
pws=10.0.^(pwrdb/10);
mxpwsdb=max(pwrdb);
[hstgrm,binlvl]=hist(pwrdb,mxpwsdb+(-60:2));
q10=interp1(cumsum(hstgrm+0.000000001)/sum(hstgrm)*100,binlvl,10); % 10% quantile level
[dmy1,minid]=min(abs(q10-binlvl));
%bb=minid+(-5:5); % search range 10 dB
bb=max(1,min(length(binlvl),minid+(-5:5))); % search range 10 dB % safeguard
noiselevel=sum(hstgrm(bb).*binlvl(bb))/sum(hstgrm(bb)); 

[nr,nc]=size(cseg);
nf0=length(f0);
lb=1;
f0raw0=f0;
for ii=1:nr;
    %lastf0=f0(cseg(ii,1));
    if ii>nr
        ub=length(f0);
    else
        ub=min(length(f0),cseg(ii,1));
    end;
    if ii==1
        lb=1;
    elseif ii>nr
        lb=max(1,cseg(ii-1,2));
    else
        lb=round((cseg(ii,1)+cseg(ii-1,2))/2);
    end;
    [mxr,ixmx]=max(relv(lb:ub,1));
    cpos=lb+ixmx-1;
    bp=lb;ep=ub;
    f0bak=f0raw0;
    f0raw1=f0raw0;
    f0raw2=f0raw0;
    f0raw3=f0raw0;
    f0raw0(cpos)=f0cand(cpos,1);
    lastf0=f0cand(cpos,1);
    [f0rawm,sprob0]=ztraceInAsegment2(f0raw0,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
    f0raw1(cpos)=f0cand(cpos,2);%f0cand(acp,1);
    lastf0=f0raw1(cpos);
    [f0raw1,sprob1]=ztraceInAsegment2(f0raw1,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
    f0raw2(bp)=f0cand(bp,1);%f0cand(acp,1);
    lastf0=f0raw2(bp);
    [f0raw2,sprob2]=ztraceInAsegment2(f0raw2,f0cand,relv,pwrdb,bp,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
    f0raw3(ep)=f0(ep);%f0cand(acp,1);
    lastf0=f0raw3(ep);
    [f0raw3,sprob3]=ztraceInAsegment2(f0raw3,f0cand,relv,pwrdb,ep,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
    %    f0raw0=f0bak;
    %    sprob1=0;
    %[[lb ub]/1000 sprob0 sprob1 sprob2 sprob3]
    [mx,imx]=max([sprob0 sprob1 sprob2 sprob3]);
    %    if sprob1>sprob0
    %        f0raw0=f0raw1;
    %    end;
    switch imx
        case 1
            f0raw0=f0rawm;
        case 2
            f0raw0=f0raw1;
        case 3
            f0raw0=f0raw2;
        case 4
            f0raw0=f0raw3;
    end;
    f0raw0=f0raw3;
    f0c(bp:ep)=f0raw0(bp:ep);
    lb=cseg(ii,2);
    if ii<nr
        ub=round((cseg(ii,2)+cseg(ii+1,1))/2);
    else
        ub=length(f0);
    end;
    [mxr,ixmx]=max(relv(lb:ub,1));
    cpos=lb+ixmx-1;
    bp=lb;ep=ub;
    f0bak=f0raw0;
    f0raw1=f0raw0;
    f0raw2=f0raw0;
    f0raw3=f0raw0;
    f0raw0(cpos)=f0cand(cpos,1);
    lastf0=f0cand(cpos,1);
    [f0rawm,sprob0]=ztraceInAsegment2(f0raw0,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
    f0raw1(cpos)=f0cand(cpos,2);%f0cand(acp,1);
    lastf0=f0raw1(cpos);
    [f0raw1,sprob1]=ztraceInAsegment2(f0raw1,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
    f0raw2(bp)=f0(bp);%f0cand(acp,1);
    lastf0=f0raw2(bp);
    [f0raw2,sprob2]=ztraceInAsegment2(f0raw2,f0cand,relv,pwrdb,bp,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
    f0raw3(ep)=f0cand(ep,1);%f0cand(acp,1);
    lastf0=f0raw3(ep);
    [f0raw3,sprob3]=ztraceInAsegment2(f0raw3,f0cand,relv,pwrdb,ep,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
    %    f0raw0=f0bak;
    %    sprob1=0;
    %[[lb ub]/1000 sprob0 sprob1 sprob2 sprob3]
    [mx,imx]=max([sprob0 sprob1 sprob2 sprob3]);
    %    if sprob1>sprob0
    %        f0raw0=f0raw1;
    %    end;
    switch imx
        case 1
            f0raw0=f0rawm;
        case 2
            f0raw0=f0raw1;
        case 3
            f0raw0=f0raw2;
        case 4
            f0raw0=f0raw3;
    end;
    f0raw0=f0raw2;
    f0c(bp:ep)=f0raw0(bp:ep);
end;

function [f0raw0,sprob]=ztraceInAsegment2(f0rawin,f0cand,relv,pwsdb,acp,lastf0in,lb,ub,nn,f0jump,nsd,noiselevel)

forwardind=1;
lastf0=lastf0in;
f0raw0=f0rawin;
maxpower=max(pwsdb); %(pwsdb(acp)+max(pwsdb))/2;
%reliablepowerth=maxpower-12;
%reliablepowerth=(maxpower+3*noiselevel)/4;
reliablepowerth=(2*maxpower+noiselevel)/3; % 23/July/2004
reliablepowerth=(4*pwsdb(acp)+noiselevel)/5; % 24/July/2004
reliablepowerth=max([noiselevel+10, min([(3*maxpower+noiselevel)/4])]);%, max(pwsdb(lb:ub))-5])]); %24/July/2004 #2
sprob=0; % initial probability
if acp==ub;f0raw0(ub)=lastf0in;end;
if acp==lb;f0raw0(lb)=lastf0in;end;
for jj=acp-1:-1:lb
    bsb=max(1,jj:-1:jj-5); % seraching bound
    [dmy,idx]=max(exp(-((log2(f0cand(bsb,:)')-log2(lastf0))/nsd).^2).*(relv(bsb,:)'));
    [dmy2,idxx]=max(dmy);
    idx=idx(idxx);
    jjmx=bsb(idxx);
    if abs(log2(f0cand(jjmx,idx))-log2(lastf0))<f0jump
        dd=abs(jjmx-jj);
        if dd==0;
            f0raw0(jj)=f0cand(jjmx,idx);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;
        else 
            f0raw0(jj)=lastf0+(1/(dd+1))*(f0cand(jjmx,idx)-lastf0);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;%-0.1;end;
        end;
    else
        f0raw0(jj)=lastf0;
        if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2)-10;end;
    end
    lastf0=f0raw0(jj);
end;
lastf0=lastf0in;%f0cand(acp,1);
for jj=acp+1:ub
    bsb=min(nn,jj:jj+5); % seraching bound
    [dmy,idx]=max(exp(-((log2(f0cand(bsb,:)')-log2(lastf0))/nsd).^2).*(relv(bsb,:)'));
    [dmy2,idxx]=max(dmy);
    idx=idx(idxx);
    jjmx=bsb(idxx);
    if abs(log2(f0cand(jjmx,idx))-log2(lastf0))<f0jump
        dd=abs(jjmx-jj);
        if dd==0;
            f0raw0(jj)=f0cand(jjmx,idx);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;
            %fprintf(1,'1');
        else 
            f0raw0(jj)=lastf0+(1/(dd+1))*(f0cand(jjmx,idx)-lastf0);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;%-0.1;end;
            %fprintf(1,'2');
        end;
    else
        f0raw0(jj)=lastf0;
        if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2)-10;end;
        %fprintf(1,'3');
    end
    lastf0=f0raw0(jj);
end;
sprob=2.0.^(sprob/(ub-lb+1)); % fix (+1) on 11/Jan./05

%%%------
function [f0,rel,cseg]=zcontiguousSegment5(p,strel,endrel,endrel2,prm)
%   Selecting contiguous reliable voiced segments
%   [f0,rel,cseg]=contiguousSegment(p,strel,endrel)
%   p   : structure, initial analysis results
%   strel   : reliability threshold for start search
%   endrel  : reliability threshold for terminate search

%   Designed and coded by Hideki Kawahara
%   27/July/2004

f0v=p.F0candidatesByMix;
f0cand=f0v;
relv=p.RELofcandidatesByMix;
pwrdb=p.InstantaneousPower;
%pwsdb=pwrdb;
f0jumpt=prm.MaxumumPermissibleOctaveJump;
nsdt=prm.SDforTrackingNormalization;

%---- noiselevel
%pwsdb=10*log10(pws+0.00000000001);
pws=10.0.^(pwrdb/10);
mxpwsdb=max(pwrdb);
[hstgrm,binlvl]=hist(pwrdb,mxpwsdb+(-60:2));
q10=interp1(cumsum(hstgrm+0.000000001)/sum(hstgrm)*100,binlvl,10); % 10% quantile level
[dmy1,minid]=min(abs(q10-binlvl));
%bb=minid+(-5:5); % search range 10 dB
bb=max(1,min(length(binlvl),minid+(-5:5))); % search range 10 dB % safeguard
noiselevel=sum(hstgrm(bb).*binlvl(bb))/sum(hstgrm(bb)); 

%noiselevel=p.BackgroundNoiselevel;
stpwr=(max(pwrdb)+noiselevel)/2;
endpwrrel=(max(pwrdb)+2*noiselevel)/3;
endpwr=noiselevel;

nseg=0;
[nr,nc]=size(f0v);
f0=zeros(nr,1);
rel=zeros(nr,1);
f0raw0=f0;

cpos=1;
lastpos=1;
while cpos<nr
    if (relv(cpos,1)>strel) & (pwrdb(cpos)>stpwr)
        nseg=nseg+1;
        %--- forward search for maximum liliable point
        bp=cpos;ep=bp;
        for ii=cpos:nr
            if ((relv(ii,1)<endrel) & (pwrdb(ii)<endpwrrel))|(relv(ii,1)<endrel2)
                break;
            else
                ep=ii;
            end;
        end;
        [mxr,ixmx]=max(relv(bp:ep,1));
        cpos=bp+ixmx-1;
        f0bak=f0raw0;
        f0raw1=f0raw0;
        f0raw2=f0raw0;
        f0raw3=f0raw0;
        f0raw0(cpos)=f0cand(cpos,1);
        lastf0=f0cand(cpos,1);
        [f0rawm,sprob0]=ztraceInAsegment3(f0raw0,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nr,f0jumpt,nsdt/2,endpwrrel);
        f0raw1(cpos)=f0cand(cpos,2);%f0cand(acp,1);
        lastf0=f0raw1(cpos);
        [f0raw1,sprob1]=ztraceInAsegment3(f0raw1,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nr,f0jumpt,nsdt/2,endpwrrel);
        f0raw2(bp)=f0cand(bp,1);%f0cand(acp,1);
        lastf0=f0raw2(bp);
        [f0raw2,sprob2]=ztraceInAsegment3(f0raw2,f0cand,relv,pwrdb,bp,lastf0,bp,ep,nr,f0jumpt,nsdt/2,endpwrrel);
        f0raw3(ep)=f0cand(ep,1);%f0cand(acp,1);
        lastf0=f0raw3(ep);
        [f0raw3,sprob3]=ztraceInAsegment3(f0raw3,f0cand,relv,pwrdb,ep,lastf0,bp,ep,nr,f0jumpt,nsdt/2,endpwrrel);
        %    f0raw0=f0bak;
        %    sprob1=0;
        %[[lb ub]/1000 sprob0 sprob1 sprob2 sprob3]
        [mx,imx]=max([sprob0 sprob1 sprob2 sprob3]);
        %    if sprob1>sprob0
        %        f0raw0=f0raw1;
        %    end;
        %display([num2str(imx) ' in (' num2str(bp,7) ':' num2str(ep,7) ') with ' num2str(cpos,7) ])
        switch imx
            case 1
                f0raw0=f0rawm;
            case 2
                f0raw0=f0raw1;
            case 3
                f0raw0=f0raw2;
            case 4
                f0raw0=f0raw3;
        end;
        f0(bp:ep)=f0raw0(bp:ep);
        %if max(abs(diff(log2(f0(bp:ep)))))>0.1
        %    disp(['disjoint! at ' num2str(bp,7) ':' num2str(ep,7) ])
        %end;
        for ii=bp:ep-1
            if abs(log2(f0(ii))-log2(f0(ii+1)))>0.1
                display(['disjoint at ' num2str(ii,7) ' (ms) in (' num2str(bp,7) ':' num2str(ep,7) ')']);
                ep=ii;
                break
            end;
        end;
        cpos=bp;
        %f0(cpos)=f0v(cpos,1);
        lastf0=f0(cpos);
        [mx,ix]=min(abs(log2(lastf0)-log2(f0v(cpos,:))));
        rel(cpos)=relv(cpos,ix);
        cseg(nseg,1)=cpos;
        for ii=max(lastpos,cpos-1):-1:lastpos % backward search
            [mx,ix]=min(abs(log2(lastf0)-log2(f0v(ii,:))));
            if (mx>0.1)|(((relv(ii,1)<endrel) & (pwrdb(ii)<endpwr))|(relv(ii,1)<endrel2))
                break;
            else
                f0(ii)=f0v(ii,ix);
                rel(ii)=relv(ii,ix);
                lastf0=f0(ii);
                cseg(nseg,1)=ii;
            end;
        end;
        cpos=ep;
        %f0(cpos)=f0(cpos);
        lastf0=f0(cpos);
        [mx,ix]=min(abs(log2(lastf0)-log2(f0v(cpos,:))));
        rel(cpos)=relv(cpos,ix);
        cseg(nseg,2)=cpos+1;
        for ii=min(nr,cpos+1):nr
            [mx,ix]=min(abs(log2(lastf0)-log2(f0v(ii,:))));
            if (mx>0.1)|(((relv(ii,1)<endrel) & (pwrdb(ii)<endpwr))|(relv(ii,1)<endrel2))
                cseg(nseg,2)=ii-1;
                cpos=ii+1;
                break;
            else
                f0(ii)=f0v(ii,ix);
                rel(ii)=relv(ii,ix);
                lastf0=f0(ii);
                cseg(nseg,2)=ii;
                cpos=ii;
            end;
        end;
        lastpos=cpos;
    else
        cpos=cpos+1;
    end;
end;

function [f0raw0,sprob]=ztraceInAsegment3(f0rawin,f0cand,relv,pwsdb,acp,lastf0in,lb,ub,nn,f0jump,nsd,reliablepowerth)

forwardind=1;
lastf0=lastf0in;
f0raw0=f0rawin;
maxpower=max(pwsdb); %(pwsdb(acp)+max(pwsdb))/2;
%reliablepowerth=maxpower-12;
%reliablepowerth=(maxpower+3*noiselevel)/4;
%reliablepowerth=(2*maxpower+noiselevel)/3; % 23/July/2004
%reliablepowerth=(4*pwsdb(acp)+noiselevel)/5; % 24/July/2004
%reliablepowerth=max([noiselevel+10, min([(3*maxpower+noiselevel)/4])]);%, max(pwsdb(lb:ub))-5])]); %24/July/2004 #2
sprob=0; % initial probability
if acp==ub;f0raw0(ub)=lastf0in;end;
if acp==lb;f0raw0(lb)=lastf0in;end;
for jj=acp-1:-1:lb
    bsb=max(1,jj:-1:jj-5); % seraching bound
    [dmy,idx]=max(exp(-((log2(f0cand(bsb,:)')-log2(lastf0))/nsd).^2).*(relv(bsb,:)'));
    [dmy2,idxx]=max(dmy);
    idx=idx(idxx);
    jjmx=bsb(idxx);
    if abs(log2(f0cand(jjmx,idx))-log2(lastf0))<f0jump
        dd=abs(jjmx-jj);
        if dd==0;
            f0raw0(jj)=f0cand(jjmx,idx);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;
        else 
            f0raw0(jj)=lastf0+(1/(dd+1))*(f0cand(jjmx,idx)-lastf0);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;%-0.1;end;
        end;
    else
        f0raw0(jj)=lastf0;
        if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2)-10;end;
    end
    lastf0=f0raw0(jj);
end;
lastf0=lastf0in;%f0cand(acp,1);
for jj=acp+1:ub
    bsb=min(nn,jj:jj+5); % seraching bound
    [dmy,idx]=max(exp(-((log2(f0cand(bsb,:)')-log2(lastf0))/nsd).^2).*(relv(bsb,:)'));
    [dmy2,idxx]=max(dmy);
    idx=idx(idxx);
    jjmx=bsb(idxx);
    if abs(log2(f0cand(jjmx,idx))-log2(lastf0))<f0jump
        dd=abs(jjmx-jj);
        if dd==0;
            f0raw0(jj)=f0cand(jjmx,idx);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;
        else 
            f0raw0(jj)=lastf0+(1/(dd+1))*(f0cand(jjmx,idx)-lastf0);
            if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2);end;%-0.1;end;
        end;
    else
        f0raw0(jj)=lastf0;
        if pwsdb(jj)>reliablepowerth;sprob=sprob+log2(dmy2)-10;end;
    end
    lastf0=f0raw0(jj);
end;
sprob=2.0.^(sprob/((ub-lb)+1));

%%%-----
function [f0,rel,cseg]=zcontiguousSegment10(p,prm)
%   This version was revised from 808.
%   Further refinement for additional scan

f0floor=prm.F0searchLowerBound; % f0floor
f0ceil=prm.F0searchUpperBound; % f0ceil

pwsdb=p.InstantaneousPower;
f0cand=p.F0candidatesByMix;
relv=p.RELofcandidatesByMix;
pwrdb=p.InstantaneousPower;

relv(relv==0)=relv(relv==0)+0.00001;
f0jumpt=prm.MaxumumPermissibleOctaveJump;
nsdt=prm.SDforTrackingNormalization;

nn=min(length(pwsdb),length(f0cand));
pwsdb=pwsdb(1:nn);
f0cand=f0cand(1:nn,:);
relv=relv(1:nn,:);
DispOn=prm.DisplayPlots;

cseg=[];

%---- noiselevel
%pwsdb=10*log10(pws+0.00000000001);
pws=10.0.^(pwsdb/10);
mxpwsdb=max(pwsdb);
[hstgrm,binlvl]=hist(pwsdb,mxpwsdb+(-60:2));
q10=interp1(cumsum(hstgrm+0.000000001)/sum(hstgrm)*100,binlvl,10); % 10% quantile level
[dmy1,minid]=min(abs(q10-binlvl));
%bb=minid+(-5:5); % search range 10 dB
bb=max(1,min(length(binlvl),minid+(-5:5))); % search range 10 dB % safeguard
noiselevel=sum(hstgrm(bb).*binlvl(bb))/sum(hstgrm(bb)); 
wellovernoize=(4*noiselevel+mxpwsdb)/5;
if wellovernoize>mxpwsdb-10;
    wellovernoize=mxpwsdb-10;
    noiselevel=(5*wellovernoize-mxpwsdb)/4;
end; % safeguard 25/Sept./2004

%---- search for contiguous segments that consists of best candidates
f0=f0cand(:,1)*0;
rel=relv(:,1)*0;

maskr=f0cand*0+1; % masker for preventing multiple assignment
[dmy,idx]=sort(-relv(:,1));
idx=idx(-dmy>0.16);
if DispOn
    figure
    semilogy(f0cand(:,1),'c');grid on;
    axis([0 nn f0floor f0ceil]);
    hold on
    drawnow
end;
nseg=0;
segv=zeros(length(idx),2);
sratev=zeros(length(idx),1);
for ii=1:length(idx);
    if (maskr(idx(ii),1)>0) & (pwsdb(idx(ii))>wellovernoize)
        [f0seg,relseg,lb,ub,srate,maskr]=zsearchforContiguousSegment(f0cand,relv,maskr,idx(ii),pwsdb,noiselevel);
        if (length(f0seg)>0) & (srate>0.12)  & ((ub-lb+1)>13)
            nseg=nseg+1;
            segv(nseg,:)=[lb ub];
            segstr(nseg).f0Segment=f0seg(lb:ub);
            segstr(nseg).reliabilitySegment=relseg(lb:ub);
            sratev(nseg)=srate*(1-1/max(1.4,sqrt((ub-lb+1)/40))); % reliability with DF normalization
            if DispOn
                disp(['Segment (' num2str(lb,7) ':' num2str(ub,7) ') with rel=' num2str(srate)]);
                semilogy(lb:ub,f0seg(lb:ub));drawnow;
            end;
        end;
    end;
end;
segv=segv(1:nseg,:);
sratev=sratev(1:nseg);
[relsrt,idrel]=sort(-sratev);
if DispOn
    hold off
    figure
    semilogy(f0cand(:,1),'c');grid on;
    axis([0 nn f0floor f0ceil]);
    hold on
    drawnow
end;
for ii=1:nseg
    icp=idrel(ii);
    lb=segv(icp,1); ub=segv(icp,2);
    validind=(sum(f0(lb:ub)>0)==0);
    if validind;f0(lb:ub)=segstr(icp).f0Segment;rel(lb:ub)=segstr(icp).reliabilitySegment;end;
    if DispOn & validind
        semilogy(lb:ub,segstr(icp).f0Segment);drawnow;
        %pause;
    end;
end;
%---- scan and reorganize segments
InInd=0;
cseg=zeros(nseg,2);
crseg=0;
for ii=1:nn
    if (InInd==0) & (f0(ii)>0)
        crseg=crseg+1;
        cseg(crseg,1)=ii;
        InInd=1;
    elseif (InInd==1) & (f0(ii)==0) | ((sum((ii-1)==segv(:,2))>0) & (pwsdb(ii)<(noiselevel+4*mxpwsdb)/5)) % mod 09/Aug./04
        cseg(crseg,2)=ii-1;
        InInd=0;
    end;
end;
if cseg(crseg,2)==0;cseg(crseg,2)=nn;end;
cseg=cseg(1:crseg,:);

%---- check for each segment if it is contiguous enough
nf0=length(f0);
for ii=1:crseg
    lb=cseg(ii,1);ub=cseg(ii,2);
    maxjmp=max(abs(diff(log2(f0(lb:ub)))));
    if maxjmp>0.4
        disp(['Discontinuity in (' num2str(lb,7) ':' num2str(ub,7) '), Max jump=' num2str(maxjmp,7) ' oct.'])
        f0raw0=f0;
        [dmy,ix]=max(relv(lb:ub,:)');
        [dmy2,ixmx]=max(dmy);
        cpos=lb+ixmx-1;
        bp=lb;ep=ub;
        f0bak=f0raw0;
        f0raw1=f0raw0;
        f0raw2=f0raw0;
        f0raw3=f0raw0;
        f0raw0(cpos)=f0cand(cpos,1);
        lastf0=f0cand(cpos,1);
        [f0rawm,sprob0]=ztraceInAsegment2(f0raw0,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
        f0raw1(cpos)=f0cand(cpos,2);%f0cand(acp,1);
        lastf0=f0raw1(cpos);
        [f0raw1,sprob1]=ztraceInAsegment2(f0raw1,f0cand,relv,pwrdb,cpos,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
        f0raw2(bp)=f0(bp);%f0cand(acp,1);
        lastf0=f0raw2(bp);
        [f0raw2,sprob2]=ztraceInAsegment2(f0raw2,f0cand,relv,pwrdb,bp,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
        f0raw3(ep)=f0cand(ep,1);%f0cand(acp,1);
        lastf0=f0raw3(ep);
        [f0raw3,sprob3]=ztraceInAsegment2(f0raw3,f0cand,relv,pwrdb,ep,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
        [mx,imx]=max([sprob0 sprob1 sprob2 sprob3]);
        switch imx
            case 1
                f0raw0=f0rawm;
            case 2
                f0raw0=f0raw1;
            case 3
                f0raw0=f0raw2;
            case 4
                f0raw0=f0raw3;
        end;
        f0(lb:ub)=f0raw0(lb:ub);
    end;
end;

%---- get robust distribution and check for anomalies
[hgf0,ixf]=sort(log2(f0(f0>0)));
id10=round(0.1*length(hgf0));
id90=round(0.9*length(hgf0));
rsd=std(hgf0(id10:id90));
mf0=mean(hgf0(id10:id90));
csego=cseg;
cseg=cseg*0;
nseg=0;
f0o=f0;
f0=f0*0;
for ii=1:crseg
    lb=csego(ii,1);ub=csego(ii,2);
    if abs(mean(log2(f0o(lb:ub)))-mf0)<min(1.2,max(0.9,5*rsd)) & mean(pwrdb(lb:ub))>(2*noiselevel+mxpwsdb)/3;
        nseg=nseg+1;
        cseg(nseg,1)=lb;
        cseg(nseg,2)=ub;
        f0(lb:ub)=f0o(lb:ub);
    end;
end;
cseg=cseg(1:nseg,:);

%---- check for isolated small segments
segv=cseg;
cseg=cseg*0;
nseg=0;
f0bk=f0;
f0=f0*0;
f0bk(1)=1;
lastend=1;
[nrseg,ncseg]=size(cseg); % bug fix, 31/Aug./2004
for ii=1:nrseg
    lb=segv(ii,1);ub=segv(ii,2);
    if ii<nrseg
        nexttop=segv(ii+1,1);
    else
        %nexttop=nn;
        nexttop=ub; % bug fix, 11/Jan./2005
    end;
    ipause=(lb-lastend+1);fpause=(nexttop-ub+1);
    if ((ipause<50) | (fpause<50)) & abs(log2(f0bk(lastend))-log2(f0bk(lb)))>0.6 ...
            & abs(log2(f0bk(ub))-log2(f0bk(nexttop)))>0.6 & (ub-lb+1)<50 & mean(relseg(lb:ub))<0.5
        %do nothing
    else
        nseg=nseg+1;
        f0(lb:ub)=f0bk(lb:ub);
        cseg(nseg,:)=[lb ub];
    end;
    lastend=ub;
end;
cseg=cseg(1:nseg,:);
crseg=nseg;

%---- check for dominant peaks if it is selected as a voiced segment
%----- mark syllable centers
wsml=81;
pwsdbl=[ones(wsml,1)*pwsdb(1);pwsdb(:);ones(2*wsml,1)*pwsdb(end)];
pwsdbs=fftfilt(hanning(wsml)/sum(hanning(wsml)),pwsdbl);
pwsdbs=pwsdbs((1:length(pwsdb))+round(3*wsml/2));
dpwsdbs=diff([pwsdbs(1);pwsdbs]);
dpwsdbsm=diff([pwsdbs;pwsdbs(end)]);
pv=find((dpwsdbs.*dpwsdbsm<0)&(dpwsdbsm<=0));
dv=find((dpwsdbs.*dpwsdbsm<0)&(dpwsdbsm>0));
%pv=pv(pwsdbs(pv)>(noiselevel+3));
% -------

f0raw0=f0cand(:,1);
avf0=mean(f0(f0>0));
logavf0=log2(avf0);
relv2=relv.*exp(-((log2(f0cand)-logavf0)/1).^2);
reliablelevel=(noiselevel+2*mxpwsdb)/3;
for ii=1:length(pv)
    if pwsdb(pv(ii)) > reliablelevel
        if f0(pv(ii))==0
            disp(['Missing dominant segment that is centered at:' num2str(pv(ii),7) ' (ms)']);
            lb=max(dv(dv<pv(ii)));
            if length(lb)==0;lb=1;end;
            ub=min(dv(dv>pv(ii)));
            if length(ub)==0;ub=nn;end;
            bp=lb;ep=ub;
            peaklvl=pwsdb(pv(ii));
            for bp=pv(ii)-1:-1:lb
                if pwsdb(bp) < peaklvl-9; break;end;
            end;
            for ep=pv(ii)+1:ub
                if pwsdb(ep) < peaklvl-9; break;end;
            end;
            disp(['segment (' num2str(bp,7) ':' num2str(ep,7) ') is isolated.']);
            lb=bp;ub=ep;
            [mx,imx]=max(relv2(lb:ub,:)');
            [mx2,imx2]=max(mx);
            cpos=lb+imx2-1;
            f0bak=f0raw0;
            f0raw1=f0raw0;
            f0raw2=f0raw0;
            f0raw3=f0raw0;
            f0raw0(cpos)=f0cand(cpos,1);
            lastf0=f0cand(cpos,1);
            [f0rawm,sprob0]=ztraceInAsegment2(f0raw0,f0cand,relv2,pwrdb+10,cpos,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
            f0raw1(cpos)=f0cand(cpos,2);%f0cand(acp,1);
            lastf0=f0raw1(cpos);
            [f0raw1,sprob1]=ztraceInAsegment2(f0raw1,f0cand,relv2,pwrdb+10,cpos,lastf0,bp,ep,nf0,f0jumpt,nsdt,noiselevel);
            [mx,imx]=max([sprob0 sprob1]);
            switch imx
                case 1
                    f0raw0=f0rawm;
                case 2
                    f0raw0=f0raw1;
            end;
            f0(lb:ub)=f0raw0(lb:ub);
        end;
    end;
end;

%---- final scan and reorganize segments
InInd=0;
cseg=zeros(nn,2);
crseg=0;
for ii=1:nn
    if (InInd==0) & (f0(ii)>0)
        crseg=crseg+1;
        cseg(crseg,1)=ii;
        InInd=1;
    elseif (InInd==1) & (f0(ii)==0)
        cseg(crseg,2)=ii-1;
        InInd=0;
    end;
end;
if cseg(crseg,2)==0;cseg(crseg,2)=nn;end;
cseg=cseg(1:crseg,:);

if DispOn
    h=semilogy(f0);
    set(h,'linewidth',2);
end;

%---- internal functions

function [f0seg,relseg,lb,ub,srate,maskr]=zsearchforContiguousSegment(f0cand,relv,maskrin,acp,pwsdb,noiselevel);

f0seg=f0cand(:,1)*0;
relseg=f0seg;
srate=0;
maskr=maskrin;
ok=1;
nn=length(f0seg);

lastf0=f0cand(acp,1);
f0seg(acp)=lastf0;
relseg(acp)=relv(acp,1);
lb=acp;ub=acp;
for ii=acp-1:-1:1
    [bestdistance,idx]=min(abs(log2(lastf0)-log2(f0cand(ii,:))));
    if (bestdistance>0.1) | (pwsdb(ii)<noiselevel+6) | (maskr(ii,idx)==0) | (relv(ii,idx)<0.17)
        break
    else
        lb=ii;
        lastf0=f0cand(ii,idx);
        f0seg(ii)=lastf0;
        relseg(ii)=relv(ii,idx);
        srate=srate+relv(ii,idx);
        wmaskr(ii,:)=maskr(ii,:)*0;
    end;
end;
if ok==0;return;end;
lastf0=f0cand(acp,1);
for ii=acp+1:nn
    [bestdistance,idx]=min(abs(log2(lastf0)-log2(f0cand(ii,:))));
    if (bestdistance>0.1) | (pwsdb(ii)<noiselevel+6) | (maskr(ii,idx)==0) | (relv(ii,idx)<0.05)
        break
    else
        ub=ii;
        lastf0=f0cand(ii,idx);
        f0seg(ii)=lastf0;
        relseg(ii)=relv(ii,idx);
        srate=srate+relv(ii,idx);
        maskr(ii,:)=maskr(ii,:)*0;
    end;
end;
maskr(acp,:)=maskr(acp,:)*0;
maskr(lb:ub,:)=maskr(lb:ub,:)*0;
srate=srate/(ub-lb+1);

%%%----- V/UV decision
function vuv=zvuvdecision4(f0,p);
%   Simple V/UV decision logic
%   Originally designed and coded by Hideki Kawahara
%   15/Aug./2004

pwsdb=p.InstantaneousPower;
rel=p.RELofcandidatesByMix;
maxpwsdb=max(pwsdb);
noiselevel=p.BackgroundNoiselevel;
nl=min(length(f0),length(pwsdb));

%---- onset and offset candidates 
nw=40;
nrw=3;
tt=-nw:nw;
pws=10.0.^(pwsdb/20);
pws=pws(:);
wwh=exp(-(tt/(nw/2.5)).^2).*(0.5-1.0./(1+exp(-tt/nrw)));
dpw=fftfilt(wwh,[pws;zeros(nw*2,1)]);
dpw=dpw((1:length(pws))+nw);
biast=nrw*3;

ddpw=diff([dpw(1);dpw]);
ddpwm=diff([dpw;dpw(end)]);
onv=find((ddpw.*ddpwm<0)&(ddpwm<=0));
offv=find((ddpw.*ddpwm<0)&(ddpwm>0));

%---- search for voiced segments
vuv=(pwsdb>(2*maxpwsdb+noiselevel)/3);
[pv,dv]=zpeakdipdetect(p,81);
np=length(pv);
%nn=length(vuv);
nn=min(length(vuv),length(f0));
vuv=vuv*0;
lastp=2;
for ii=1:np
    if (pwsdb(pv(ii))>(1.2*maxpwsdb+noiselevel)/2.2) & (pv(ii)>lastp)
        lb=lastp; %max(dv(dv<pv(ii)));
        ub=nn-1; %min(dv(dv>pv(ii)));
        cp=pv(ii);
        bp=cp;ep=cp;
        for bp=cp-1:-1:lb
            if (pwsdb(bp)<(maxpwsdb+2.3*noiselevel)/3.3) | ...
               ((pwsdb(bp)<(1.5*maxpwsdb+noiselevel)/2.5) & (rel(bp)<0.3)) | ...
               ((pwsdb(bp)<(1.5*maxpwsdb+noiselevel)/2.5) & (abs(log2(f0(bp)/f0(bp-1)))>0.1))
                break
            end;
        end;
        [dmy,ix]=min(abs(onv-bp));
        if dmy<20; bp=max(1,onv(ix)-biast);end;
        for ep=cp+1:ub %min(length(f0)-1,ub) % safe giard 11/Jan./05
            if (pwsdb(ep)<(maxpwsdb+5*noiselevel)/6) | ... %
               ((pwsdb(ep)<(maxpwsdb+1.3*noiselevel)/2.3) & (rel(ep)<0.25)) | ...
               ((pwsdb(ep)<(maxpwsdb+0.7*noiselevel)/1.7) & (abs(log2(f0(ep)/f0(ep+1)))>0.1))
                break;
            end;
        end;
        %[dmy,ix]=min(abs(offv-ep));
        %ep=min(nn,offv(ix)+biast);
        vuv(bp:ep)=vuv(bp:ep)*0+1;
        %disp(['(' num2str(bp,7) ':' num2str(ep,7) ')'])
        lastp=ep;
    end;
end;

%---- check for dominant peaks if it is selected as a voiced segment
function [pv,dv]=zpeakdipdetect(p,wsml);

pwsdb=p.InstantaneousPower;
%----- mark syllable centers
%wsml=81;
pwsdbl=[ones(wsml,1)*pwsdb(1);pwsdb(:);ones(2*wsml,1)*pwsdb(end)];
pwsdbs=fftfilt(hanning(wsml)/sum(hanning(wsml)),pwsdbl);
pwsdbs=pwsdbs((1:length(pwsdb))+round(3*wsml/2));
dpwsdbs=diff([pwsdbs(1);pwsdbs]);
dpwsdbsm=diff([pwsdbs;pwsdbs(end)]);
pv=find((dpwsdbs.*dpwsdbsm<0)&(dpwsdbsm<=0));
dv=find((dpwsdbs.*dpwsdbsm<0)&(dpwsdbsm>0));
