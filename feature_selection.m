function [ Xtrain Xtest ] = feature_selection(train, test, vocab, counts, vocabs)
%feature_selection Summary of this function goes here
%   Detailed explanation goes here

Xtrain = make_sparse(train, counts, numel(vocab));
Xtest = make_sparse(test, counts, numel(vocab));
X = [Xtrain; Xtest];

idx = (vocabs ~= 3);

category_count = zeros(1, 21);
category_sample = zeros(21, 100000);

for i=1:numel(train)
    category_count(train(i).category) = category_count(train(i).category) + 1;
    category_sample(train(i).category, category_count(train(i).category)) = i;
end
for i=1:numel(test)
    category_count(test(i).category) = category_count(test(i).category) + 1;
    category_sample(test(i).category, category_count(test(i).category)) = numel(train) + i;
end

sample_count = ceil(category_count * (400000 / sum(idx) / size(X, 1)));
sample = [];

for i = 1:21
    rand_all = randperm(category_count(i));
    rand_sample = rand_all(1:sample_count(i));
    sample = [sample category_sample(i, rand_sample)];
end

Xsample = X(sample, idx);
Xtrain = Xtrain(:, idx);
Xtest = Xtest(:, idx);

%features = PCA(full(Xsample));
%Xtrain = Xtrain(:, features);
%Xtest = Xtest(:, features);

end

