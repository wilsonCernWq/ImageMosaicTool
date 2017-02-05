function H = LowPassFilter(sigma, lenX, lenY)
% LOWPASSFILTER Function to compute a gaussian low pass filter
%
%   P = LowPassFilter(sigma, lenX, lenY)
%
% sigma Relative standard deviation (std/len)
%
[x,y] = ndgrid(1:lenX,1:lenY);
sx = lenX * sigma;
sy = lenY * sigma;
H = exp(-2*((x-lenX/2)/2/sx/sx).^2 - 2*((y-lenY/2)/2/sy/sy).^2);
end