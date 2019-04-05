function oki=syncgui()

%	synchronize GUI and internal values

global n2sgram nsgram n3sgram n2sgrambk n3sgramE xold x f0floor f0ceil fs framem shiftm f0shiftm ...
  fftl eta pc framel fftl2 acth pwth pcnv fconv sconv delsp gdbw cornf fname ofname delfracind ...
  tpath cpath paraminitialized mag delfrac hr f0raw f0l f0var f0varL sy pcorr pecorr ...
  upsampleon gobjlist hhb defaultendian  indefaultendian outdefaultendian

framel=round(framem*fs/1000);
if fftl<framel
  disp('Warning! fftl is too small.');
  fftl=2^ceil(log(framel)/log(2) );
  disp(['New length:' num2str(fftl) ' is used.']);
end;

hh=findobj('Tag','f0flooredit');
set(hh,'string',num2str(f0floor));

hh=findobj('Tag','f0ceiledit');
set(hh,'string',num2str(f0ceil));

hh=findobj('Tag','samplingfreqmenu');
fsv=[48000 44100 32000 24000 22050 20000 16000 12500 12000 11025 10000 8000];
set(hh,'Value',max(1,min(11,find(abs(fsv/fs-1)<0.02))))

hh=findobj('Tag','shiftmedit');
set(hh,'string',num2str(f0shiftm));

hh=findobj('Tag','wndwstrtchedit');
set(hh,'string',num2str(eta));

hh=findobj('Tag','pwrcnstntedit');
set(hh,'string',num2str(pc));

hh=findobj('Tag','magfactoredit');
set(hh,'string',num2str(mag));

hh=findobj('Tag','delfracedit');
set(hh,'string',num2str(delfrac));

hh=findobj('Tag','delspedit');
set(hh,'string',num2str(delsp));

hh=findobj('Tag','cornfedit');
set(hh,'string',num2str(cornf));

hh=findobj('Tag','gdbwedit');
set(hh,'string',num2str(gdbw));

hh=findobj('Tag','pcnvedit');
set(hh,'string',num2str(pcnv));
hh=findobj('Tag','pcnvslider');
set(hh,'Value',log10(pcnv));

hh=findobj('Tag','fconvedit');
set(hh,'string',num2str(fconv));
hh=findobj('Tag','fconvslider');
set(hh,'Value',log10(fconv)/log10(3));

hh=findobj('Tag','sconvedit');
set(hh,'string',num2str(sconv));
hh=findobj('Tag','sconvslider');
set(hh,'Value',log10(sconv));

hh=findobj('Tag','fftledit');
set(hh,'string',num2str(fftl));

hh=findobj('Tag','tpathedit');
set(hh,'string',tpath);

hh=findobj('Tag','delfracradio');
set(hh,'Value',delfracind);
hh=findobj('Tag','delspradio');
set(hh,'Value',~delfracind);

hh=findobj('Tag','upsamplebtn');
set(hh,'Value',upsampleon);

hh=findobj('Tag','soundfilename');
set(hh,'string',fname);

hh=findobj('Tag','bininputformat');
set(hh,'Value',indefaultendian);

hh=findobj('Tag','binoutputformat');
set(hh,'Value',outdefaultendian);


oki='ok';
