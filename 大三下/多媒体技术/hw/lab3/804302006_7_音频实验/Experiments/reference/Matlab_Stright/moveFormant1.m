function [adjustedSpec,adjustedAp] = moveFormant1(src,srcap,tgt_raw,percentage)

%考虑帧间的移动
%第i帧的移动程度也要以一定程度影响到另外的几帧

%找出应当移动的程度

len_x0=length(src(1,:));
len_x1=length(tgt_raw(1,:));
%调整大小为一样大
tgt = resample(tgt_raw',len_x0,len_x1)';

srcformant=markformant(src);
tgtformant=markformant(tgt);


%开始循环

%两个共振峰矩阵的最大值:
maxsrc=max(max(srcformant));
maxtgt=max(max(tgtformant));

adjustedSpec=zeros(length(srcformant(:,1)),len_x0);
adjustedAp=zeros(length(srcformant(:,1)),len_x0);

for i=3:len_x0-2
    %formant position of current source frame
    [valuesrc,possrc]=max(srcformant(:,i));
    [valuetgt,postgt]=max(tgtformant(:,i));    
%    if valuesrc*10>maxsrc&&valuetgt*10>maxtgt
%     if possrc >1 &&postgt >1
        adjustedSpec(:,i-2)=adjustedSpec(:,i-2)+moveFrameFormant(src(:,i),possrc,postgt,percentage)*0.2/2.8;
        adjustedSpec(:,i-1)=adjustedSpec(:,i-1)+moveFrameFormant(src(:,i),possrc,postgt,percentage)*0.7/2.8;
        adjustedSpec(:,i)=adjustedSpec(:,i)+moveFrameFormant(src(:,i),possrc,postgt,percentage);
        adjustedSpec(:,i+1)=adjustedSpec(:,i+1)+moveFrameFormant(src(:,i),possrc,postgt,percentage)*0.7/2.8;
        adjustedSpec(:,i+2)=adjustedSpec(:,i+2)+moveFrameFormant(src(:,i),possrc,postgt,percentage)*0.2/2.8;

        adjustedAp(:,i-2)=adjustedAp(:,i-2)+moveFrameFormant(srcap(:,i),possrc,postgt,percentage)*0.2/2.8;
        adjustedAp(:,i-1)=adjustedAp(:,i-1)+moveFrameFormant(srcap(:,i),possrc,postgt,percentage)*0.7/2.8;
        adjustedAp(:,i)=adjustedAp(:,i)+moveFrameFormant(srcap(:,i),possrc,postgt,percentage);
        adjustedAp(:,i+1)=adjustedAp(:,i+1)+moveFrameFormant(srcap(:,i),possrc,postgt,percentage)*0.7/2.8;
        adjustedAp(:,i+2)=adjustedAp(:,i+2)+moveFrameFormant(srcap(:,i),possrc,postgt,percentage)*0.2/2.8;

%   end
end

return; 