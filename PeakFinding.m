function [position, peak, valid] = PeakFinding(p,debug)
% PEAKFINDING Function to find the peak point on the phase correlation 
% matrix
%
%   [position, peak, valid] = PeakFinding(p,debug)
%
% position: peak position
% peak: peak value
% valid: if it is a valid peak
%
% calculate peak
[peak,I] = max(p(:));
[x,y] = ind2sub(size(p),I);
position = [x,y];
% check if the peak is valid
m = mean(p(:));
r = (peak - m) / m;
if r > 30
   valid = true;
   if debug
       fprintf('VALID: peak = %f, mean = %f, peak/mean = %f\n',peak,m,r);
   end
else
   valid = false;
   if debug
       fprintf('NOT: peak = %f, mean = %f, peak/mean = %f\n',peak,m,r);
   end
end
end