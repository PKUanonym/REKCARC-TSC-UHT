function [f0,irms,df,amp]=f0track5(f0v,vrv,dfv,pwt,pwh,aav,shiftm,imgi);

%	F0 trajectory tracker
%	[f0,irms,df,amp]=f0track2(f0v,vrv,dfv,shiftm,imgi)
%		f0	: extracted F0 (Hz)
%		irms	: relative interfering energy in rms
%
%	f0v	: fixed point frequency vector
%	vrv	: relative interfering energy vector
%	dfv	: fixed point slope vector
%	pwt	: total power
%	pwh	: power in higher frequency range
%	aav	: amplitude list for fixed points
%	shiftm	: frame update period (ms)
%	imgi	: display indicator, 1: display on (default), 0: off
%	
%	This is a very primitive and conventional algorithm.

%	coded by Hideki Kawahara
%	copyright(c) Wakayama University/CREST/ATR
%	10/April/1999 first version
%	17/May/1999 relative fq jump thresholding
%	01/August/1999 parameter tweeking
%   07/Dec./2002 waitbar was added
%   13/Jan./2005 bug fix on lines 58, 97 (Thanx Ishikasa-san)
%	30/April/2005 modification for Matlab v7.0 compatibility
%	10/Aug./2005 modified  by Takahashi on waitbar
%	10/Sept./2005 modified by Kawahara on waitbar

if nargin==7; imgi=1; end; %10/Sept./2005
vrv=sqrt(vrv);
[nn,mm]=size(vrv);
mm=min(mm,length(pwt));

f0=zeros(1,mm);
irms=ones(1,mm);
df=ones(1,mm);
amp=zeros(1,mm);
von=0;
[mxvr,ixx]=min(vrv);
%hth=0.11;	% highly confident voiced threshould
hth=0.12;	% highly confident voiced threshould (updated on 01/August/1999)
%hth=0.8;	% highly confident voiced threshould (updated on 01/August/1999)
lth=0.9;	% threshold to loose confidence
bklm=100;	% back track length for voicing decision
lalm=10;	% look ahead length for silence decision
bkls=bklm/shiftm;
lals=lalm/shiftm;
htr=10*log10(pwh./pwt);

thf0j=0.025*shiftm; %  2.5 % of F0 is the limit of jump
thf0j=0.04*sqrt(shiftm); %  4 % of F0 is the limit of jump
ii=1;
f0ref=0;
htrth=-2.0; % was -3 mod 2002.6.3
if imgi==1; hpg=waitbar(0,'F0 tracking'); end; % 07/Dec./2002 by H.K.%10/Aug./2005
while ii < mm+1
	if (von == 0) & (mxvr(ii)<hth) & (htr(ii)<htrth)
		von = 1;
		f0ref=f0v(ixx(ii),ii); % start value for search
		for jj=ii:-1:max(1,ii-bkls)
			[gomi,jxx]=min(abs((f0v(:,jj)-f0ref)/f0ref));
			gomi=gomi+(f0ref>10000)+(f0v(jxx,jj)>10000);
			if (((gomi>thf0j) | (vrv(jxx,jj)>lth) | (htr(jj)>htrth))&(f0v(jxx,jj)<1000)) & htr(jj)>-18
%				disp(['break pt1 at ' num2str(jj)])
				break
			end;
			if (gomi>thf0j)
%				disp(['break pt2 at ' num2str(jj)])
				break
			end;
			
			f0(jj)=f0v(jxx,jj);
			irms(jj)=vrv(jxx,jj);
			df(jj)=dfv(jxx,jj);
			amp(jj)=aav(jxx,jj);
			f0ref=f0(jj);
		end;
		f0ref=f0v(ixx(ii),ii);
	end;
	if (f0ref>0) & (f0ref<10000)
		[gomi,jxx]=min(abs((f0v(:,ii)-f0ref)/f0ref));
	else
		gomi=10;
	end;
%	gomi=10;
	if (von ==1) & (mxvr(ii)>hth)
%		f0ref=f0v(ixx(ii),ii); % start value for search
		for jj=ii:min(mm,ii+lals)
			ii=jj;
			[gomi,jxx]=min(abs((f0v(:,ii)-f0ref)/f0ref));
			gomi=gomi+(f0ref>10000)+(f0v(jxx,ii)>10000);
			if (gomi< thf0j) & ((htr(ii)<htrth)+(f0v(jxx,ii)>=1000))
				f0(ii)=f0v(jxx,ii);
				irms(ii)=vrv(jxx,ii);
				df(ii)=dfv(jxx,ii);
				amp(ii)=aav(jxx,ii);
				f0ref=f0(ii);
			end;
%			if (gomi<thf0j) & (mxvr(ii)<hth) & ((htr(ii)<-3)+(f0v(jxx,ii)>=1000))
%				break
%			end;
			if (gomi>thf0j) | (vrv(jxx,ii)>lth) | ((htr(ii)>htrth)&(f0v(jxx,ii)<1000))
				von = 0;f0ref=0;%ii=min(mm,ii+lals);
%				gomi
%				vrv(jxx,ii)
%				disp(['break pt3 at ' num2str(ii)])
				break
			end;
		end;
	elseif (von==1) & (gomi < thf0j)  & ((htr(ii)<htrth)+(f0v(jxx,ii)>=1000))
		f0(ii)=f0v(jxx,ii);
		irms(ii)=vrv(jxx,ii);
		df(ii)=dfv(jxx,ii);
		amp(ii)=aav(jxx,ii);
		f0ref=f0(ii);
	else
		von=0;
	end;
    if imgi==1; waitbar(ii/mm); end; %,hpg); % 07/Dec./2002 by H.K.%10/Aug./2005
	ii=ii+1;
end;
if imgi==1; close(hpg); end;%10/Aug./2005
