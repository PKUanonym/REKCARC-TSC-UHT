function sy = exSinStraightSynth(f0raw,fs,n3sgram,shiftm)

gdm=gdmap(n3sgram,fs);
[amx,fmx,gmx]= sinucompgd(f0raw,fs,n3sgram,gdm,shiftm);
amx(isnan(amx))=0;
sy=sum(amx'.*cos(cumsum(2*pi*fmx/fs))');

function [amx,fmx,gmx]= sinucompgd(f0raw,fs,n3sgram,gdm,shiftm)

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
gd=gdm';
[nn,mm]=size(ng);

%  ---- instantaneous frequency matrix ---
nh=ceil(fs/2/f0l);
nt=length(f0i);
fmx=zeros(nt,nh);
tmx=fmx;
for ii=1:nh
    fmx(:,ii)=ii*f0i;
    tmx(:,ii)=t';
end;

% ---- instantaneous amplitude matrix ---
amx=zeros(nt,nh);
[ff,tt]=meshgrid((0:(mm-1))*fs/((mm-1)*2),(0:(length(f0raw)-1))/1000/shiftm);
%keyboard;
amx=interp2(ff,tt,ng,fmx,tmx);
gmx=interp2(ff,tt,gd,fmx,tmx);

function gdm=gdmap(n3sgram,fs)
%   gdm=gdmap(n3sgram,fs)
%   function to calculate group delay map from 
%   smoothed time frequency representation

%   Designed and coded by Hideki Kawahara
%   7/Sept./2003

[nn,mm]=size(n3sgram);
fftl=(nn-1)*2;

rbb2=fftl/2:-1:2;
gdm=zeros(nn,mm);
for ii=1:mm
    ff=[n3sgram(:,ii);n3sgram(rbb2,ii)];
    ccp=real(fft(log(ff))); 
    ccp2=[ccp(1);2*ccp(2:fftl/2);0*ccp(fftl/2+1:fftl)];
    ffx=(-ifft(ccp2));
    gdt=-diff(imag(ffx)/(2*pi*fs/fftl));
    gdm(:,ii)=[gdt(1);gdt(1:fftl/2)];
end;
