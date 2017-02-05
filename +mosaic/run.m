function run(filename)
% read input parameters
data = mosaic.readParam(filename);
data = mosaic.initialize(data);
% cascading
data = mosaic.cascading(data);
% read images and adjust contrast
data = mosaic.loadImage(data);
% warp images
data = mosaic.project(data);
% save image
image(data.canvas);
[~,~,ext] = fileparts(data.output{1});
if strcmp(ext,'.tif')
    imwrite(data.canvas, data.output{1});
elseif strcmp(ext,'.jpg')
    imwrite(data.canvas, data.output{1},'jpg','Comment','My JPEG file');
end
end