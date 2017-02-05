function [obj] = getImageAlpha(obj, option, M)
% GETIMAGEALPHA function fo calculate alpha map for image
%
%   [obj] = getImageAlpha(obj, M, option)
%
% added fields are
%   bdMin
%   bdMax
%   bds: warped boundies
%   ctr: warped image center
%   dim: warped axis aligned bonding box dimension
dimOri = size(obj.img);
bds = [1,dimOri(1),dimOri(1),1;1,1,dimOri(2),dimOri(2);1,1,1,1];
if exist('M','var')
    bds = round(mosaic.normalize(M * bds));
end
bds = mosaic.homo2cart(bds);
bdMin = min(bds,[],2);
bdMax = max(bds,[],2);
dim = bdMax - bdMin + 1;
ctr = mean(bds,2);
obj.bdMin = bdMin;
obj.bdMax = bdMax;
obj.ctr = ctr;
obj.bds = bds;
obj.dim = [dim; 3];
% get alpha channel
obj.img = double(obj.img);
if strcmp(option('feathering'),'false')
    obj.img(:,:,4) = 1;
else
    [x,y] = ndgrid(1:dimOri(1),1:dimOri(2));
    X = abs(x - dimOri(1) * 0.5) / dimOri(1);
    Y = abs(y - dimOri(2) * 0.5) / dimOri(2);
    % ---> calculate alpha layer here for fast processing
    a = 50;   % parameter for fermi-dirac distribution
    b = 0.45; % parameter for fermi-dirac distribution
    obj.img(:,:,4) = 1 ./ ((exp(a*(abs(X)-b))+1) .* (exp(a*(abs(Y)-b))+1));
    % ---<
end
end