function oki= straightCIv1(actionstr)

%	STRAIGHT command interpreter

%       STRAIGHT --- Speech Transformation and Representation using
%       Adaptive Interpolation of weiGHTed spectrum
%	Interactive interface for trial use
%
%       (c) Copyright ATR Human Information Processing Research
%       Laboratories, 1996,1997
%       Author and Inventor: Hideki Kawahara
%       02/July/1996
%       04/July/1996
%       07/July/1996
%	07/Sep./1996
%	01/Nov./1996
%	25/Nov./1996 TEMPO enhancement
%	30/Nov./1996 This version is with AG window trick
%	25/Dec./1996 This version is with AG window trick
%	27/Dec./1996 using fundamentalness as U/V measure
%	02/Feb./1997 without V/UV decision
%	05/Feb./1997 Bug Fix
%	10/Feb./1997 Maximum liklihood F0 tracking
%	15/Feb./1997 frequency range division
%	15/Feb./1997 Big bug fix in spectral calculation
%	22/Feb./1997 No need for temporal smoothing (thanks for the new window)
%	11/Mar./1997 New wavelet for F0 extraction
%	03/May /1997 Quick bug fix for Matlab v5
%	30/May /1997 Quick bug fix for Matlab v5
%	21/June/1997 Quick bug fix for new fundamentalness
%	12/Aug./1997 Revised optimum smoother (minor revision)
%	13/Aug./1997 Revised SPIKES scaling property and TD enhancement
%	19/Dec./1997 Revised for mixed mode excitation
%	09/Jan./1998 GUI command line interpreter
%	29/Jan./1998 Integrated with mixed mode and GUI
%	02/Feb./1998 Minor inconvenience fix 
%	03/Fev./1998 Minor bug fix
%	13/April/1999 New pitch extractor
%	19/April/1999 Minor modificatio to display information
%	22/April/1999 Minor modificatio for unvoiced spectrum
%	05/May  /1999 New periodic/aperiodic mixing ratio
%	21/July/1999  reduced version with crisp V/UV decision
%	17/Feb./2001 Bug fix for multi channel sound files
%	30/May/2001 New aperiodicity measure and control
%	8/April/2002 modified to remove magic numbers
%	26/June/2002 minor modification: two globals are added.
%	08/Dec./2002 Default parameters were made user definable.
%   04/Feb./2003 Aperiodicity correction and bug fix in STRAIGHTbody proc.
%   31/Aug./2004 Bug fix for f0 abnormal values
%	30/April/2005 modification for Matlab v7.0 compatibility
		
global n2sgram nsgram n3sgram n2sgrambk nwsgram xold x f0floor f0ceil fs framem shiftm f0shiftm ...
  fftl eta pc framel fftl2 acth pwth pcnv fconv sconv delsp gdbw cornf fname ofname delfracind ...
  tpath cpath paraminitialized mag delfrac hr f0raw f0l f0var f0varL sy pcorr pecorr gobjlist ...
  upsampleon hhb pwt pwh amp defaultendian indefaultendian outdefaultendian f0varbak
  
  global maphandles

  global bv % 02/Sept./1999
  global apv dpv % 21/Sept./1999
  global defaultch % 16/Feb./2001
  global apve dpve % 22/Oct./2001
  
  global f0v vrv % 25/June/2002 for debug
  global ecrt % 03/Feb./2003 for C/N based correction of dpv

%f0floor=40;
%f0ceil=800;
menuid=0;

switch(actionstr)
%-----------------------------------------------
%	Initialization part
%-----------------------------------------------
  case 'GUIinitialize'
	  clear global
	  straightCIv1 initializeparams
	  straightPanel98bak;
	  syncgui;
	  straightCIv1 syncbuttons;
  case 'resetparamsbtn'
	  straightCIv1 initializeparams
	  syncgui;
  case 'initialize'
	  clear global n2sgram nsgram n3sgram n2sgrambk nwsgram xold x f0raw f0l sy hhb
	  straightCIv1 initializeparams
	  syncgui;
	  straightCIv1 syncbuttons;
  case 'initializeparams'
	  if exist('defaultparams.m','file')==0 %	08/Dec./2002
	  f0floor=40;
	  f0ceil=800;
	  fs=22050;	% sampling frequency (Hz)
	  framem=40;	% default frame length for pitch extraction (ms)
	  shiftm=1;       % default frame shift (ms) for spectrogram
	  f0shiftm=1;     % default frame shift (ms) for F0 information
	  fftl=1024;	% default FFT length
	  eta=1.4;        % time window stretch factor
	  pc=0.6;         % exponent for nonlinearity
	  mag=0.2;      % This parameter should be revised.
	  framel=framem*fs/1000;

	  if fftl < framel
	    fftl=2^ceil(log(framel)/log(2));
	  end;
	  fftl2=fftl/2;
	  defaultch=1; % 17/Feb./2001

	  %-------------- Decision parameter for source information

	  acth=0.5;	% Threshold for normalized correlation (dimension less)
	  pwth=32;	% Threshold for instantaneous power below maximum (dB)
	  
	  %-----------------------------------------------------
	  %       Synthesis parameters
	  %-----------------------------------------------------

	  pcnv=1.0; 	% pitch stretch
	  fconv=1.0; 	% frequency stretch
	  sconv=1.0; 	% time stretch

%	  delsp=2; 	%  standard deviation of random group delay in ms
      delsp=0.5; 	%  standard deviation of random group delay in ms 26/June/2002
	  gdbw=70; 	% smoothing window length of random group delay (in Hz)
%	  cornf=3000;  	% corner frequency for random phase (Hz)
	  cornf=4000;  	% corner frequency for random phase (Hz) 26/June 2002
	  delfrac=0.2;  % This parameter should be revised.
	  delfracind=0;

	  %-----------------------------------------------------
	  %	file parameters
	  %-----------------------------------------------------

	  fname='none';		% input data file name

	  hr='on';
	  tpath=pwd;
	  if strcmp(computer,'MAC2')==0
		  tpath=[tpath '/'];
	  end;
	  upsampleon=0;
      else %	08/Dec./2002
	     defaultparams;
	  end; % of if exist('defaultparams.m','file')==0 %	08/Dec./2002
	  defaultendian=chkdefaultendian;
	  indefaultendian=defaultendian;
	  outdefaultendian=defaultendian;
  case 'resetvalues'
	  straightCIv1 initializeparams
	  syncgui;	  

%-----------------------------------------------------
%	file I/O part
%-----------------------------------------------------
  case 'bininputformat'
		hh=findobj('Tag','bininputformat');
		indefaultendian=get(hh,'Value');
  case 'binoutputformat'
		hh=findobj('Tag','binoutputformat');
		outdefaultendian=get(hh,'Value');
  case 'readfile' 
%	  fname=input('Please type the file name to be analyzed: ','s');
      [fname,cpath]=uigetfile(...
          {'*.wav';'*.aif';'*.WAV';'*.aiff';'*.dat';'*.dat'},...
          'sound file input');
	  if fname(1)~=0
	    tcpath=[char(39) cpath char(39)]
	    eval(['cd ' tcpath]);
	    if ~isempty(findstr(lower(fname),'.wav')) % 16/Feb./2001
	       [x,fs]=wavread(fname);
	       x=x*32768;
	    elseif ~isempty(findstr(lower(fname),'.aif')) % 16/Feb./2001
		   [x,fs]=aiffread(fname);
	    else
			if indefaultendian==1
				fid=fopen(fname,'r','ieee-le');
			else
				fid=fopen(fname,'r','ieee-be');
			end;
	       x=fread(fid,'short')';
	       fclose(fid);
	    end;
	   [tnn,tmm]=size(x); % 16/Feb./2001
	   if min(tnn,tmm)>1 % 16/Feb./2001
		   switch tnn>tmm
		   case 1,
			   x=x(:,defaultch);
		   case 0,
			   x=x(defaultch,:);
		   end;
	   end;	
	    x=x(:)'; % make sure that the vector is row vector
	    xold=x;
%	    x=xold+std(x)/100*randn(size(x));
		x=xold+std(x)/1000*randn(size(x));  % 03/Feb./2001
	  else
	    disp(['file input is cancelled. ']);
	    disp(' ');
	  end;
	  syncgui;
	  straightCIv1 syncbuttons;

  case 'savefile'
%	  ofname=input([fname ' is the current file. Input out file name: '],'s');
	  tcpath=[char(39) tpath char(39)]
	  eval(['cd ' tcpath]);
	  tsy=sy; tfs=fs;
	  if upsampleon
	    switch fs
	    case {8000, 10000, 11025, 12000}
	  	  tfs=fs*4; tsy=interp(sy,4);
  	    case {16000, 20000, 22050, 24000}
		  tfs=fs*2; tsy=interp(sy,2);
	    end;
	  end;
      [ofname,tpath]=uiputfile('*','sound file output');
	  if ofname(1)~=0
	    if ~isempty(findstr(ofname,'.wav'))
	       wavwrite(tsy/32768,tfs,16,[tpath ofname]);
	    elseif ~isempty(findstr(ofname,'.aif'))
		   ok=aiffwrite(tsy,tfs,16,ofname);
		   if isempty(ok)
			   disp(['File output is failed. ' ofname ' was not written.']);
		   end;
	   else
		   if outdefaultendian==1
			   fid2=fopen([tpath ofname],'w','ieee-le');
		   else
			   fid2=fopen([tpath ofname],'w','ieee-be');
		   end;
	       fwrite(fid2,tsy,'short');
	       fclose(fid2); 
	    end;
	    %     straightSynthArc;
	    disp(['% Saved successfully as: ' ofname]);
	    disp(' ');
	  else
	    disp(['file output is cancelled. ']);
	    disp(' ');
	  end;

%-----------------------------------------------------
%	Display spectrogram group
%-----------------------------------------------------
  case 'dispnsgram'
	  mxil=max(max(20*log10(nsgram+0.001)));
	  [nsy,nsx]=size(nsgram);
	  figure;
	  imagesc((0:nsx-1)*shiftm,(0:nsy-1)/nsy*fs/2, ...
 	        max(20*log10(nsgram+0.001),mxil-50));
	  axis('xy'); colormap(1-gray);
	  title(['Equal resolution spectrum of ' fname ' ' date ' ' mktstr]);
	  xlabel('time (ms)');
	  ylabel('frequency (Hz)');
  case 'dispnwsgram'
	  mxil=max(max(20*log10(nwsgram+0.001)));
	  [nsy,nsx]=size(nwsgram);
	  figure;
	  imagesc((0:nsx-1)*shiftm,(0:nsy-1)/nsy*fs/2, ...
 	        max(20*log10(nwsgram+0.001),mxil-50));
	  axis('xy'); colormap(1-gray);
	  title(['Wide band spectrum of ' fname ' ' date ' ' mktstr]);
	  xlabel('time (ms)');
	  ylabel('frequency (Hz)');
  case 'dispn2sgram'
	  mxil=max(max(20*log10(n2sgram+0.001)));
	  [nsy,nsx]=size(n2sgram);
	  figure;
	  imagesc((0:nsx-1)*shiftm,(0:nsy-1)/nsy*fs/2,...
	  max(real(20*log10(n2sgram+0.001)),mxil-50));
	  axis('xy'); colormap(1-gray);
	  title(['enhanced spectrum of ' fname ' ' date ' ' mktstr]);
	  xlabel('time (ms)');
	  ylabel('frequency (Hz)');
  case 'dispn2sgrambk'
	  mxil=max(max(20*log10(n2sgrambk+0.001)));
	  [nsy,nsx]=size(n2sgrambk);
	  figure;
	  imagesc((0:nsx-1)*shiftm,(0:nsy-1)/nsy*fs/2,...
	  max(real(20*log10(n2sgrambk+0.001)),mxil-50));
	  axis('xy'); colormap(1-gray);
	  title(['Interpolated spectrum of ' fname ' ' date ' ' mktstr]);
	  xlabel('time (ms)');
	  ylabel('frequency (Hz)');
  case 'dispn3sgram'
	  mxil=max(max(20*log10(n3sgram+0.001)));
	  [nsy,nsx]=size(n3sgram);
	  figure;
	  imagesc((0:nsx-1)*shiftm,(0:nsy-1)/nsy*fs/2,...
	  max(real(20*log10(n3sgram+0.001)),mxil-50));
	  axis('xy'); colormap(1-gray);
	  title(['enhanced spectrum (without 2nd strctr) of ' fname ' ' date ' ' mktstr]);
	  xlabel('time (ms)');
	  ylabel('frequency (Hz)');
 case 'disphhbspectrograme'	 
	  bb=1:length(n2sgram(1,:));
	  mmx=hhb(:,bb).*n3sgram+(1-hhb(:,bb)).*nwsgram;
	  mxil=max(max(20*log10(mmx+0.001)));
	  [nsy,nsx]=size(mmx);
	  figure;
	  imagesc((0:nsx-1)*shiftm,(0:nsy-1)/nsy*fs/2,...
	  max(real(20*log10(mmx+0.001)),mxil-50));
	  axis('xy'); colormap(1-gray);
	  title(['final composite spectrum of ' fname ' ' date ' ' mktstr]);
	  xlabel('time (ms)');
	  ylabel('frequency (Hz)');
  case 'showF0'
	  figure(gcf+1); subplot(111);plot((1:length(f0l))*f0shiftm,f0l); grid on;
	  title(['F0 of ' fname ' ' date ' ' mktstr]);
	  ylabel('frequency (Hz)'); xlabel('time (ms)');

%-----------------------------------------------
%	audio display part
%-----------------------------------------------
  case 'playoriginal'
	 straightsound(xold,fs);
  case 'playsynth'
	 straightsound(sy,fs);

%-----------------------------------------------
%	parameter modification part
%-----------------------------------------------
 case 'peekvars'  % This is the most poweful interaction
	 keyboard;
	 syncgui;
	 straightCIv1 syncbuttons;
 case 'getfsmenu'
	 fs=getfsfrommenu(gco);
	  syncgui;
 case 'editf0ceil'
	 f0ceil=getvalufromedit(gco,800);
	  syncgui;
 case 'editf0floor'
	 f0floor=getvalufromedit(gco,40);
	  syncgui;
 case 'editshiftm'
	 f0shiftm=getvalufromedit(gco,1);
	 shiftm=f0shiftm;
	  syncgui;
  case 'fftledit'
%	 fftl=getvalufromedit(gco,1024);
	  syncgui;
  case 'wndwstrtchedit'
	  eta=getvalufromedit(gco,1.4);
	  syncgui;
  case 'pwrcnstntedit'
	  pc=getvalufromedit(gco,0.6);
	  syncgui;	  
  case 'magfactoredit'
	  mag=getvalufromedit(gco,0.2);
	  syncgui;	  	  
  case 'delfracedit'
	  delfrac=getvalufromedit(gco,0.2);
	  syncgui;	 
  case 'delspedit'
	  delsp=getvalufromedit(gco,2);
	  syncgui;	 
  case 'cornfedit'
	  cornf=getvalufromedit(gco,2400);
	  syncgui;	 
  case 'gdbwedit'
	  gdbw=getvalufromedit(gco,70);
	  syncgui;	 	
  case 'pcnvedit'
	  pcnv=getvalufromedit(gco,1);
	  syncgui;	 	
  case 'fconvedit'
	  fconv=getvalufromedit(gco,1);
	  syncgui;	 	
  case 'sconvedit'
	  sconv=getvalufromedit(gco,1);
	  syncgui;	
  case 'tpathedit'
	  tpath=get(gco,'Value');
	  syncgui;	
  case 'pcnvslider'
	  pcnv=10.0.^get(gco,'Value');
	  syncgui;		  
  case 'fconvslider'
	  fconv=3.0.^get(gco,'Value');
	  syncgui;		  
  case 'sconvslider'
	  sconv=10.0.^get(gco,'Value');
	  syncgui;		  
  case 'delfracradio'
	  delfracind=~delfracind;
	  syncgui;	
  case 'delspradio'
	  delfracind=~delfracind;
	  syncgui;	
  case 'upsamplebtn'
	  upsampleon=~upsampleon;
	  syncgui;	
	  
%--------------------------------------------------
%	non-linear manipulations
%--------------------------------------------------
case 'FqNLbtn'
	hh=findobj('Tag','FqNLbtn');
	if get(hh,'UserData') ==0 |  isempty(get(hh,'UserData'))
	  set(hh,'UserData',1);
	  set(hh,'BackgroundColor',[0.9 0.33333 0.33333]);
	  bendline initialize;
     else
	  set(hh,'UserData',0);
	  set(hh,'BackgroundColor',[0.733333 0.733333 0.733333]);
	  bendline close;
     end;
  

%	This part is obsolate. This part will be revised completely.
  case 'interactSGRAM'
     figure;
     mxil=max(max(20*log10(n2sgram)));
     imagesc(max(20*log10(n2sgram),mxil-45));
     axis('xy'); colormap(1-gray);
     title(['Interpolated spectrum of ' fname ' ' date ' ' mktstr]);
	  disp('%	Now you have to define trajectory using mouse');
	  disp('%	Please type "return", if you are ready.');
	  disp('%	It is recommended for you to select important portion ');
	  disp('%	using "zoom on" command.');
	  disp('%	Please do not forget to issue "zoom off" before continue.');
	  disp('%	In graphical input interaction, click defines point and return');
	  disp('%	notifies it is the last point.');
	  keyboard;
	  disp('%	Interaction started. Put the cursor inside the graphics.');
	  zoom off;
	  getTrace;
	  disp('%	You can modify spectrum using the following command.');
	  disp('%       n2sgram=n2sgrambk.*(1+nsgm).^X;');
	  disp('%		X*6 dB amplification is made.');
	  disp('%		Default 6dB amplification was already done.');
	  disp('%	If you are OK, type "return". ');
	  disp('%	Otherwise, please change.');
	  n2sgram=n2sgrambk.*(1+nsgm);
	  
%-------------------------------------------
%	mapping control part
%-------------------------------------------
  case 'frequencymapmod'
	  [nii,njj]=size(n2sgram);
      vx=(0:nii-1)/(nii-1);
      idcv=vx*maphandles(20)+sin(vx*pi)*maphandles(21)+sin(2*pi*vx)*maphandles(22);
      fconv=max(1,min(nii,idcv*(nii-1)+1));
 
%-------------------------------------------
%	synthesis part
%-------------------------------------------
 case 'synthesizechar' % This part is useless now
	  disp('%-------- Current Synthesis parameters ------');
	  disp(['%	delsp=' num2str(delsp) ...
	       ';     % standard deviation of random group delay in ms']);
	  disp(['%	gdbw=' num2str(gdbw) ... 
	       ';    % smoothing window length of random group delay (in Hz)']);
	  disp(['%	cornf=' num2str(cornf) ... 
	       ';  % corner frequency for random phase (in Hz)']);
	  disp(['%	pcnv=' num2str(pcnv) ...
	       ';    % pitch stretch']);
	  disp(['%	fconv=' num2str(fconv) ...
	       ';   % frequency stretch']);
	  disp(['%	sconv=' num2str(sconv) ...
	       ';   % time stretch']);
	  disp('%	');
	  disp('%	If you are happy with these parameters please type "return".');
	  disp('%	You can change these setting using Matlab command(s)');
	  disp('%	If you want to restore default parameters please type');
	  disp('%	"default22kparams"  There are similar prog. for 12k,16k files.');
	  keyboard;
	  disp('%	Now, synthesis is in progress. Please wait a moment.');
             syncgui;
	  straightCIv1 synthesize
	  
 case 'synthesizegradedqqq'  % OBSOLATE!!!
  	  hh=findobj('Tag','FqNLbtn');
	  if ~isempty(hh)
	    if ~isempty(get(hh,'UserData'))
			if get(hh,'UserData')==1
				straightCIv1 frequencymapmod
			end;
	    end;
	  end;
	  sy=straightSynthTC01(n3sgram,nwsgram,f0raw,hhb,shiftm,fs, ...
                    pcnv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind);
	  dBsy=powerchk(sy,fs,15); % 23/Sept./1999
	  cf=(20*log10(32768)-22)-dBsy;
	  sy=sy*(10.0.^(cf/20));
	  disp('%	Done!');
     straightCIv1 syncbuttons;

     

  case 'synthesizegraded' 
  	  hh=findobj('Tag','FqNLbtn');
	  if ~isempty(hh)
	    if ~isempty(get(hh,'UserData') )
			if get(hh,'UserData')==1
		  		straightCIv1 frequencymapmod
			end;
	    end;
	  end;
%	  sy=straightSynthTB06g(n3sgram,f0raw,f0var,f0varL,shiftm,fs, ...
%	            pcnv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind,bv);
%	  sy=straightSynthTB06c(n3sgram,f0raw,shiftm,fs, ...
%	            pcnv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind, ...
%				aperiodiccomp(apv,dpv,5,f0raw,f0shiftm,fftl)); % 23/Sept./1999 % removed 8/April/2002
	  sy=straightSynthTB07ca(n3sgram,f0raw,shiftm,fs, ...
	            pcnv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind, ...
				aperiodiccomp(apv,dpv,5,f0raw,f0shiftm,fftl),1); % 8/April/2002
	  dBsy=powerchk(sy,fs,15); % 23/Sept./1999
	  cf=(20*log10(32768)-22)-dBsy;
	  sy=sy*(10.0.^(cf/20));
	  disp('%	Done!');
	  straightCIv1 syncbuttons;

  case 'synthesize'
  	  hh=findobj('Tag','FqNLbtn');
	  if ~isempty(hh)
	    if ~isempty(get(hh,'UserData') )
			if get(hh,'UserData')==1
		  		straightCIv1 frequencymapmod
			end;
	    end;
	  end;
	  sy=straightSynthTB06(n3sgram,f0raw,f0var,f0varL,shiftm,fs, ...
	            pcnv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind);
	  dBsy=powerchk(sy,fs,15); % 23/Sept./1999
	  cf=(20*log10(32768)-22)-dBsy;
	  sy=sy*(10.0.^(cf/20));
	  disp('%	Done!');
	  straightCIv1 syncbuttons;
	  

%------------------------------------------------------
%	analysis part
%	This part is modified to introduce a new F0 and
%	source information extraction method. (19/April/1999)
%------------------------------------------------------
  case 'source'
%	  dn=round(fs/2000);
%	  [f0l,f0dev,strand,fen,f0raw,pm]= ...
%	            HirbPitchTB(decimate(x,dn),fs/dn,f0floor,f0ceil,f0shiftm,hr);
%
%	  f00=f0l;
%	  zerocrossremoval10
%	  displaySourceInfScl
%	  [f0var,f0varL]=modf0dev2(x,fs,f0raw,f0dev,shiftm);
	  nvo=24;
	  nvc=ceil(log(f0ceil/f0floor)/log(2)*nvo);
	  [f0v,vrv,dfv,nf,aav]=fixpF0VexMltpBG4(xold,fs,f0floor,nvc,nvo,1.2,1,shiftm,1,5,0.5,1);
	  title([fname '  ' datestr(now,0)]);
	  drawnow;
	  [nn,mm]=size(f0v);
	  [pwt,pwh]=plotcpower(xold,fs,shiftm);drawnow;
	  
	  [f0raw,irms,df,amp]=f0track5(f0v,vrv,dfv,pwt,pwh,aav,shiftm);
	  f0t=f0raw;avf0=mean(f0raw(f0raw>0));
	  f0t(f0t==0)=f0t(f0t==0)*NaN;tt=1:length(f0t);
%	  keyboard;
	  subplot(615);plot(tt*shiftm,f0t,'g');grid on;
	  if ~isnan(avf0)
	  axis([1 max(tt)*shiftm ...
	      min(avf0/sqrt(2),0.95*min(f0raw(f0raw>0)))  ...
		  max(avf0*sqrt(2),1.05*max(f0raw(f0raw>0)))]);
	  end;
%	  xlabel('time (ms)');
	  ylabel('F0 (Hz)');
%----------- 31/July/1999
	  hold on;
%	  dn=floor(fs/(800*3*2));
      dn=floor(fs/(f0ceil*3*2)); % fix by H.K. at 28/Jan./2003
%	  [f0raw,ecr]=refineF02(decimate(xold,dn),fs/dn,f0raw,512,1.1,3,f0shiftm,1,length(f0raw));
%	  [f0raw,ecr]=refineF06(decimate(xold,dn),fs/dn,f0raw,512,1.1,3,f0shiftm,1,length(f0raw));
	  [f0raw,ecr]=refineF06(decimate(xold,dn),fs/dn,f0raw,1024,1.1,3,f0shiftm,1,length(f0raw)); % 31/Aug./2004
	  f0t=f0raw;avf0=mean(f0raw(f0raw>0));
	  f0t(f0t==0)=f0t(f0t==0)*NaN;tt=1:length(f0t);
%	  keyboard;
	  subplot(615);plot(tt*shiftm,f0t,'k');hold off;
	  drawnow  
%----------- 31/July/1999

	  tirms=irms;
	  tirms(f0raw==0)=tirms(f0raw==0)*NaN;
	  tirms(f0raw>0)=-20*log10(tirms(f0raw>0));
	  ecrt=ecr;
	  ecrt(f0raw==0)=ecrt(f0raw==0)*NaN;
	  subplot(616);hrms=plot(tt*shiftm,tirms,'g',tt*shiftm,20*log10(ecrt),'r'); %31/July/1999
	  set(hrms,'LineWidth',[2]);hold on
%	  for ii=1:mm
%		  if f0raw(ii)>0
%			  plot(tt(ii)*shiftm,-10*log10(vrv(1:nf(ii),ii)),'k.');
%		  end;
%	  end;
	  plot(tt*shiftm,-10*log10(vrv),'k.');
	  grid on;hold off
	  axis([1 max(tt)*shiftm -10 60]);
	  xlabel('time (ms)');ylabel('C/N (dB)');
	  drawnow;
%	  xlabel('time (ms)');ylabel('level (dB)');

%========== This part is deleted on 18/July/1999. ========
%	  xfun=genfund(f0raw,fs,amp+max(amp)/500,1);
%	  if length(xfun)<length(xold)
%		  xl=xold*0;
%		  xl(1:length(xfun))=xfun;
%		  xl(length(xfun):length(xold))=xl(1:length(xold)-length(xfun)+1)*0+xfun(1);
%		  xfun=xl;
%	  else
%		  xfun=xfun(1:length(xold));
%	  end;
%	  [f0vz,vrvz,dfvz,nfz,aavz]=fixpF0VexMltpBG4(xfun,fs,f0floor,nvc,nvo,1.2,0,shiftm,1,5,0.5,1);
%	  kk=figure;
%	  [pwtz,pwhz]=plotcpower(xold,fs,shiftm);drawnow;close(kk);
%	  [f0rawz,irmsz,dfz,ampz]=f0track4(f0vz,vrvz,dfvz,pwtz,pwhz,aavz,shiftm);
%========== deletion end on 18/July/1999
	  irmsz=irms*0;
	  
   %---------- This part is for maintaining compatibility with old synthesis routine ----
	  f0var=max(0.00001,irms-irmsz).^2;
	  f0var(f0var>0.99)=f0var(f0var>0.99)*0+100;
	  f0var(f0raw==0)=f0var(f0raw==0)*0+100;
	  f0varbak = f0var;  % backup for f0var (18/July/1999)
	  f0var=f0var/2;  %  2 is a magic number. If everything is OK, it should be 1.
	  f0var=(f0var>0.9);  % This modification is to make V/UV decision crisp  (18/July/1999)
	  f0varL=f0var;
   %-------------------------------------------------------------------------------------
      f0raw(f0raw<=0)=f0raw(f0raw<=0)*0; % safeguard 31/August/2004
      f0raw(f0raw>f0ceil)=f0raw(f0raw>f0ceil)*0+f0ceil; % safeguard 31/August/2004

	  straightCIv1 syncbuttons;
	  
	%--------------------------------------------------------------
	%	classic STRAIGHT with a single V/UV measure
	%--------------------------------------------------------------
  case 'straightcore'
	  disp('% Now, adaptive window analysis has started. Please wait a moment.');
	  [n2sgrambk,nsgram]=straightBodyC03m(xold,fs,shiftm,fftl,f0raw,f0var,f0varL,eta,pc);
	  if mag>0
		  n2sgram=specreshape(fs,n2sgrambk,eta,pc,mag,f0raw);
	  else
		  n2sgram=n2sgrambk;
	  end;
	  straightCIv1 syncbuttons;

	%--------------------------------------------------------------
	%	revised STRAIGHT with a multi band graded V/UV decision (OBSOLATE!!)
	%--------------------------------------------------------------
 case 'bandcorrbtnqqq'
	  [n2sgrambk,nsgram,nwsgram]= ...
 		   straightBodyB04m(xold,fs,shiftm,fftl,f0raw,eta,pc);
	  straightCIv1 syncbuttons;
	  if mag>0
		  n2sgram=specreshape(fs,n2sgrambk,eta,pc,mag,f0raw);
	  else
		  n2sgram=n2sgrambk;
	  end;

	  tv=1:length(n2sgram(1,:));
	  fv=1:length(n2sgram(:,1));
	  fv=(fv-1)/(length(fv)-1)*fs/2;

	  [pcorr,pecorr]=BcorrMap(xold,fs,f0raw,shiftm);

	  wvm3=wfromMap4(pcorr,pecorr,n2sgram,fs);
	  emap=max(pcorr,pecorr);
	  hh=wvm3'*emap;

	  a=0.32;b=15;c=0.15;   % blending parameter; this is very tentative
	  hhb=max(0,(1.0./(1+exp(-(hh-a)*b))-1.0/(1+exp(-(c-a)*b))) ... 
	       /(1.0/(1+exp(-(1-a)*b))-1.0/(1+exp(-(c-a)*b))));
       straightCIv1 syncbuttons;

       

  %-----------------------------------------

  %   MBE type analysis  2/Sept./1999

  %-----------------------------------------     

  case 'bandcorrbtn'

%   	  disp('% Now, adaptive window analysis has started. Please wait a moment.');
	  [n2sgrambk,nsgram]=straightBodyC03ma(xold,fs,shiftm,fftl,f0raw,f0var,f0varL,eta,pc);
	  if mag>0
		  n2sgram=specreshape(fs,n2sgrambk,eta,pc,mag,f0raw);
	  else
		  n2sgram=n2sgrambk;
     end;

%     disp('% MBE type source information extraction starts this takes long');

%     [apv,dpv]=aperiodicpart4(xold,fs,f0raw,f0shiftm,5,fftl/2+1);
%	New aperiodicity measurement program with ERB smoothing 30/May/2001
%	[apvq,dpvq,apve,dpve]=aperiodicpartERB(xold,fs,f0raw,f0shiftm,5,fftl/2+1);
	[apvq,dpvq,apve,dpve]=aperiodicpartERB2(xold,fs,f0raw,f0shiftm,5,fftl/2+1); % 10/April/2002
	apv=10*log10(apvq); % for compatibility
	dpv=10*log10(dpvq); % for compatibility
%- ---------
%   Notes on aperiodicity estimation: The previous implementation of
%   aperiodicity estimation was sensitive to low frequency noise. It is a
%   bad news, because environmental noise usually has its power in the low
%   frequency region. The following corrction uses the C/N information
%   which is the byproduct of fixed point based F0 estimation.
%   by H.K. 04/Feb./2003
%- ---------
    dpv=correctdpv(apv,dpv,5,f0raw,ecrt,f0shiftm,fs); % Aperiodicity correction 04/Feb./2003 by H.K.
%     [apv,dpv]=aperiodicpart5(xold,fs,f0raw,f0shiftm,5,fftl/2+1);

     bv=boundmes2(apv,dpv,fs,f0shiftm,5,fftl/2+1);

     figure;

     semilogy((0:length(bv)-1)*f0shiftm,0.5./10.0.^(bv));grid on;
	 straightCIv1 syncbuttons;

  case 'remove2ndstructue'
	  n3sgram=rmv2nd(n2sgram,f0raw,fs);
	  straightCIv1 syncbuttons;

  case 'bypassbtn'
	  n3sgram=n2sgram;
	  straightCIv1 syncbuttons;
	  
%-----------------------------------------------------------------
%	suppress buttons which are nor appropriate
%-----------------------------------------------------------------
  case 'syncbuttons'
	  hh=findobj('Tag','analyzesrcbtn');
	  if length(xold) >fftl
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','bandcorrbtn');
	  if length(f0raw) >5
        set(hh,'Enable','on');  % Enabled again 02/Sept./1999	  

      else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','analyzespcbtn');
	  if length(f0raw) >5
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','bypassbtn');
	  if length(n2sgram) >2
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','remove2ndbtn');
	  if length(n2sgram) >2
%		  set(hh,'Enable','on');  % commented out at 21/July/1999
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','synthgradbtn');
	  if (length(bv) >2) & (length(n3sgram)>2)
        %		  set(hh,'Enable','on');  % commented out at 21/July/1999

          set(hh,'Enable','on');  % enabled again at 02/Sept./1999
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','synthesizebtn');
	  if length(n3sgram) >2
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','savetobtn');
	  if length(sy) >fftl
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','adaptivespecbtn');
	  if length(nsgram) >1
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','widespecbtn');
	  if length(nwsgram) >1
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','smoothedspecbtn');
	  if length(n2sgrambk) >1
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','dispn2sgrambtn');
	  if length(n2sgram) >1
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','removedspecbtn');
	  if length(n3sgram) >1
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','cmpstspecgrambtn');
	  if length(hhb) >1
%		  set(hh,'Enable','on');  %  commented out on 21/July/1999
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','playorgbtn');
	  if length(xold) >1
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;
	  %----------------------------------------------------
	  hh=findobj('Tag','playsynthbtn');
	  if length(sy) >1
		  set(hh,'Enable','on');
	  else
		  set(hh,'Enable','off');
	  end;

  end;

  function defaultendian=chkdefaultendian
  %	defaultendian	: 1-littel endian, 2-big endian
  
  gg=computer;
  switch gg(1:3)
  case 'PCW'
	  defaultendian=1;
  case 'MAC'
	  defaultendian=2;
  case 'SUN'
	  defaultendian=2;
  case 'SOL'
	  defaultendian=2;
  case 'HP7'
	  defaultendian=1;
  case 'SGI'
	  defaultendian=2;
  case 'ALP'
	  defaultendian=1;
  case 'AXP'
	  defaultendian=1;
  case 'LNX'
	  defaultendian=1;
  otherwise
	  defaultendian=2;
  end;
  
