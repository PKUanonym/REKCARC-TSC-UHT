function [new_f0raw,new_ap,new_n3sgram] = mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,startTime0,endTime0,startTime1,endTime1,percentage)
%MERGESYLLABLE Summary of this function goes here
%   this function will return a new f0raw/ap/n3sgram mainly based on
%   f0raw0,ap0,n3sgram0. it will copy $percentage% information from
%   f0raw1,ap1,n3sgram1 (from time startTime1 to endTime1), and merge this
%   information with the information from f0raw0,ap0,n3sgram0(from time
%   startTime0 to endTime0)
%   as the length of these two syllables may differ somehow, i will strech
%   the syllable in f0raw1/ap1/n3sgram1 first.
%   Detailed explanation goes here
%   Input parameters
%   f0raw0      : fundamental frequency (Hz)
%   ap0         : amount of aperiodic component in the time frequency
%               : represntation in dB
%   n3sgram0    : Smoothed time frequency representation (spectrogram)
%   startTime0  : the start time of the syllable, represented in ms
%   endTime0    : the end time of the syllable, represented in ms
%       all parameter above is from voice0
%       all parameter below except percentage is from voice1
%   f0raw1      : fundamental frequency (Hz)
%   ap1         : amount of aperiodic component in the time frequency
%               : represntation in dB
%   n3sgram1    : Smoothed time frequency representation (spectrogram)
%   startTime1  : the start time of the syllable, represented in ms
%   endTime1    : the end time of the syllable, represented in ms
%   percentage  : how much infomation should be merged into syllable0.

len_x_f0raw0=length(f0raw0); %the length of the f0raw0
len_x_ap0=length(ap0(1,:));
len_x_n3sgram0=length(n3sgram0(1,:));
len_y = length(ap0(:,1));
%   cut f0raw0 to 3part
f0raw0_pre=f0raw0(1:startTime0-1);
f0raw0_mid=f0raw0(startTime0:endTime0);
f0raw0_post=f0raw0(endTime0+1:len_x_f0raw0);

%   cut ap0 to 3part
ap0_pre=ap0(1:len_y,1:startTime0-1);
ap0_mid=ap0(1:len_y,startTime0:endTime0);
ap0_post=ap0(1:len_y,endTime0+1:len_x_ap0);

%   cut n3sgram to 3part
n3sgram0_pre=n3sgram0(1:len_y,1:startTime0-1);
n3sgram0_mid=n3sgram0(1:len_y,startTime0:endTime0);
n3sgram0_post=n3sgram0(1:len_y,endTime0+1:len_x_n3sgram0);

%   cut out the dest parameter f0raw1_mid,ap1_mid,n3sgram
strechRatio = (endTime0-startTime0+1)/(endTime1-startTime1+1);
f0raw1_streched=resample(f0raw1,endTime0-startTime0+1,endTime1-startTime1+1);
f0raw1_mid=f0raw1_streched(int16(startTime1*strechRatio):int16(startTime1*strechRatio)+endTime0-startTime0);
ap1_streched=resample(ap1',endTime0-startTime0+1,endTime1-startTime1+1)';
ap1_mid=ap1_streched(1:len_y,int16(startTime1*strechRatio):int16(startTime1*strechRatio)+endTime0-startTime0);
n3sgram1_streched=resample(n3sgram1',endTime0-startTime0+1,endTime1-startTime1+1)';
n3sgram1_mid=n3sgram1_streched(1:len_y,int16(startTime1*strechRatio):int16(startTime1*strechRatio)+endTime0-startTime0);

%   extra: do some smooth work
temp_f0raw = [f0raw1_mid(1);f0raw1_mid;f0raw1_mid(length(f0raw1_mid))];
for (i=2:length(temp_f0raw)-1)
	a=temp_f0raw(i-1);
	b=temp_f0raw(i);
	c=temp_f0raw(i+1);
	if (a>=b&&a<=c)||(a<=b&&a>=c)
		temp_f0raw(i)=a;
	end
	if (b>=a&&b<=c)||(b>=c&&b<=a)
		temp_f0raw(i)=b;
    end
	if (c>=a&&c<=b)||(c>=b&&c<=a)
		temp_f0raw(i)=c;
    end
    if temp_f0raw(i)<50
        temp_f0raw(i)=0;
    end
end
f0raw1_mid=temp_f0raw(2:length(temp_f0raw)-1);
%   combine all these data

f0raw0_mid_merged=f0raw0_mid*(1-percentage)+f0raw1_mid*percentage;
ap0_mid_merged=ap0_mid*(1-percentage)+ap1_mid*percentage;
n3sgram0_mid_merged=n3sgram0_mid*(1-percentage)+n3sgram1_mid*percentage;

new_f0raw=[f0raw0_pre;f0raw0_mid_merged;f0raw0_post];
new_ap=[ap0_pre,ap0_mid_merged,ap0_post];
new_n3sgram=abs([n3sgram0_pre,n3sgram0_mid_merged,n3sgram0_post]);

return;













