%%
%Load Data
load ../data/data_with_bigrams.mat;
load count.mat;
load load.mat;
load negation.mat;


%%
%Cross Validation
n_folds = 1;
part_errors = zeros(n_folds, 1);
RMSEs = zeros(n_folds, 1);

ratings = [1 2 4 5];

Xb = make_sparse_bigram(train);
Y = double([train.rating]');
Xs = make_sparse(train, count);
X = make_sparse_new(train, vocab, count, values);
Ye = emotion(train, values, negationvalue);

for part = 1:n_folds
    part_mask = [train.category]' == part;
    Xtrain = X(~part_mask, :);
    Xstrain = Xs(~part_mask, :);
    Xbtrain = Xb(~part_mask, :);
    Ytrain = Y(~part_mask, :);
    
    model0 = libsvmtrain(Ytrain, Xtrain, '-s 0');
    model0b = libsvmtrain(Ytrain, Xbtrain, '-s 0');
    model1 = libsvmtrain(Ytrain, Xtrain, '-s 1');
    model1b = libsvmtrain(Ytrain, Xbtrain, '-s 1');
    model2 = libsvmtrain(Ytrain, Xtrain, '-s 2');
    model2b = libsvmtrain(Ytrain, Xbtrain, '-s 2');
    model3 = libsvmtrain(Ytrain, Xtrain, '-s 3');
    model3b = libsvmtrain(Ytrain, Xbtrain, '-s 3');
    model4 = libsvmtrain(Ytrain, Xstrain, '-s 4');
    model4b = libsvmtrain(Ytrain, Xbtrain, '-s 4');
    model5 = libsvmtrain(Ytrain, Xtrain, '-s 5');
    model5b = libsvmtrain(Ytrain, Xbtrain, '-s 5');
    model6 = libsvmtrain(Ytrain, Xtrain, '-s 6');
    model6b = libsvmtrain(Ytrain, Xbtrain, '-s 6');
    model7 = libsvmtrain(Ytrain, Xstrain, '-s 7');
    model7b = libsvmtrain(Ytrain, Xbtrain, '-s 7');

    Xtest = X(part_mask, :);
    Xbtest = Xb(part_mask, :);
    Ytest = Y(part_mask, :);
    
    [Yhat0] = libsvmpredict(Ytest, Xtest, model0);
    [Ybhat0] = libsvmpredict(Ytest, Xbtest, model0b);
    [Yhat1] = libsvmpredict(Ytest, Xtest, model1);
    [Ybhat1] = libsvmpredict(Ytest, Xbtest, model1b);
    [Yhat2] = libsvmpredict(Ytest, Xtest, model2);
    [Ybhat2] = libsvmpredict(Ytest, Xbtest, model2b);
    [Yhat3] = libsvmpredict(Ytest, Xtest, model3);
    [Ybhat3] = libsvmpredict(Ytest, Xbtest, model3b);
    [Yhat4] = libsvmpredict(Ytest, Xtest, model4);
    [Ybhat4] = libsvmpredict(Ytest, Xbtest, model4b);
    [Yhat5] = libsvmpredict(Ytest, Xtest, model5);
    [Ybhat5] = libsvmpredict(Ytest, Xbtest, model5b);
    [Yhat6] = libsvmpredict(Ytest, Xtest, model6);
    [Ybhat6] = libsvmpredict(Ytest, Xbtest, model6b);
    [Yhat7] = libsvmpredict(Ytest, Xtest, model7);
    [Ybhat7] = libsvmpredict(Ytest, Xbtest, model7b);
    
    Yh = (3 * Yhat0 + 3 * Ybhat0 + Yhat1 + Ybhat1 + Yhat2 + Ybhat2 + Yhat3 + Ybhat3 + Yhat4 + Ybhat4 + Yhat5 + Ybhat5 + Yhat6 + Ybhat6 + 3 * Yhat7 + 3 * Ybhat7 + 3 * Ye(part_mask, :)) / 27;
    
    part_errors(part) = sum(Yh ~= Ytest) ./ numel(Ytest)
    RMSEs(part) = sqrt(sum((Yh - Ytest).^2) ./ numel(Ytest))

end
    
error = mean(part_errors);
RMSE = mean(RMSEs);