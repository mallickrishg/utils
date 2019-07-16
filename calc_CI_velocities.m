function [dmin,dmax] = calc_CI_velocities(m_post,CI,syn2,xpred,Nboots)
% calculate the range of solutions predicted by the model. 
% use after computing the posterior distribution of model parameters.
% INPUT
% mpost - posterior distribution (Nrun x Nmodelparams)
% CI - confidence intervals for each model parameter (2xNmodelparams)
% 	row 1- lower bound confidence interval
% 	row 2- upper bound confidence interval
% syn2(model,X) - synthetic model. this should be a function of X with model parameters,"model", that can be evaluated within the code.
% xpred - evaluation points
% Nboots - number of samples for random sampling of the posterior
% OUTPUT 
% dmin/dmax are the range of model predictions within the confidence bound
% Rishav Mallick, EOS, 2018

IF = true(length(m_post),1);
for jj = 1:length(m_post(1,:))
    IF = IF & m_post(:,jj)>CI(1,jj) & m_post(:,jj)<CI(2,jj);
end    
mpost_sample = m_post(IF,:);

%randomly choose Nboots sample from the posterior distribution (within the
%confidence bounds only)
mrand = datasample(mpost_sample,Nboots);
data_prob = [];
for jj = 1:length(mrand(:,1))
    data_prob(:,jj)=syn2(mrand(jj,:),xpred);
end
dmax = max(data_prob,[],2);
dmin = min(data_prob,[],2);

end