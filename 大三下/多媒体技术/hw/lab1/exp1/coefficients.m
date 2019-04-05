function [ result ] = coefficients( img , choose , flag) % flag=0,为512*512;flag=1，为8*8
% 由于经过dct变换后的系数矩阵，非0的数都集中在左上角，右下角都接近于0，可以将其去掉，实现压缩。
    
    % 512*512矩阵dct压缩，用在前两个实验任务中
    if(flag == 0)
        result = img;
        k = 512 * sqrt(choose);
        for i = 1 : 512
            for j = 1 : 512
                if(i > k || j > k)
                    result(i , j) = 0;
                end
            end
        end         
    end
    if (flag == 1)
        % 8*8的dct压缩参考http://www.doc88.com/p-2129986101481.html
        % 这可以通过一个只有左上角为1的矩阵，配合blkproc函数来实现。通过这个矩阵中1的个数，可以实现不同程度的压缩。
        mask1 = [1 1 1 1 0 0 0 0 % 1/4 DCT
                 1 1 1 1 0 0 0 0
                 1 1 1 1 0 0 0 0
                 1 1 1 1 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0]; 
        mask2 = [1 1 0 0 0 0 0 0 % 1/16 DCT
                 1 1 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0]; 
        mask3 = [1 0 0 0 0 0 0 0 % 1/64 DCT
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0];
        mask = mask1;
        if(choose == 1/4)
            mask = mask1;
        elseif(choose == 1/16)
            mask = mask2;
        else
            mask = mask3;
        end
        T = dctmtx(8);
        B = blkproc(img , [8 8] , 'P1.*x' ,mask); % 保留1/4 或 1/16 或 1/64的DCT系数
        result = blkproc(B , [8 8] , 'P1*x*P2' , T' , T); % 逆变换，重构
    end
end

