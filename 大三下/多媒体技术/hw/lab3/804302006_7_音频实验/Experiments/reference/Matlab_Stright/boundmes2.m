function bv=boundmes2(apv,dpv,fs,shiftm,intshiftm,mm)

%	boundary calculation for MBE model

%		bv=boundmes2(apv,dpv,fs,shiftm,intshiftm,mm);

%		apv		: peak envelope

%		dpv		: dip envelope

%		fs		: sampling frequency (Hz)

%		shiftm	: frame shift of F0 data

%		intshiftm	: frame shift for envelope data

%		mm		: number of elements in frequency axis



%	01/Sept./1999

%	by Hideki Kawahara



lx=log10((1:mm-1)/(mm-1)/2*fs);

fx=(1:mm-1)/(mm-1)/2*fs;

wwv=10.0.^(apv/20);

lyv=((dpv-apv)/20);

[ll,kk]=size(apv);

bv=zeros(1,kk);

for ii=1:kk

   bv(ii)=sum((lyv(2:mm,ii)'-lx).*wwv(2:mm,ii)'./fx)/sum(wwv(2:mm,ii)./fx');

end;

%	Assuming shiftm >= 1 ms

if ne(round(shiftm),shiftm)

   bv=[];

   return;

end;

if ne(round(intshiftm),intshiftm)

   bv=[];

   return;

end;

if shiftm==intshiftm

   return;

end;

if intshiftm>1

   bv=interp(bv,intshiftm);

   if shiftm>1

      bv=bv(1:shiftm:length(bv));

   end;

end;

