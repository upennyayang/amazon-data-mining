function [ features ] = PCA( X )
%PCA Summary of this function goes here
%   Detailed explanation goes here

Xnorm = X - repmat(mean(X),size(X,1),1);
C=cov(full(Xnorm));
[P, lambda] = eig(C);
weight = sum(lambda)
[weightnorm, index] = sort(weight,'descend');
index
features = weight >= weightnorm(500);

end

