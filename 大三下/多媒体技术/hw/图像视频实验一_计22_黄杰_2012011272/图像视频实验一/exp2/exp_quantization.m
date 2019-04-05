function [av_Psnr Psnr] = exp_quantization( GR,Q , name )
    %UNTITLED4 Summary of this function goes here
    %   Detailed explanation goes here
    fprintf(name);
    [h w] = size(GR);
    hh=[];
    ww=[];
    for i=1:h/8
        hh=[hh 8];
    end
    for i=1:w/8
        ww=[ww 8];
    end
    c = mat2cell(GR,hh,ww);
    old_c=c;
    % Using Q to quantize the DCT coefficients
    for i = 1:h/8
        for j = 1:w/8
            c{i,j} = round(dct2(c{i,j})./Q).*Q;
        end
    end

    sum = 0;
    for i = 1:h/8
        for j = 1:w/8
            c{i,j} = idct2(c{i,j});
            p=psnr(c{i,j},old_c{i,j});
            sum=sum+p;
        end
    end
    av_Psnr = sum / (h/8) / (w/8);
    c=cell2mat(c);
    imwrite(mat2gray(c), [name,'.bmp']);
    Psnr = psnr(GR,c);
end


