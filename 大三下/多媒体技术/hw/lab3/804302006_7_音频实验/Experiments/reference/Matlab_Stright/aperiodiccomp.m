function ap=aperiodiccomp(apv,dpv,ashift,f0,nshift,fftl,imgi);
%	ap=aperiodiccomp(apv,dpv,ashift,f0,nshift,fftl,imgi);
%	Calculate aperiodicity index 
%	Input parameters
%		apv, dpv : Upper and lower envelope
%		ashift		: shift step for aperiodicity index calculation (ms)
%		f0			: fundamental frequency (Hz)
%		nshift		: shift step for f0 information (ms)
%		fftl		: FFT size
%		imgi		: display indicator, 1: display on (default) 0: off

%   modified to add the waitbar on 08/Dec./2002
%	modified by Takahashi 10/Aug./2005
%	modified by Kawahara 10/Sept./2005

if nargin==6; imgi=1; end;
%[nn,mm]=size(nsgram);
mm=length(f0);
nn=fftl/2+1;
[n2,m2]=size(apv);

x=(0:m2-1)'*ashift;
xi=(0:mm-1)'*nshift;
xi=min(max(x),xi);

if imgi==1; hpg=waitbar(0.1,'Interpolating periodicity information'); end;
if imgi==1; drawnow; end;
ap=interp1q(x,(dpv-apv)',xi)';%,'*linear')';
if imgi==1; close(hpg); end;

