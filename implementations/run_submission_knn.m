%% An instance based method-- KNN

%% Load the data
load ../data/data_no_bigrams.mat;
addpath libsvm;

% Make the training data
X = make_sparse(train);
Y = double([train.rating]');

% Remove words that is too rare or too frequent
valid_idx=find(sum(X)>100 & sum(X)<12000);
X=X(:,valid_idx);


%% Make the testing data and run testing
Xtest = make_sparse(test, size(X, 2));
Yhat = knnclassify(Xtest,X, Y);

%% Make predictions on test set
save('-ascii', 'submit_knn.txt', 'Yhat');