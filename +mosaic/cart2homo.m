function X = cart2homo(X)
% CART2HOMO function to raise cartesien coordinate to homogeneous
% coordinate
%
%  [X] = cart2homo(X)
%
X(3,:) = 1;
end