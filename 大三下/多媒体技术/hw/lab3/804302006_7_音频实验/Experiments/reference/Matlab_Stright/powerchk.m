function pow=powerchk(x,fs,segms);
%	Calculate average power of voiced portion
%	pow=powerchk(x,fs,segms)
%		x	: signal
%		fs	: sampling frequency (Hz)
%		segms	: segment length (ms)

%	23/Sept./1999 updated
%	30/April/2005 modification for Matlab v7.0 compatibility

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

