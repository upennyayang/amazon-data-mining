%%
%Load Data

load ../data/data_with_bigrams.mat;
load load.mat;
load count.mat;
load negation.mat;

%%
%Train & Test

[ Xtrain Xtest ] = feature_selection(train, test, vocab, count, values)
Y = double([train.rating]');
Ytest = zeros(size(Xtest,1),1);

model0 = libsvmtrain(Y, X, '-s 0');
model1 = libsvmtrain(Y, X, '-s 1');
model2 = libsvmtrain(Y, X, '-s 2');
model3 = libsvmtrain(Y, X, '-s 3');
model4 = libsvmtrain(Y, X, '-s 4');
model5 = libsvmtrain(Y, X, '-s 5');
model6 = libsvmtrain(Y, X, '-s 6');
model7 = libsvmtrain(Y, X, '-s 7');


[Yhat0] = libsvmpredict(Ytest, Xtest, model0);
[Yhat1] = libsvmpredict(Ytest, Xtest, model1);
[Yhat2] = libsvmpredict(Ytest, Xtest, model2);
[Yhat3] = libsvmpredict(Ytest, Xtest, model3);
[Yhat4] = libsvmpredict(Ytest, Xtest, model4);
[Yhat5] = libsvmpredict(Ytest, Xtest, model5);
[Yhat6] = libsvmpredict(Ytest, Xtest, model6);
[Yhat7] = libsvmpredict(Ytest, Xtest, model7);

Yh = (Yhat0 + Yhat1 + Yhat2 + Yhat3 + Yhat4 + Yhat5 + Yhat6 + Yhat7) / 8;

save('-ascii', 'submit.txt', 'Yh');