function [X_out,Y_out,data_out,var_out] = qt_resamp(X,Y,data_in,resamp_func,thresh,mindim,maxdim)
% Resample a matrix using qtdecomp, according to threshold and mindim,maxdim
% Returns [X_out,Y_out, data_out] at resampled points
% function created by E. Lindsey, Oct 2018
% from example script in MudPy by D. Melgar, https://github.com/dmelgarm/MudPy/blob/master/scripts/quadtree_los.m
%

% pad with nans
Xlen=size(data_in,2);
Ylen=size(data_in,1);
Xpadlen=2^nextpow2(Xlen);
Ypadlen=2^nextpow2(Ylen);
zpad=nan(Ypadlen,Xpadlen);
distpad=zpad;
Xpad=zpad;
Ypad=zpad;
zpad(1:Ylen,1:Xlen)=data_in;
distpad(1:Ylen,1:Xlen)=resamp_func;
Xpad(1:Ylen,1:Xlen)=X;
Ypad(1:Ylen,1:Xlen)=Y;

disp('QT decomp')
s=qtdecomp(distpad,thresh,[mindim,maxdim]);
%Calcualte maximum dimension
maxdim=max(max(full(s)));
%get power of 2 of possible block values
idim=(log(mindim)/log(2)):1:(log(maxdim)/log(2));
%Now loop through
data_out=[];
var_out=[];
X_out=[];
Y_out=[];
for k=1:length(idim)
    [vals, r, c] = qtgetblk(zpad, s,2^idim(k));
    icurrent=find(s==2^idim(k));
    %Now get mean and cellc enter of each grid
    for kgrid=1:length(icurrent)
       %Get values
       new_pt=nanmedian(nanmedian(vals(:,:,kgrid)));
       %if ~isnan(new_pt)  %Add to the list
           data_out=[data_out,new_pt];
           valsk=vals(:,:,kgrid);
           var_newpt=var(valsk(:),'omitnan');
           var_out=[var_out,var_newpt];
           %get indices of center as upepr left plus half the size of the
           %block
           r1=r(kgrid)+(2^idim(k))/2;
           r2=r(kgrid)+(2^idim(k))/2+1;
           c1=c(kgrid)+(2^idim(k))/2;
           c2=c(kgrid)+(2^idim(k))/2+1;
           %Now figure out coordinates of the center
           X_out=[X_out,0.5*(Xpad(r1,c1)+Xpad(r2,c2))];
           Y_out=[Y_out,0.5*(Ypad(r1,c1)+Ypad(r2,c2))];
       %end
    end
end