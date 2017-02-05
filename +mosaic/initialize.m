function data = initialize(data)
% INITIALIZE function to calculate initial transform matrix
%
%   data = initialize(data)
% 
% initial transform matrices
for i = 1:data.size-1
    for j = i+1:data.size
        if data.X(i,j) == 1
            % get control points
            C1 = data.dots{i,j};
            C2 = data.dots{j,i};
            % compute matrix
            P = mosaic.getTransform(C1,C2);
            data.M{i,j} = P.forward;
            data.M{j,i} = P.backward;
            % mark progresses
            data.X(i,j) = 1;
            data.X(j,i) = 1;
            data.P{end+1} = [i,j];
            data.P{end+1} = [j,i];
        end
    end
end
end