function program(folder,contrast,enableGPU,debug)
% The program entrance
%
%   program(folder,contrast,enableGPU,debug)
%
tic;
% -- default arguments
if ~exist('contrast','var')
    contrast = 'false';
end
if ~exist('enableGPU','var')
    enableGPU = true;
end
if ~exist('debug','var')
    debug = false;
end

% -- get file information
listing = dir(folder);
if isempty(listing)
   error('Folder does not exist!'); 
end
images = cell(length(listing),1);
counter = 0;
for f = listing(:)'    
    [~,~,ext] = fileparts(f.name);
    if strcmp(ext,'.png')
        counter = counter + 1;
        images{counter} = [folder,'/',f.name];
    end
end
images = images(1:counter);

% -- get parameters
N = length(images);
C = zeros(N*N,6);
X = zeros(N);
counter = 0;
for i = 1:length(images)
    for j = (i+1):length(images)
        if debug
            fprintf('image %i and %i\n',i,j);
        end
        [t,n] = GetCorrespondence(images{i},images{j},enableGPU,debug);        
        if ~isempty(t)
            counter = counter + 1;
            C(counter,:) = [i,j,t(1),t(2),n(1),n(2)];
            X(i,j) = 1;
        end
    end
end
C = C(1:counter,:);

% -- write input file
% open input file
fid = fopen([folder,'/input.txt'],'w');
% [1] write correspondence matrix
fprintf(fid,'// --- correspondence matrix\n');
fprintf(fid,'%i %i\n',N,N);
for i = 1:N
    fprintf(fid,[repmat('%f ',[1,N]),'\n'],X(i,:));
end
% [2] write image file names
fprintf(fid,'// --- image file names\n');
for i = 1:N
    fprintf(fid,'%s\n',images{i});
end
% [3] write correspondence
for i = 1:size(C,1)
    t = C(i,4:-1:3);
    n = C(i,6:-1:5);
    fprintf(fid,'// --- %i & %i correspondence\n',C(i,1:2)-1);
    fprintf(fid,'%i %i\n',C(i,1:2)-1);
    fprintf(fid,'4 2\n');    
    fprintf(fid,'%i %i\n', [1,1]);
    fprintf(fid,'%i %i\n', [1,n(2)]);
    fprintf(fid,'%i %i\n', [n(1),1]);
    fprintf(fid,'%i %i\n', n);
    fprintf(fid,'// --- %i & %i correspondence\n',C(i,2:-1:1)-1);
    fprintf(fid,'%i %i\n',C(i,2:-1:1)-1);
    fprintf(fid,'4 2\n');   
    fprintf(fid,'%d %d\n', [1,1] + t);
    fprintf(fid,'%d %d\n', [1,n(2)] + t);
    fprintf(fid,'%d %d\n', [n(1),1] + t);
    fprintf(fid,'%d %d\n', n + t);
end
fprintf(fid,'// --- domain\n');
fprintf(fid,'0\n');
fprintf(fid,'// --- output name\n');
fprintf(fid,'%s\n',[folder,'/mosaic.jpg']);
fprintf(fid,'// -- options\n');
if enableGPU
    fprintf(fid,'gpu true\n');
else
    fprintf(fid,'gpu false\n');
end
fprintf(fid,'feathering inner\n');
fprintf(fid,'contrast %s\n',contrast);
fclose(fid);

% -- run mosaic
mosaic.run([folder,'/input.txt']);
toc;
end