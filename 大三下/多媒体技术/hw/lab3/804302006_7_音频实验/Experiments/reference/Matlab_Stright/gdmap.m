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
