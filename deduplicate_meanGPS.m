function T = deduplicate_meanGPS(infil,dmin)
% function to deduplicate entries in a dataset
% once the duplicates are found (within a threshold distance), we use a
% weighted mean to compute the new velocity and standard deviation
% INPUTS
% infil - 7 column formatted csv or dat file name (lon,lat,ve,vn,se,sn,name)
% dmin - maximum distance range at which we consider a site a "duplicate"
% (in meters)
% OUTPUTS
% T - 7 column table formatted same as infil 
% Rishav Mallick, EOS, 2019

% read data
din = readtable(infil);
lon = din{:,1};
lat = din{:,2};
ve = din{:,3};
vn = din{:,4};
se = din{:,5};
sn = din{:,6};
names = din{:,7};
totn = length(lon);
meanve = [];meansige=[];meanvn = [];meansign=[];
i = 1;

while i<=totn
    %find stations that are closer to station_i than dmin
    [dstat,~] = distance(repmat(lat(i),totn,1),repmat(lon(i),totn,1),lat,lon,'degrees');
    dstat = deg2km(dstat)*1e3; % convert to meters
    DCON = dstat<dmin;
    Dnum = length(find(DCON==1));
    DCONlist = find(DCON==1);
    
    %create weighting function and design matrix for weighted mean
    wcde = diag(se(DCON).^(-2));
    wcdn = diag(sn(DCON).^(-2));
    Ge = [diag(wcde)./sum(diag(wcde))]';
    Gn = [diag(wcdn)./sum(diag(wcdn))]';
    
    
    %calculate mean
    meanve(i,1) = Ge*ve(DCON);
    meanvn(i,1) = Gn*vn(DCON);
    %meanveunw(i,1) = Gunw*ve(DCON);
    
    %calculate std of mean
    meansige(i,1) = sqrt(Ge*diag(se(DCON).^2)*Ge');
    meansign(i,1) = sqrt(Gn*diag(sn(DCON).^2)*Gn');
    
    %test with unweighted mean
    %Gunw = ones(1,Dnum)./Dnum;
    %meansigeunw(i,1) = sqrt(Gunw*diag(se(DCON).^2)*Gunw');
    
    %remove duplicate entries
    if Dnum>1
        lon(DCONlist(2:end)) = [];
        lat(DCONlist(2:end)) = [];
        ve(DCONlist(2:end)) = [];
        vn(DCONlist(2:end)) = [];
        se(DCONlist(2:end)) = [];
        sn(DCONlist(2:end)) = [];
        names(DCONlist(2:end)) = [];
    end
    
    totn = length(lon);
    i = i+1;
end
% export as a table
T = table(lon,lat,meanve,meanvn,meansige,meansign,names);

end