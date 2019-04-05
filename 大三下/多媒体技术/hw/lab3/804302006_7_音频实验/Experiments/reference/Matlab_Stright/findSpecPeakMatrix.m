function peaks=findSpecPeakMatrix(n3sgram,vuv)
peaks=zeros(length(n3sgram(:,1)),length(n3sgram(1,:)));
peakLeftTime=0;
peakLeftValue=0;
peakTime=0;
peakValue=0;
peakRightTime=0;
peakRightValue=0;
for i=160:170
% for i=1:length(n3sgram(1,:))
    if(vuv(i)==1)
        n3sgramFrame=n3sgram(:,i);
        %一次导数
        diff1=diff(n3sgramFrame);
        %二次导数
    %    diff2=diff(diff1);
        [peakValue,peakTime]=max(n3sgramFrame);
        disp(strcat('frame : ',num2str(i),', 波峰at time : ',num2str(peakTime)));
        peakLeftTime=peakTime;
        for j=peakTime:-1:2
            tempLeft=j;
            if tempLeft>20
                tempLeft=tempLeft-10;
            else
                tempLeft=1;
            end
            if(n3sgramFrame(j)==min(n3sgramFrame(tempLeft:j+10)))
                %也许是最小值?
                peakLeftTime=j;
                peakLeftValue=n3sgramFrame(j);
                break;
            end
        end
        if(peakLeftTime==peakTime)
            peakLeftTime=1;
        end
        disp(strcat('frame : ',num2str(i),', 左波谷at time : ',num2str(peakLeftTime)));
        for j=peakTime:length(n3sgramFrame)
            tempLeft=j;
            if tempLeft-peakTime>10
                tempLeft=tempLeft-10;
            else
                tempLeft=peakTime;
            end
            if(n3sgramFrame(j)==min(n3sgramFrame(tempLeft:j+10)))
                %也许是最小值?
                peakRightTime=j;
                peakRightValue=n3sgramFrame(j);
                break;
            end
        end
        disp(strcat('frame : ',num2str(i),', 右波谷at time : ',num2str(peakRightTime)));
        plot(n3sgramFrame);
        peaks(peakLeftTime,i)=peakLeftValue;
        peaks(peakTime,i)=peakValue;
        peaks(peakRightTime,i)=peakRightValue;
    end
end