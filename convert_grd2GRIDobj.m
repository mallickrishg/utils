function [outgrid,outgridll] = convert_grd2GRIDobj(ingridfilename)
% function to convert grid object to topotoolbox style GRIDobj
% OUTPUT
% outgridll - in lat,lon coordinates
% outgrid - in UTM (m)
% Rishav Mallic, EOS, 2019

addpath ~/Dropbox/scripts/topotoolbox/
addpath ~/Dropbox/scripts/topotoolbox/utilities/
addpath ~/Dropbox/scripts/utils/

% load grid and convert to topotoolbox style
[X,Y,Z] = grdread(ingridfilename);
outgridll = GRIDobj(X,Y,Z);

outgrid = reproject2utm(outgridll,outgridll.cellsize*110e3);
end