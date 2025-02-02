function [Network] = NGCF(Global,Network,k)
% Our approach: Conservative fusion of priors + Consensus over current
% Observations (#4)

% prediction 
Network = predict(Network,Global,k);

% calculating the likelihood based on prediction 
Network = CalcLikelihood(Network,Global,k);

Network = LocalEstimateCalc(Network,Global,'GCF',k);


% iterative conservative fusion of priors
Network = IterativeConservativeFusion(Network,Global,'GCF',k);


% update 
Network = EstimateUpdate(Network,Global,'GCF',k);

% process and performance evaluation


end