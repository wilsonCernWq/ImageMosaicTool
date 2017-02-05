function data = cascading(data)
% CASCADING recursive function to cascad transform matrix
%
%   data = initialize(data)
%
repeat = false; % recursive indicator
for x = 1:length(data.P)-1
    for y = x+1:length(data.P)
        I = data.P{x};
        J = data.P{y};
        if I(2) == J(1) && I(1) ~= J(2) && data.X(I(1),J(2)) ==0
            % retrieve index
            i = I(1);
            j = J(2);
            k = I(2);
            % compute corresponding control points
            Ci = data.dots{i,k};                        
            Ck = mosaic.getControls(Ci,data.M{i,k});
            Cj = mosaic.getControls(Ck,data.M{k,j});            
            % compute transform matrix
            P = mosaic.getTransform(Ci, Cj);
            data.M{i,j} = P.forward;
            data.M{j,i} = P.backward;
            % mark changes
            data.X(i,j) = 1;
            data.X(j,i) = 1;
            data.P{end+1} = [i,j];
            data.P{end+1} = [j,i];
            repeat = true;
        end
    end
end
if repeat
   data = mosaic.cascading(data);
end
end