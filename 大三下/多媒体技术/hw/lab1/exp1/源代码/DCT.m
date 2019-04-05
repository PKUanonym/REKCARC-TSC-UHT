% 读入原始图片
img = imread('lena.bmp');

% 转化为灰度并输出
gray = rgb2gray(img);
imwrite(gray , 'gray-lena.bmp');
psnr_gray = im2double(gray); 

% 1D-dct first-Row-Then-Column
tic;
temp = im2double(gray);% MATLAB中读入图像的数据类型是uint8，而在矩阵中使用的数据类型是double
for i = 1 : 1 : 512  % first row
    D1_dct(i , :) = dct(temp(i , :) , 512);
end;
imwrite(D1_dct , 'D1_row.bmp');
for i = 1 : 1 : 512  % then column
    D1_dct(: , i) = dct(D1_dct(: , i) , 512);
end
imwrite(D1_dct , 'D1_column.bmp');
toc;

% 1D-idct
tempp = D1_dct;
for i = 1 : 1 : 512  % first colume
    D1_idct(: , i) = idct(tempp(: , i) , 512);
end
for i = 1 : 1 : 512  % then row
    D1_idct(i , :) = idct(D1_idct(i , :) , 512);
end
imwrite(D1_idct , 'D1_idct.bmp');
% 1D-idct PSNR
psnr_1 = my_psnr(psnr_gray , D1_idct);
disp(psnr_1);

% 2D-dct on the whole image
tic;
D2_dct = im2double(gray);
D2_dct = dct2(D2_dct);
toc;
imwrite(D2_dct , 'D2_dct.bmp');
% 2D-idct
D2_idct = D2_dct;
D2_idct = idct2(D2_idct);
imwrite(D2_idct , 'D2_idct.bmp');
% 2D-idct PSNR
psnr_2 = my_psnr(psnr_gray , D2_idct);
disp(psnr_2);

% 2D-dct on 8*8 blocks 
% 参考 http://www.ilovematlab.cn/thread-93793-1-1.html、http://www.doc88.com/p-2129986101481.html
tic;
Block8_D2_dct = im2double(gray);
T = dctmtx(8);
I2 = blkproc(Block_D2_dct , [8 8] , 'P1*x*P2' , T , T');  %进行反余弦变换，得到压缩后的图象
toc;
imwrite(I2 , 'D2_with_block_dct.bmp');
% 2D-idct on 8*8 blocks
Block8_D2_idct = blkproc(I2 , [8 8] , 'P1*x*P2' , T' , T);
imwrite(Block8_D2_idct , 'D2_with_block_idct.bmp');
% 2D-idct on 8*8 blocks PSNR
psnr_3 = my_psnr(psnr_gray , Block8_D2_idct);
disp(psnr_3);

% 下面对DCT系数进行压缩。
c = [1/4 , 1/16 , 1/64];
% 1D-DCT
for j = 1 : 3
    tic;
    test = coefficients(D2_dct , c(j) , 0);
    for i = 1 : 1 : 512  % first colume
        result(: , i) = idct(test(: , i) , 512);
    end
    for i = 1 : 1 : 512  % then row
        result(i , :) = idct(result(i , :) , 512);
    end
    toc;
    imwrite(result , ['D1_',num2str(c(j)),'_idct.bmp']);
    % % 1D-idct PSNR
    psnr_4 = my_psnr(psnr_gray , result);
    disp(psnr_4);
end

% 2D-DCT
for j = 1 : 3
    tic;
    test = coefficients(D1_dct , c(j) , 0);
    D2_idct = idct2(test);
    toc;
    imwrite(D2_idct , ['D2_',num2str(c(j)),'_idct.bmp']);
    % % 1D-idct PSNR
    psnr_5 = my_psnr(psnr_gray , D2_idct);
    disp(psnr_5);
end

% 2D-idct on 8*8 blocks
for j = 1 : 3
    tic;
    result = coefficients(I2 , c(j) , 1);
    toc;
    imwrite(result , ['D2_',num2str(c(j)),'_with_block_idct.bmp']);
    psnr_6 = my_psnr(psnr_gray , result);
    disp(psnr_6);
end
     