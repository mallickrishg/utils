function [yp,xp] = create_swath_box(x1,y1,x2,y2,w)
% function to create a rectangle of half-width 'w' given 2 point (x1,y1) and (x2,y2)
% INPUTS
% make sure none of the coordinates overlap (if you have values like (24,90) & (27,90) change the second one to (27,90.001)
% (x1,y1) - coordinates of point 1 (preferably cartesian) in (m or º)
% (x2,y2) - coordinates of point 2 (preferably cartesian) in (m or º)
% w - half-width in (m or º)
% OUTPUTS
% (xp,yp) - ordered polygon - 4points
% COMMENT: i made a silly error so i had to flip xp and yp to get the
% correct order for output
% Rishav Mallick, EOS, 2019

m1 = (y2-y1)./(x2-x1);
m2 = -1./m1;

xp1 = x1 - w./sqrt(1+m2.^2);
xp2 = x1 + w./sqrt(1+m2.^2);
xp3 = x2 - w./sqrt(1+m2.^2);
xp4 = x2 + w./sqrt(1+m2.^2);
Xp = [xp1;xp2;xp3;xp4];

yp1 = y1 + m2.*(xp1 - x1);
yp2 = y1 + m2.*(xp2 - x1);
yp3 = y2 + m2.*(xp3 - x2);
yp4 = y2 + m2.*(xp4 - x2);
Yp = [yp1;yp2;yp3;yp4];

if length(find(max(Xp)))==1
	yp = [Xp(Yp==max(Yp)); Xp(Xp==max(Xp));Xp(Yp==min(Yp));Xp(Xp==min(Xp))];
	xp = [Yp(Yp==max(Yp));Yp(Xp==max(Xp));Yp(Yp==min(Yp));Yp(Xp==min(Xp))];
else
	yp = [Xp(Yp==max(Yp)&Xp==max(Xp));Xp(Yp==min(Yp)&Xp==max(Xp));Xp(Yp==min(Yp)&Xp==min(Yp));Xp(Yp==max(Yp)&Xp==min(Xp))];
	xp = [Yp(Yp==max(Yp)&Xp==max(Xp));Yp(Yp==min(Yp)&Xp==max(Xp));Yp(Yp==min(Yp)&Xp==min(Yp));Yp(Yp==max(Yp)&Xp==min(Xp))];
end


end