%% functionname: function description
function [PSNR] = psnr(img, imgn)
    img=double(img);
    imgn=double(imgn);
    [h w]=size(img);
    B=8;                %编码一个像素用多少二进制位
    MAX=2^B-1;          %图像有多少灰度级
    MES=sum(sum((img-imgn).^2))/(h*w);     %均方差
    PSNR=20*log10(MAX/sqrt(MES));           %峰值信噪比
end
