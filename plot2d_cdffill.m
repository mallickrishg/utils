function [yintlow,yintup] = plot2d_cdffill(x,y,lb,ub,cdfvals,plotcol,plotoption)
% function to plot filled polygons showing contours of variable y (against
% independent variable x)
% x = vector
% y = matrix containing nvars x nsamples
% lb,ub = lower and upper bounds for plotting
% cdfvals = 2-column vector containing pairs of values (e.g [0.1,0.9;0.25,0.75;0.4,0.6])
% plotcol - RGB color for fill
% plotoption = either binning using CDF or PDF
% Rishav Mallick, EOS 2019

nvars = length(y(:,1));
yintlow = zeros(nvars,length(cdfvals(:,1)));
yintup = zeros(nvars,length(cdfvals(:,2)));

for i = 1:nvars
    switch plotoption
        case 'cdf'
            [Nh,edges] = histcounts(y(i,:),'Normalization','cdf');
            bincenters = (edges(1:end-1) + edges(2:end))/2;
        case 'pdf'
            [Nh,edges] = histcounts(y(i,:),'Normalization','probability');
            bincenters = (edges(1:end-1) + edges(2:end))/2;
            [sortbin,Isort] = sort(bincenters);
            Nh = Nh(Isort);
            bincenters = sortbin;
        otherwise
            error('Not a valid plotting option')
    end
    
    if length(Nh) > length(unique(Nh))
        [C,IA,~] = unique(Nh);
        Nh = C;
        bincenters = bincenters(IA);
    end
    
    switch plotoption
        case 'cdf'
            yintlow(i,:) = interp1(Nh,bincenters,cdfvals(:,1),'spline','extrap');
            yintup(i,:) = interp1(Nh,bincenters,cdfvals(:,2));
        case 'pdf'
            
        otherwise
            error('Not a valid plotting option')
    end
    
end

% adding this bound in a very simple way (can be tweaked in the loop for
% more specific situations)
yintlow(yintlow<lb) = lb;
yintup(yintup>ub) = ub;

fill([x;flipud(x)],[yintlow;flipud(yintup)],plotcol,'facealpha',0.1,'EdgeColor','none','Linewidth',1)


end