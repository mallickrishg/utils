function Cp = calc_Cp2d_dip(rcv,patchfname,ox,oy,oz,dipdelta,mtarget)
% % Calculate Cp - covariance from epistemic unvertainties % %
% calc_Cp2d_dip will calculate a covariance matrix for a perturbation to model-space 
% (not within the linear problem) and its resulting effect in the observational domain.
% Note - this version works only on horizontal data in the convergence direction
% It needs to be extended to 3D
%
% OUTPUT
% Cp is a nobs x nobs matrix which is not necessarily positive semi-definite 
% INPUTS
% rcv - unicycle fault object
% ox,oy,oz - station coordinates (cannot intersect with the fault trace)
% dipdelta - scalar perturbation to dip of rcv (or provide a vector that is 2*Npatches)
% mtarget - linear multiplier to design matrix (generally the solution from a previous optimization without Cp)
%
% References : Ragon et al., (2019) in GJI
% Rishav Mallick 2018

import unicycle.*
neval = 10;

% define range of dip variation
% dipdelta = 10;

G = @(x) [ones(size(x)) x];
Deldip = dipdelta.*eye(1*rcv.N);
dipvec = [];bigG = [];
for i = 1:neval
    rcvi = geometry.receiver(patchfname,rcv.earthModel);
    dipvec(:,i) = rcvi.dip - dipdelta*(2*(neval-i)/(neval-1) - 1);
    rcvi.dip = rcvi.dip - dipdelta*(2*(neval-i)/(neval-1) - 1);
    [~,Gdi] = rcvi.displacementKernels([ox oy oz],3);
    % multiply Gdi columns(obs) with target value of slip distribution
    for j = 1:length(Gdi(1,:))
        Gdi(:,j) = Gdi(:,j).*mtarget(j);
    end
    % 3D matrices that contain nobs(rows) x mpatch(columns) x neval(width)     
    bigG(:,:,i) = Gdi(1:3:end,:);
    % [Gdi(1:3:end,:);Gdi(3:3:end,:)]
end

K = [];
% calculate the linearized gradient of the perturbation K = dG/ddip
for i = 1:(1*length(ox))
    for j = 1:(1*rcv.N)
        Gdes = G(dipvec(j,:)');
        m = Gdes\squeeze(bigG(i,j,:));
        
        K(i,j) = m(2);
    end
end
Cp = K*Deldip*K';

end