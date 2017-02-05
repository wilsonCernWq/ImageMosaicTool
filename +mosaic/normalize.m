function [V] = normalize(X)
% NORMALIZE normalize homogeneous coordinate
%
%   [V] = normalize(X)
%
V = (X ./ repmat(X(end,:),[size(X,1),1]));
end
