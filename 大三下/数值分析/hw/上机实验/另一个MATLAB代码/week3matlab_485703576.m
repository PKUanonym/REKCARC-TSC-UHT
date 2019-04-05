>> doc roots
>> r=roots([1 0 0 -1 -2])

r =

   1.3532          
  -0.1766 + 1.2028i
  -0.1766 - 1.2028i
  -1.0000          

>> a=2;
>> f= @(x) sign(x-a)*sqrt(abs(x-a));
>> fzero(f, [1, 2.5])

ans =

    2.0000

>> doc fzero
>> opt= optimset('display', 'iter');
>> fzero(f, [1, 2.5], opt)
 
 Func-count    x          f(x)             Procedure
    2             2.5      0.707107        initial
    3         1.87868     -0.348311        interpolation
    4         2.08373      0.289359        interpolation
    5         1.99068    -0.0965274        interpolation
    6         1.99068    -0.0965274        interpolation
    7         2.00115     0.0338855        interpolation
    8         2.00115     0.0338855        interpolation
    9         1.99989    -0.0102507        interpolation
   10         1.99989    -0.0102507        interpolation
   11         2.00002    0.00445256        interpolation
   12         1.99998   -0.00424246        interpolation
   13               2   0.000675597        interpolation
   14               2   0.000675597        interpolation
   15               2  -0.000593691        interpolation
   16               2    0.00016088        interpolation
   17               2    0.00016088        interpolation
   18               2  -8.35317e-05        interpolation
   19               2    6.5214e-05        interpolation
   20               2  -2.59006e-05        interpolation
   21               2  -2.59006e-05        interpolation
   22               2   3.80537e-06        interpolation
   23               2   3.80537e-06        interpolation
   24               2  -3.53999e-06        interpolation
   25               2   6.97654e-07        interpolation
   26               2   6.97654e-07        interpolation
   27               2  -5.16406e-07        interpolation
   28               2   2.31808e-07        interpolation
   29               2  -2.13352e-07        interpolation
   30               2   4.71216e-08        interpolation
   31               2   4.71216e-08        interpolation
   32               2  -2.98023e-08        interpolation
   33               2   2.10734e-08        interpolation
 
Zero found in the interval [1, 2.5]

ans =

    2.0000

>> fzero(f, 1, opt)
 
Search for an interval around 1 containing a sign change:
 Func-count    a          f(a)             b          f(b)        Procedure
    1               1            -1             1            -1   initial interval
    3        0.971716      -1.01404       1.02828     -0.985756   search
    5            0.96       -1.0198          1.04     -0.979796   search
    7        0.943431       -1.0279       1.05657     -0.971304   search
    9            0.92      -1.03923          1.08     -0.959166   search
   11        0.886863      -1.05505       1.11314     -0.941734   search
   13            0.84      -1.07703          1.16     -0.916515   search
   15        0.773726      -1.10737       1.22627     -0.879617   search
   17            0.68      -1.14891          1.32     -0.824621   search
   19        0.547452      -1.20522       1.45255       -0.7399   search
   21            0.36      -1.28062          1.64          -0.6   search
   23       0.0949033      -1.38025        1.9051     -0.308064   search
   25           -0.28      -1.50997          2.28       0.52915   search
 
Search for a zero in the interval [-0.28, 2.28]:
 Func-count    x          f(x)             Procedure
   25            2.28       0.52915        initial
   26            2.28       0.52915        interpolation
   27         1.97408     -0.160988        interpolation
   28         1.97408     -0.160988        interpolation
   29         2.00479     0.0691863        interpolation
   30         1.99556    -0.0666504        interpolation
   31         2.00009    0.00927834        interpolation
   32         2.00009    0.00927834        interpolation
   33         1.99992   -0.00894969        interpolation
   34               2    0.00122358        interpolation
   35               2    0.00122358        interpolation
   36               2   -0.00119427        interpolation
   37               2   0.000133075        interpolation
   38               2   0.000133075        interpolation
   39               2   0.000133075        interpolation
   40               2  -3.13315e-05        interpolation
   41               2  -3.13315e-05        interpolation
   42               2   1.94218e-05        interpolation
   43               2  -1.19496e-05        interpolation
   44               2   7.43492e-06        interpolation
   45               2  -4.54886e-06        interpolation
   46               2   2.85395e-06        interpolation
   47               2  -1.72403e-06        interpolation
   48               2   1.10208e-06        interpolation
   49               2  -6.46614e-07        interpolation
   50               2   4.30847e-07        interpolation
   51               2  -2.36079e-07        interpolation
   52               2   1.72493e-07        interpolation
   53               2  -8.02452e-08        interpolation
   54               2   6.98926e-08        interpolation
   55               2  -2.10734e-08        interpolation
   56               2  -2.10734e-08        interpolation
 
Zero found in the interval [-0.28, 2.28]

ans =

    2.0000

>> edit t_pipe.m
>> fzero(@t_pipe, 1.5)

ans =

    0.6770

>> fzero(@t_pipe, 1.5, opt)
 
Search for an interval around 1.5 containing a sign change:
 Func-count    a          f(a)             b          f(b)        Procedure
    1             1.5       12.6558           1.5       12.6558   initial interval
    3         1.45757       12.1945       1.54243        13.097   search
    5            1.44       11.9975          1.56        13.274   search
    7         1.41515       11.7128       1.58485       13.5185   search
    9            1.38       11.2982          1.62        13.853   search
   11         1.33029       10.6873       1.66971       14.3039   search
   13            1.26        9.7741          1.74       14.8983   search
   15         1.16059       8.38303       1.83941       15.6563   search
   17            1.02       6.21674          1.98       16.5748   search
   19        0.821177        2.7664       2.17882       17.6015   search
   20            0.54      -2.80836       2.17882       17.6015   search
 
Search for a zero in the interval [0.54, 2.17882]:
 Func-count    x          f(x)             Procedure
   20            0.54      -2.80836        initial
   21        0.765499        1.7232        interpolation
   22        0.679749     0.0554051        interpolation
   23        0.676956  -0.000126129        interpolation
   24        0.676962   8.32971e-08        interpolation
   25        0.676962   1.29674e-13        interpolation
   26        0.676962  -3.55271e-15        interpolation
   27        0.676962  -3.55271e-15        interpolation
 
Zero found in the interval [0.54, 2.17882]

ans =

    0.6770

>> 