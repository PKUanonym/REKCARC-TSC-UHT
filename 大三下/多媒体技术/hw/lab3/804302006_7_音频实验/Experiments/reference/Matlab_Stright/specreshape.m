function n2sgram3=specreshape(fs,n2sgram,eta,pc,mag,f0,imgi);
%      Spectral compensation using Time Domain technique
%      n2sgram3=specreshape(fs,n2sgram,eta,pc,mag,f0);
%           fs        : sampling frequency (Hz)
%           n2sgram   : Straight smoothed spectrogram (optimum smoother is assumed)
%           eta       : temporal stretch factor
%           pc        : power exponent for nonlinearity
%           mag       : magnification factor of Time Domain compensation
%           f0        : fundamental frequency (Hz)
%			imgi	: display indicator, 1: display on (default), 0: off

%      coded by Hideki Kawahara
%	13/Aug./1997
%	08/Dec./2002
%	Note: This part may be redundant. It is better to
%	evaluate contribution of this part again. (08/Dec./2002)
%	10/Aug./2005 modified by Takahashi on waitbar
%	10/Sept./2005 modified by Kawahara on waitbar

if nargin==6; imgi=1; end;%10/Sept./2005
[nn,mm]=size(n2sgram);
fftl=(nn-1)*2;
fbb=1:nn;
rbb=(nn-1:-1:2);
rbb2=(fftl:-1:nn+1);
bb3=(2:nn-1);
n2sgram3=n2sgram*0;

ovc=optimumsmoothing(eta,pc);
hh=[1 1 1 1; 0 1/2 2/3 3/4; 0 0 1/3 2/4; 0 0 0 1/4];
bb=inv(hh)*ovc;
tt=((0:fftl-1))'/fs;
pb2=(pi/(eta^2)+(pi^2)/3*(bb(1)+4*bb(2)+9*bb(3)+16*bb(4)))*tt.^2;

if imgi==1; hpg=waitbar(0,'time domain spectral compensation of windowing effects'); end; % 08/Dec./2002%10/Aug./2005
for ii=1:mm
  ffs=[n2sgram(:,ii);n2sgram(rbb,ii)];
  ccs2=real(fft(ffs)).*min(20,(1+mag*pb2*f0(ii)^2));
  ccs2(rbb2)=ccs2(bb3);
  ngg=real(ifft(ccs2));
  n2sgram3(:,ii)=ngg(fbb);
  if imgi==1 & rem(ii,20)==0;%10/Aug./2005
	  waitbar(ii/mm);% 08/Dec./2002
  end;
end;
if imgi==1; close(hpg); end; % 08/Dec./2002%10/Aug./2005

%n2sgram3=(abs(n2sgram3)+n2sgram3)/2;
n2sgram3=(abs(n2sgram3)+n2sgram3)/2+0.1;
