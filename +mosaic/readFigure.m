function varargout = readFigure(figname, type)
% Function to read images and convert it into gray scale
%
%   [imgRGB] = readFigure(figname)
%   [imgRGB imgTYPE] = readFigure(figname, type)
%       read image and convert image type based on input value
%
% -- throw away alpha channel
img = imread(figname); % gray scale image
if size(img,3) > 3 
    img = img(:,:,1:3);
end
% -- convert image
if nargout == 1
    varargout{1} = img;
elseif nargout == 2
    varargout{1} = img;
    % parse default input
    if ~exist('type', 'var')
        type = 'gray';
    end
    % convert image
    switch (type)
        case {'gray','Gray','GRAY'}
            if size(img,3) > 1
                varargout{2} = rgb2gray(img);
            else
                varargout{2} = img;
            end
        case {'YCbCr','ycbcr','Ycbcr','YCBCR'}
            varargout{2} = rgb2ycbcr(img);
        case {'RGB0','Rgb','rgb'}
            % warning('The default figure type is rgb');
            if size(img,3) == 3
                varargout{2} = img;
            elseif size(img,3) < 3
                rgbimg = zeros([size(img,1),size(img,2),3],'uint8');
                rgbimg(:,:,1) = img;
                rgbimg(:,:,2) = img;
                rgbimg(:,:,3) = img;
                varargout{2} = rgbimg;
            end
        otherwise
            error('Unknown image type!');
    end
else
    error('Too much output arguments');
end
end