function adjustedSpec = moveFormant(src,tgt,percentage)

%找出应当移动的程度
srcformant=markformant(src);
tgtformant=markformant(tgt);

len_x0=length(srcformant(1,:));
len_x1=length(tgtformant(1,:));

%调整大小为一样大


%开始循环

%两个共振峰矩阵的最大值:
maxsrc=max(max(srcformant));
maxtgt=max(max(tgtformant));

adjustedSpec=zeros(length(srcformant(:,1)),len_x0);

for i=1:len_x0
    %formant position of current source frame
    [valuesrc,possrc]=max(srcformant(:,i));
    [valuetgt,postgt]=max(tgtformant(:,i));    
    if valuesrc*10>maxsrc&&valuetgt*10>maxtgt
        adjustedSpec(:,i)=moveFrameFormant(src(:,i),possrc,postgt,percentage);
    end
end

return; 