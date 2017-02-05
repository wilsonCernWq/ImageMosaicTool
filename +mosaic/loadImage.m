function data = loadImage(data)
% LOADIMAGE function to load images into data and adjust contrast
%
%   data = loadImage(data)
%
% 1) load images
for m_i = 1:data.size
    [~,data.images{m_i}.img] = mosaic.readFigure(data.file{m_i},'rgb');
end
% 2) adjust contrast (comment below in order to disable contrast adjusting)
% -- calculate domain brightness mean
oimg = rgb2hsv(data.images{data.domain}.img);
ref= mean(mean(oimg(:,:,3)));
for i = 1:data.size
    if data.domain == i
        continue;
    end
    switch data.option('contrast')
        case 'meanshift'
            % ------ method 1 ------
            img = rgb2hsv(data.images{i}.img);
            img(:,:,3) = img(:,:,3) - mean(mean(img(:,:,3))) + ref;
            data.images{i}.img = uint8(hsv2rgb(img) * 255);
        case 'gamma'            
            % ------ method 2 ------
            img = rgb2hsv(data.images{i}.img);
            img(:,:,3) = imadjust(img(:,:,3));
            data.images{i}.img = uint8(hsv2rgb(img) * 255);
        case 'histmatch'
            % ------ method 3 ------
            img = rgb2hsv(data.images{i}.img);
            img(:,:,3) = imhistmatch(img(:,:,3),oimg(:,:,3));
            data.images{i}.img = uint8(hsv2rgb(img) * 255);
        case 'false'
        otherwise
            warning('Unknown contrast option!');
    end
end
end