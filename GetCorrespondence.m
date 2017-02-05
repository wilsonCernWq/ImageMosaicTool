function [t,n] = GetCorrespondence(img1,img2,enableGPU,debug)
% GETCORRESPONDENCE Function to calculate correlationship between two
% images
%
%   [t,n] = GetCorrespondence(img1,img2,enableGPU,debug)
%
% t The translation vector between two images (img1 => img2 + t)
%   t = [] if two images are not correlated
%
% n The dimension of the phase correlation matrox
%
[~,f] = mosaic.readFigure(img1,'gray');
[~,g] = mosaic.readFigure(img2,'gray');
p = PhaseCorrelation(f,g,0.01,enableGPU); 
[position, ~, valid] = PeakFinding(p,debug);
if valid
    t = FindShift(position, size(p));
else
    t = [];
end
n = size(p);
end