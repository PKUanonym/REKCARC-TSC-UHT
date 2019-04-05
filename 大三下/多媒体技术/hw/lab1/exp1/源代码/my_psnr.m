function [ PSNR ] = my_psnr( origin , new )
% 根据公式，计算PSNR
    origin = double(origin);
    new = double(new);
    mse = sum(sum((origin - new).^2)) / length(origin);
    PSNR = 10 * log10(255 * 255 / mse);
end