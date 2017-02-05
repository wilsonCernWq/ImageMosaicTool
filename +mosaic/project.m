function data = project(data)
% PROJECT function to warp images and stitich images
% 
%   data = project(data)
%
% calculate new image size based on all images related
for i = 1:data.size
    if i == data.domain
        data.images{i} = mosaic.getImageAlpha(data.images{i},data.option);
    else
        data.images{i} = mosaic.getImageAlpha...
            (data.images{i},data.option,data.M{i,data.domain});
    end
end
dimMin = data.images{1}.bdMin; % Xmin, Ymin
dimMax = data.images{1}.bdMax; % Xmax, Ymax
for i = 2:data.size
    dimMin = min(data.images{i}.bdMin, dimMin);
    dimMax = max(data.images{i}.bdMax, dimMax);
end
% coordinate for new canvas
[cx,cy] = ndgrid(dimMin(1):dimMax(1),dimMin(2):dimMax(2));
dimCan = dimMax - dimMin + 1; % canvas dimension
% enable GPU features
if strcmp(data.option('gpu'),'true')
    caM = gpuArray(zeros(dimCan(1),dimCan(2),5));
else
    caM = zeros(dimCan(1),dimCan(2),5);    
end
% ----------------------------------------------------------------
% warp images
% --> this part is optimized for gpu structure, which might be not
%     very efficient for sequential run
% ----------------------------------------------------------------
for i = data.size:-1:1 % reversed order for stitching
    if strcmp(data.option('gpu'),'true')
        x = gpuArray(cx(:)');
        y = gpuArray(cy(:)');
    else
        x = cx(:)';
        y = cy(:)';
    end
    % -- compute backward coordinate
    if (i ~= data.domain)
        gpuM = data.M{data.domain,i};
        [x,y] = arrayfun(@warpCoordinate,x,y);
    end
    % -- get coordinate
    x = reshape(x,dimCan');
    y = reshape(y,dimCan');
    warImg = data.images{i}.img;
    % -- warp all channels
    if strcmp(data.option('feathering'),'inner')
        gpuInnerFeathering = true;
    else
        gpuInnerFeathering = false;
    end
    % --> alpha channel
    gpuDim = size(warImg); % dimension variable for kernel    
    gpuV = warImg(:,:,4);
    [caM(:,:,4),caM(:,:,5)] = arrayfun(@bilinearAlpha,x,y,caM(:,:,5));
    % --> color channels
    for j = 1:3
        gpuV = warImg(:,:,j);
        caM(:,:,j) = arrayfun(@bilinear,x,y,caM(:,:,j),caM(:,:,4));
    end
end
if strcmp(data.option('gpu'),'true')
    data.canvas = uint8(gather(caM(:,:,1:3)));
else
    data.canvas = uint8(caM(:,:,1:3));
end
% --------------------------------------------------- 
% GPU kernel functions
% ---------------------------------------------------
    function [xf,yf] = warpCoordinate(xi,yi)
        xf = gpuM(1,1) * xi + gpuM(1,2) * yi + gpuM(1,3);
        yf = gpuM(2,1) * xi + gpuM(2,2) * yi + gpuM(2,3);
        wf = gpuM(3,1) * xi + gpuM(3,2) * yi + gpuM(3,3);
        xf = xf / wf;
        yf = yf / wf;
    end
% - bilinear interpolator for alpha channel
    function [A,W] = bilinearAlpha(x,y,P)
        x1 = floor(x);
        x2 = ceil(x);
        y1 = floor(y);
        y2 = ceil(y);
        if x >= 1 && x <= gpuDim(1) && y >= 1 && y <= gpuDim(2)
            if P == 0 && gpuInnerFeathering
                A = 1;
                W = 1;
            else
                A = lerp(lerp(gpuV(x1,y1),gpuV(x2,y1),x1,x2,x),...
                         lerp(gpuV(x1,y2),gpuV(x2,y2),x1,x2,x),y1,y2,y);
                W = P;
            end            
        else            
            A = 0;
            W = P;
        end
    end
% - bilinear interpolator
    function [V] = bilinear(x,y,W,A)    
        x1 = floor(x);
        x2 = ceil(x);
        y1 = floor(y);
        y2 = ceil(y);
        if x >= 1 && x <= gpuDim(1) && y >= 1 && y <= gpuDim(2)
            V = lerp(lerp(gpuV(x1,y1),gpuV(x2,y1),x1,x2,x),...
                     lerp(gpuV(x1,y2),gpuV(x2,y2),x1,x2,x),y1,y2,y);
        else
            V = W;
        end       
        % alpha blending (the special case when A_b = 0)
        V = V * A + W * (1-A);
    end
% - blending function for bilinear interpolation
    function [T] = lerp(A,B,a,b,t)
        if (b - a) > 0
            T = A .* (b - t) ./ (b - a) + B .* (t - a) ./ (b - a);
        else
            T = 0.5 .* (A + B);
        end
    end
end