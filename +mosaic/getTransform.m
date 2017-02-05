function [P] = getTransform(A,B)
% GETTRAMSFORM function to calculate transform matrix based on control
% points
% 
%   [P] = getTransform(A,B)
%
% fields added
%   forward
%   backward
% maps A to B
P.forward = transA2B(A,B);
% maps B to A
P.backward = transA2B(B,A);
end

function [O] = transA2B(A,B)
% TRANSA2B calculate transform matrix P such that 'normalize(P * A) = B'
%
%   [M] = transA2B(A,B)
%
N = size(A,1);
M = zeros(2 * N, 8);
M(1:N,1:2) = -A;
M(1:N,  3) = -1;
M(N + 1:2 * N,4:5) = -A;
M(N + 1:2 * N,  6) = -1;
M(1:N,7) = A(:,1) .* B(:,1);
M(1:N,8) = A(:,2) .* B(:,1);
M(N + 1:2 * N,7) = A(:,1) .* B(:,2);
M(N + 1:2 * N,8) = A(:,2) .* B(:,2);
O = reshape([M \ -B(:);1],[3,3])';
end