function img = PadImage(img,n)
% PADIMAGE Pad zeros to the image so that the image is twice as large as
% itself previously
%
%   img = PadImage(img,n)
%
% n The target image dimension. If being presented, then the returing image
%   will be [2n(1) x 2n(2)]. If not being presented, then the returning
%   image will be twice as large as the original image
%
if exist('n','var')
    if size(img,1) < n(1)
        img((end+1):n(1),:) = 0;
    end
    if size(img,2) < n(2)
        img(:,(end+1):n(2)) = 0;
    end
end
img0 = zeros(size(img));
img = [img,img0;img0,img0];
end