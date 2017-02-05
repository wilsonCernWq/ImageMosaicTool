function translation = FindShift(position, dim)
% FINDSHIFT helper function to determine the translation vector between two
% images
%   
%   translation = FindShift(position, dim)
%
dim = dim / 2;
translation = position - dim - 0.5;
translation(translation < 0) = translation(translation < 0) - 1.5;
translation(translation > 0) = translation(translation > 0) - 0.5;
end