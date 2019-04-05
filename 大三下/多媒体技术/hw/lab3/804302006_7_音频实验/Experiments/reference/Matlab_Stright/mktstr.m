function tstr=mktstr;
%	return time string in hh:mm:ss format
%	by Hideki Kawahara
%	05/Jan./1995

anatime=fix(clock);
tstr=[num2str(anatime(4)) ':' num2str(anatime(5)) ':' num2str(anatime(6))];
