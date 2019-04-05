function [ y ] = my_2dct_use_matcell( x , Q )
    global sum;
    % 对于传入的512*512的矩阵，使用mat2cell进行8*8分块。
    % mat2cell分块参考：http://zhidao.baidu.com/question/129455191.html
    origin = mat2cell(x , ones(64 , 1)*8 , ones(64 , 1)*8);
    temp = origin;
    % 然后对每一个小分块进行2D-DCT，并进行量化。 量化用到的公式参考 http://bbs.csdn.net/topics/310026388
    for i = 1 : 64
        for j = 1 : 64 % 总共4096个8*8的分块
            temp{i , j} = round(dct2(temp{i , j}) ./ Q);
        end
    end
    % 然后再进行2D-idct，并和原始8*8分块进行计算PSNR
    % 在进行2D-idct之前，需要逆量化，否则得到的图片基本都是黑的，PSNR很小
    for i = 1 : 64
        for j = 1 : 64
            temp{i , j} = idct2(temp{i , j} .* Q);
            psnr_ans = my_psnr(temp{i , j} , origin{i , j});
            disp(psnr_ans);
            sum = sum + psnr_ans;
        end
    end
    % 计算平均的PSNR
    psnr_averge = sum / 4096;
    disp('avg:');
    disp (psnr_averge);
    y = psnr_averge;
    % 还原成原始的512*512的矩阵，计算整张图片的PNSR值，并还原图片
    big_idct = mat2gray(cell2mat(temp));
    disp('512*512 PSNR:');
    disp(my_psnr(big_idct , x));
    imwrite(big_idct , 'Q.bmp');
    
end

