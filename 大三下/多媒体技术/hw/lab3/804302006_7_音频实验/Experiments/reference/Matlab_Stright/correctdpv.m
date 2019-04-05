function dpv=correctdpv(apv,dpv,shiftap,f0raw,ecrt,shiftm,fs)
%   dpv=correctdpv(apv,dpv,shiftap,ecrt,shiftm,fs)
%   Apperiodicity correction based on C/N estimation
%   dpv     : lower spectral envelope
%   apv     : upper spectral envelope
%   shiftap : frame shift for apv and dpv (ms)
%   f0raw   : fundamental frequency (Hz)
%   ecrt    : C/N (absolute value)
%   shiftm  : frame shift for F0 and spectrum (ms)
%   fs      : sampling frequency (Hz)

%   Designed and coded by Hideki Kawahara
%   04/Feb./2003
%	30/April/2005 modification for Matlab v7.0 compatibility
		
[nn,mm]=size(apv);
nf0=length(f0raw);
fx=(0:nn-1)/(nn-1)/2*fs;
f0raw(f0raw==0)=f0raw(f0raw==0)+40; % safe guard

for ii=1:mm
    iif=min(nf0,round((ii-1)*shiftap/shiftm)+1);
    if ~isnan(ecrt(iif))
        bdr=1.0./(1+exp(-(fx-2.5*f0raw(iif))/f0raw(iif)*4));
        bdr=(bdr+1.0/ecrt(iif))/(1+1.0/ecrt(iif));
        dpv(:,ii)=min(dpv(:,ii)',apv(:,ii)'+20*log10(bdr))';
    end;
end;

