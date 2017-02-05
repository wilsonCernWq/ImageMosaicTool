function data = readParam(filename)
% READINPUT read input parameters
%
%   data = readInput(filename)
%
% data
%   X => correspondence matrix
%   P => correspondence indices
%   M => transfer matrix
%   size => number of images
%   file => filenames
%   dots => transfer matrices
%   imgs => original images
%   images => warped images
%   domain => domain image
%   output => output filename
%   canvas => output image data
%
% open file
fileID = fopen(filename);
data = [];
% read matrix
[data.X, dim] = scanMat(fileID);
data.M = cell(size(data.X));
data.P = {};
data.size = dim(1);
% read files
data.file = textscan(fileID,'%s',data.size, 'CommentStyle','//','CollectOutput',true);
data.file = data.file{1};
% read control points
data.dots = cell(size(data.X));
% read filenames
data.images = cell(data.size,1);
for k = 1 : 2 * sum(sum(data.X))
    shape = scanArray(fileID,2)+1;
    data.dots{shape(1),shape(2)} = reverseCoord(scanMat(fileID));
end
% read primary image
data.domain = textscan(fileID,'%d',1,'CommentStyle','//','CollectOutput',true);
data.domain = data.domain{1} + 1;
% read output filename
data.output = textscan(fileID,'%s',1,'CommentStyle','//','CollectOutput',true);
data.output = data.output{1};
% output data holder
data.canvas = [];
% option map
data.option = containers.Map({'gpu','feathering','contrast'},{'true','true','meanshift'});
list = textscan(fileID,'%s %s','CommentStyle','//');
for i = 1:size(list{1})
   data.option(list{1}{i}) = list{2}{i};
end
% close file
fclose(fileID);
end

% reverse control point coordinate JUST HACKING
function Y = reverseCoord(X)
Y = [X(:,2),X(:,1)];
end

function [array] = scanArray(fileID, n)
array = cell2mat(textscan(fileID,repmat('%f',[1,n]),1,'CommentStyle','//','CollectOutput',true));
end

function [matrix, dim] = scanMat(fileID)
N = cell2mat(textscan(fileID,'%d%d',1,'CommentStyle','//','CollectOutput',true));
M = cell2mat(textscan(fileID,repmat('%f',[1,N(2)]),N(1),'CommentStyle','//','CollectOutput',true));
matrix = M;
dim = N;
end