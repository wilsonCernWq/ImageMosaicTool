function p = PhaseCorrelation(f,g,sigma,enableGPU)
% PHASECORRELATION Function to calculate the phase correlation matrix
%
%   p = PhaseCorrelation(f,g,sigma,enableGPU)
% 
n = max(size(f),size(g));
f = PadImage(f,n);
g = PadImage(g,n);
n = n * 2;
if enableGPU
    f = gpuArray(f);
    g = gpuArray(g);
    H = gpuArray(LowPassFilter(sigma,n(1),n(2)));
else
    H = LowPassFilter(sigma,n(1),n(2));
end
F = fftshift(fft2(f,n(1),n(2)));
G = fftshift(fft2(g,n(1),n(2)));
P = conj(F) .* G;
p = ifft2(ifftshift(H.* P./abs(P)));
if enableGPU
    p = gather(fftshift(abs(p)));
else
    p = fftshift(abs(p));
end
end