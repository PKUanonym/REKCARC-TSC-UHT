function ok=aiffwrite(x,fs,nbits,fname)

%	function ok=aiffwrite(x,fs,nbits,fname)
%	Write AIFF file
%	This is a reduced version and does not fulfill the
%	AIFF standard.

%	Coded by Hideki Kawahara based on "Audio Interchange file format AIFF-C draft"
%		by Apple Computer inc. 8/26/91
%	14/Feb./1998
%	14/Jan./1999 bug fix for Windows

ok=1;
[nr,nc]=size(x);
if nc>nr
    ok=[];
	disp('Data must be a set of column vector.');
	return;
end;
nex=floor(log(fs)/log(2));
vv=fs/2^(nex+1)*2^(4*16);
nex2=nex+16383;

fid=fopen(fname,'w','ieee-be.l64');
fwrite(fid,'FORM','char');
cksize=46+nr*nc*(nbits/8);
fwrite(fid,cksize,'int32');
fwrite(fid,'AIFF','char');

fwrite(fid,'COMM','char');
fwrite(fid,18,'int32');
fwrite(fid,nc,'int16');
fwrite(fid,nr,'int32');
fwrite(fid,nbits,'int16');
fwrite(fid,nex2,'uint16');
fwrite(fid,vv,'uint64');

fwrite(fid,'SSND','char');
fwrite(fid,nr*nc*(nbits/8)+8,'int32');
fwrite(fid,0,'int32');
fwrite(fid,0,'int32');
y=x';
switch(nbits)
   case 8
       fwrite(fid,y(:),'int8');
   case 16
       fwrite(fid,y(:),'int16');
   case 24
       fwrite(fid,y(:),'bit24');
end;
fclose(fid);

