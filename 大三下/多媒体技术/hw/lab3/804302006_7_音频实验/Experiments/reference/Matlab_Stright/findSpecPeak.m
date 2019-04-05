function [peak,peakLeft,peakRight]=findSpecPeak(n3sgramFrame)
        %一次导数
        diff1=diff(n3sgramFrame);
        %二次导数
    %    diff2=diff(diff1);
        [peakValue,peak]=max(n3sgramFrame);
        disp(strcat('波峰at time : ',num2str(peak)));
        peakLeft=peak;
        for j=peak:-1:2
            tempLeft=j;
            if tempLeft>20
                tempLeft=tempLeft-10;
            else
                tempLeft=1;
            end
            if(n3sgramFrame(j)==min(n3sgramFrame(tempLeft:j+10)))
                %也许是最小值?
                peakLeft=j;
                peakLeftValue=n3sgramFrame(j);
                break;
            end
        end
        if(peakLeft==peak)
            peakLeft=1;
        end
        disp(strcat('左波谷at time : ',num2str(peakLeft)));
        for j=peak:length(n3sgramFrame)
            tempLeft=j;
            if tempLeft-peak>10
                tempLeft=tempLeft-10;
            else
                tempLeft=peak;
            end
            if(n3sgramFrame(j)==min(n3sgramFrame(tempLeft:j+10)))
                %也许是最小值?
                peakRight=j;
                peakRightValue=n3sgramFrame(j);
                break;
            end
        end
        disp(strcat('右波谷at time : ',num2str(peakRight)));
        figure;plot(n3sgramFrame);
return;