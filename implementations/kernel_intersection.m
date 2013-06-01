function K = kernel_intersection(X, X2)
% Evaluates the Histogram Intersection Kernel
%
% Usage:
%
%    K = KERNEL_INTERSECTION(X, X2)
%
% For a N x D matrix X and a M x D matrix X2, computes a M x N kernel
% matrix K where K(i,j) = k(X(i,:), X2(j,:)) and k is the histogram
% intersection kernel.

% n = size(X,1);
% m = size(X2,1);
% K = zeros(m, n);

X=X';X2=X2';
for i =1:numel(X2(1,:))    
    Min = bsxfun(@min,X, X2(:,i));
    K(i,:)=sum(Min);    
end

% HINT: Transpose the sparse data matrix X, so that you can operate over columns. Sparse
% column operations in matlab are MUCH faster than row operations.

% YOUR CODE GOES HERE.