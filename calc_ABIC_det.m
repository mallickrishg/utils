function ABIC=calc_ABIC_det(d,m,G,W,K,l,nobs)
% calc_ABIC_det calculates the ABIC value for a given linear model with purely gaussian priors and no
% bounded constraints
% INPUT
% d - data (column vector)
% m - model values (column vector) 
% d = G*m
% add priors as l*K*m = 0 (smoothing)
% l - hyperparameter for smoothing weight
% K - smoothing matrix
% nobs - number of observations
% Rishav Mallick 2018

%calculate the eigen values for Cmi and then only use the abs value of the
%non zero values
Cmeig = eig(l^2*(K'*K) + G'*W*G);
Cmi = abs(prod(Cmeig(Cmeig~=0)));

ABIC = ((nobs)*log((d - G*m)'*W*(d - G*m) + l^2*((K*m)'*(K*m))) ...
    - 2*(length(m))*log(l) + 1*log(Cmi));


end