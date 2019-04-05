function [ y ] = my_2dct( x , Q )
    % 使用blkproc对矩阵进行分块，参数中传入的x为8*8的矩阵(总共会遍历4096次)，Q为量化参数
    global sum;
    % 首先对8*8的矩阵进行2D-dct变化
    D2_dct = dct2(x);
    % 然后对2D-dct的结果进行量化。量化公式参考 http://bbs.csdn.net/topics/310026388
    temp = round(D2_dct ./ Q);
    % 量化后，求2D-idct时，需要进行逆量化，否则得到的PSNR值会很小，图片都是黑的
    D2_idct = idct2(temp .* Q);
    y = D2_idct;
    % 计算每个8*8矩阵的PSNR，并保存到Q_1_data.txt文件中
    psnr_ans = my_psnr(y , x);
%     fid = fopen('Q_1_data.txt' , 'a');
%     fprintf(fid , '\n' , psnr_ans);
%     fclose(fid);
    % 记录总共的PSNR，用于计算均值
    sum = sum  + psnr_ans;
end

