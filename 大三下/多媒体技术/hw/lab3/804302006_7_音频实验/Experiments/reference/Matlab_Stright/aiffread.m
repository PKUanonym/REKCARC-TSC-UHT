function [x,fs]=aiffread(fname)


%	function [x,fs]=aiffread(fname)
%	Read AIFF and AIFF-C file
%	This is a reduced version and does not fulfill the
%	AIFF-C standard.

%	Coded by Hideki Kawahara based on "Audio Interchange file format AIFF-C draft"
%		by Apple Computer inc. 8/26/91
%	14/Feb./1998
%	17/Feb./1998
%	14/Jan./1999 bug fix for Windows

fid=fopen(fname,'r','ieee-be.l64');
id.form=fread(fid,4,'char');
id.formcksz=fread(fid,1,'int32');
id.formtp=fread(fid,4,'char');
x=[];fs=44100;
if ~strcmp(char(id.form),['F';'O';'R';'M'])
	char(id.form)
	disp('This is not a proper AIFF file.');
	return;
end;
if ~strcmp(char(id.formtp),['A';'I';'F';'F']) & ~strcmp(char(id.formtp),['A';'I';'F';'C'])
    char(id.formtp)
	disp('This is not a proper AIFF file.');
	return;
end;
[id.comm,na]=fread(fid,4,'uchar');
while na>3
switch(strcat(char(id.comm)'))
case 'FVER'
	id.fsize=fread(fid,1,'int32');
	id.timesta=fread(fid,1,'uint32');
	if id.timesta ~= 2726318400
		disp(['I cannot recognize timestump ' num2str(id.timesta)]);
	end;
	[id.comm,na]=fread(fid,4,'uchar');
	if na==0
		if isempty(x); disp('End of file reached!');fclose(fid);return;end;
	end;
case 'COMM'
	id.commsz=fread(fid,1,'int32');
	id.commnch=fread(fid,1,'int16');
	id.commdsz=fread(fid,1,'uint32');
	id.samplesize=fread(fid,1,'int16');
	id.srex1=fread(fid,1,'uint16');
	id.srex2=fread(fid,1,'uint64');
	if strcmp(char(id.formtp),['A';'I';'F';'C'])
	    id.compress=fread(fid,4,'char');
		if ~strcmp(char(id.compress),['N';'O';'N';'E'])
		    disp('Compression is not supported.');
			return;
		end;
	    dummy=fread(fid,id.commsz-22,'char');
	end;
	fs=2^(id.srex1-16383)*id.srex2/hex2dec('8000000000000000');
    [id.comm,na]=fread(fid,4,'uchar');
	if na==0
		if isempty(x); disp('End of file reached!');fclose(fid);return;end;
	end;
case 'SSND'
	id.ckdatasize=fread(fid,1,'uint32');
	id.offset=fread(fid,1,'int32');
	id.blksz=fread(fid,1,'int32');
	switch(id.samplesize)
	case 8
	    x=fread(fid,id.ckdatasize-8,'int8');
		x=reshape(x,id.commnch,id.commsz)';
	case 16
	    x=fread(fid,(id.ckdatasize-8)/2,'int16');
		x=reshape(x,id.commnch,id.commdsz)';
	case 24
	    x=fread(fid,(id.ckdatasize-8)/3,'bit24');
		x=reshape(x,id.commnch,id.commdsz)';
	end;
    [id.comm,na]=fread(fid,4,'uchar');
	if na==0
		if isempty(x); disp('End of file reached!');fclose(fid);return;end;
	end;
otherwise
	id.fsize=fread(fid,1,'int32');
	if feof(fid) | id.fsize > id.formcksz | id.fsize <=0
		fclose(fid);
		return;
	end;
	id.skip=fread(fid,id.fsize,'char');
    [id.comm,na]=fread(fid,4,'uchar');
	if na==0
		if isempty(x); disp('End of file reached!');fclose(fid);return;end;
	end;
end;
end;
%id
fclose(fid);

