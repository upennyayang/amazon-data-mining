%% Own Kernel Method-- intersection kenel

%% Load the data
load ../data/data_no_bigrams.mat;
addpath liblinear;

% Make the training data
X = make_sparse(train);
Y = double([train.rating]');

% Remove words that is too rare or too frequent
valid_idx=find(sum(X)>100 & sum(X)<12000);
X=X(:,valid_idx);    

%% Make the testing data and run testing
Xtest = make_sparse(test, size(X, 2));
K = kernel_intersection(X, X);
Ktest = kernel_intersection(X, Xtest);
% Run libsvm training and libsvm testing
model = svmtrain(Y, [(1:size(K,1))' K]);  
[Yhat acc ~] = svmpredict(Y, [(1:size(Ktest,1))' Ktest], model);     

%% Make predictions on test set
save('-ascii', 'submit_kernel.txt', 'Yhat');



