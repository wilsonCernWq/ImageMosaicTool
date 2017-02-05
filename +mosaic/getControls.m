function Y = getControls(X, P)
% GETCONTROLS function to calculate new control points based on transform
% matrix
%
%  [Y] = getControls(X,matrix)
%
Y = mosaic.homo2cart(mosaic.normalize(P * mosaic.cart2homo(X')))';
end