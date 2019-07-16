function mod_errorbar(hErr,x,mult)
% function to change the horizontal width of errorbars (works with
% MATLAB2016a not with 2017a
% INPUTS
% hErr - errorbar object
% x - column vector
% mult - scalar multiplier to change horizontal width of errorbar
% Rishav Mallick, EOS, 2018

% mult = .02;                               % twice as long

b = hErr.Bar;                           % hidden property/handle
drawnow                                 % populate b's properties
vd = b.VertexData;
N = numel(x);                           % number of error bars
capLength = vd(1,2*N+2,1) - vd(1,1,1);  % assumes equal length on all
newLength = capLength * mult;
leftInds = N*2+1:2:N*6;
rightInds = N*2+2:2:N*6;
vd(1,leftInds,1) = [x-newLength; x-newLength];
vd(1,rightInds,1) = [x+newLength; x+newLength];
b.VertexData = vd;

end