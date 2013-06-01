%%
%Load Data

load ../data/data_no_bigrams.mat;

%%
%Train & Test

X = make_sparse(train);
Y = double([train.rating]');

model = libsvmtrain(Y, X, '-s 4');

Xtest = make_sparse(test);
Ytest = zeros(size(Xtest,1),1);

[Yhat] = libsvmpredict(Ytest, Xtest, model);

save('-ascii', 'submit.txt', 'Yhat');