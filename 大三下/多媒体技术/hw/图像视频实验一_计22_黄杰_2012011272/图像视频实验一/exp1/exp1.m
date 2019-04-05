clc;
%prepare image
RGB = imread('lena.bmp');
GR = rgb2gray(RGB);
imwrite(mat2gray(GR), 'GR_real.bmp');

%1D-DCT on the whole image
tic;
for j=1:20
D1_dct = dct(GR');%First-Row
D1_dct= dct(D1_dct');%Then-Column
end
toc;

%2D-DCT on the whole image
tic;
for j=1:20
D2_dct = dct2(GR);
end
toc;
%2D-DCT on 8*8 blocks 
[h w] = size(GR);
hh=[];
ww=[];
for i=1:h/8
    hh=[hh 8];
end
for i=1:w/8
    ww=[ww 8];
end
tic;
for jj=1:20
c = mat2cell(GR, hh, ww);
for i = 1:h/8
	for j = 1:w/8
		c{i,j} = dct2(c{i,j});
	end
end
D2_dct_8_8 = cell2mat(c);
end
toc;

%using 1/4,1/16, 1/64 DCT coefficients
%1D
co = [1 1/4,1/16,1/64];
for i=1:4

    D1_dct_c = coefficients(co(i),D1_dct,1);
    tic;
    for jj=1:20
    ID1_dct_c = idct(D1_dct_c);
    ID1_dct_c = idct(ID1_dct_c')';
    end
    toc;
    imwrite(mat2gray(ID1_dct_c), ['1D_dct_c_',num2str(co(i)),'.bmp']);
    psnr(GR, ID1_dct_c)
    
end
%using 1/4,1/16, 1/64 DCT coefficients
%2D
co = [1 1/4,1/16,1/64];
for i=1:4
    D2_dct_c = coefficients(co(i),D2_dct,1);
    tic;
    for j=1:20
    ID2_dct_c = idct2(D2_dct_c);
    end
    toc;
    imwrite(mat2gray(ID2_dct_c), ['2D_dct_c_',num2str(co(i)),'.bmp']);
    psnr(GR, ID2_dct_c)
   
end

%using 1/4,1/16, 1/64 DCT coefficients
%2D
co = [1 1/4,1/16,1/64];
for i=1:4

    D2_dct_8_8_c = coefficients(co(i),D2_dct_8_8,2);
    tic;
    for j=1:20
    %D2_dct_8_8_c=D2_dct_8_8;
    c = mat2cell(D2_dct_8_8_c, hh, ww);
    for ii = 1:h/8
        for j = 1:w/8
            c{ii,j} = idct2(c{ii,j});
        end
    end
    D2_idct_8_8_c = cell2mat(c);
    end
    toc;
    imwrite(mat2gray(D2_idct_8_8_c), ['2D_dct_8_8_c_',num2str(co(i)),'.bmp']);
    psnr(GR, D2_idct_8_8_c)
    
end




