function Cp = calc_Greens_dip_uncertainties(rcv,patchfname,ox,oy,oz,dipdelta,mtarget)
% calc_Greens_dip_uncertainties will calculate a covariance matrix for a
% perturbation to model-space (not within the linear problem) and its resulting effect in the observational
% domain.
% OUTPUT
% Cp is a 3*nobs x 3*nobs matrix which is not necessarily positive semi-definite 
% (also note it is calculated as Ge(1:nobs,:);Gn(1:nobs,:);Gz(1:nobs,:))
% INPUTS
% rcv - unicycle fault object
% ox,oy - station coordinates (cannot intersect with the fault trace)
% dipdelta - scalar perturbation to dip of rcv (or provide a vector that is 2*Npatches)
% mtarget - [Md Ms] linear multiplier to design matrix (similar to a target value
% at which we want to calculate the perturbation) default = set this to average slip/slip-rate
% Rishav Mallick 2018

% NEED TO FIX mtarget




% set number of evaluations over which we want to calculate the slope
neval = 5;
import unicycle.*
G = @(x) [ones(size(x)) x];

Deldip = dipdelta.*eye(2*rcv.N);


for i = 1:neval
    rcvi = geometry.receiver(patchfname,rcv.earthModel);
    dipvec(:,i) = rcvi.dip - dipdelta*(2*(neval-i)/(neval-1) - 1);
    rcvi.dip = rcvi.dip - dipdelta*(2*(neval-i)/(neval-1) - 1);
    [Gsi,Gdi] = rcvi.displacementKernels([ox oy oz],3);
    
    % 3D matrices that contain nobs(rows) x mpatch(columns) x neval(width)     
    bigG(:,:,i) = [[Gsi(1:3:end,:);Gsi(2:3:end,:);Gsi(3:3:end,:)].*mtarget(2) [Gdi(1:3:end,:);Gdi(2:3:end,:);Gdi(3:3:end,:)].*mtarget(1)];
    % bigG = [Gs Gd] arranged as E,N,Z
end

dipvec = [dipvec;dipvec];
K = [];
% calculate the linearized gradient of the perturbation K = dG/ddip
for i = 1:(3*length(ox))
    for j = 1:(2*rcv.N)
        Gdes = G(dipvec(i,:)');
        m = Gdes\squeeze(bigG(i,j,:));
        
        K(i,j) = m(2);
    end
end

Cp = K*Deldip*K';

end