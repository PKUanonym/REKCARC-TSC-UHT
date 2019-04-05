function y=smax(x,a,b)

y0=1.0/(1+exp(-a*(0-b)));
y1=1.0/(1+exp(-a*(1-b)));
y=(1.0./(1+exp(-a*(x-b)))-y0)/(y1-y0);