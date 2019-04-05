function ok=straightsound(x,fs)
%   Up sampling for reducing aliasing
%	Requested by Dr. Uematsu of NTT, 02/02/1998

switch fs
case 8000
	soundsc(interp(x/32768,4),fs*4);
case 10000
	soundsc(interp(x/32768,4),fs*4);
case 11025
	soundsc(interp(x/32768,4),fs*4);
case 12000
	soundsc(interp(x/32768,4),fs*4);
case 16000
	soundsc(interp(x/32768,2),fs*2);
case 20000
	soundsc(interp(x/32768,2),fs*2);
case 22050
	soundsc(interp(x/32768,2),fs*2);
case 24000
	soundsc(interp(x/32768,2),fs*2);
otherwise,
	soundsc(x/32768,fs);
end
ok='ok';
