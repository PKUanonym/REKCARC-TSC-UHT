function ok=defaultparams
%	function to define default parameters.
%	Please copy this file as defaultparams.m and edit
%	necessary parameters.
%	If defaultparams.m exists, definitions in defaultparams.m
%	override original default parameters.

%	08/Dec./2002 by H.K.

global f0floor f0ceil fs framem shiftm f0shiftm ...
  fftl eta pc framel fftl2 acth pwth pcnv fconv sconv delsp gdbw cornf fname delfracind ...
  tpath paraminitialized mag delfrac hr upsampleon defaultch


	  f0floor=40;  % Lower limit of F0 search range
	  f0ceil=800;  % Upper limit of F0 search range
	  fs=22050;	% sampling frequency (Hz)
	  framem=40;	% default frame length limit for pitch extraction (ms)
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
ok=1;
return;
