function [new_f0raw,new_ap,new_n3sgram] = strechSyllable(f0raw,ap,n3sgram,startTime,endTime,expectedLength)
%STRECHSYLLABLE Summary of this function goes here
%   Detailed explanation goes here
% [new_f0raw,new_ap,new_n3sgram]=strechSyllable(f0raw,ap,n3sgram,startTime,endTime,expectedLength)
% this function mainly deals with f0raw/ap/n3sgram comes from input
% it will strech these variable to a proper length which is indicated from
% input
% Input parameters
%   f0raw   : fundamental frequency (Hz)
%   ap  : amount of aperiodic component in the time frequency represntation
%       : represented in dB
%   n3sgram : Smoothed time frequency representation (spectrogram)
%   startTime : the start time of the syllable, represented in ms
%   endTime : the end time of the syllable, represented in ms
%   expectedLength : the expected length of that syllable, represented in ms
% Output parameters
%   new_f0raw   : fundamental frequency (Hz)
%   new_ap  : amount of aperiodic component in the time frequency represntation
%       : represented in dB
%   new_n3sgram : Smoothed time frequency representation (spectrogram)

% len_x0 = length(f0raw);
% len_x1 = length(ap);
% len_x2 = length(n3sgram);
len_x_f0 = length(f0raw);
len_x_ap = length(f0raw);
len_x_n3sgram = length(f0raw);
len_y = length(ap(:,1));

% do some check: 1<startTime<endTime<=len_x
if startTime==1
	f0raw_0=[];
	ap_0=[];
	n3sgram_0=[];
else
	f0raw_0=f0raw(1:startTime-1);
	ap_0=ap(1:len_y,1:startTime-1);
	n3sgram_0=n3sgram(1:len_y,1:startTime-1);
end

% f0raw_1=f0raw(startTime:endTime);
ap_1=ap(1:len_y,startTime:endTime);
n3sgram_1=n3sgram(1:len_y,startTime:endTime);

f0raw_2=f0raw(endTime+1:len_x_f0);
ap_2=ap(1:len_y,endTime+1:len_x_ap);
n3sgram_2=n3sgram(1:len_y,endTime+1:len_x_n3sgram);


f0raw_streched=resample(f0raw,expectedLength,endTime-startTime+1);
f0raw_1=f0raw_streched(int16(startTime*expectedLength/(endTime-startTime+1)):int16(endTime*expectedLength/(endTime-startTime+1)));
if startTime==endTime
	ap_1=repmat(ap_1,1,expectedLength);
	n3sgram_1=repmat(n3sgram_1,1,expectedLength);
else
	ap_1=resample(ap_1',expectedLength,endTime-startTime+1)';
	n3sgram_1=resample(n3sgram_1',expectedLength,endTime-startTime+1)';
end
% do some work to smooth the f0raw_1

temp_f0raw =f0raw_1;
if startTime > 1
    temp_f0raw = [f0raw_0(startTime-1);temp_f0raw];
else
	temp_f0raw= [temp_f0raw(1);temp_f0raw];
end

if endTime < len_x_f0
    temp_f0raw = [temp_f0raw;f0raw_2(1)];
else
	temp_f0raw = [temp_f0raw;temp_f0raw(expectedLength)];
end

for(i=2:length(temp_f0raw)-1)
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
    if temp_f0raw(i)<0
        temp_f0raw(i)=0;
    end
end

if startTime == endTime
	f0raw_1 = ones(expectedLength,1)*f0raw(startTime);
else
	f0raw_1=temp_f0raw(2:expectedLength+1);
end

new_f0raw=[f0raw_0;f0raw_1;f0raw_2];
new_ap=[ap_0,ap_1,ap_2];
new_n3sgram=abs([n3sgram_0,n3sgram_1,n3sgram_2]);
return;



