function [X] = make_sparse(data, vocab, count, stoplist)
% Returns a sparse matrix representation of the data.
%
% Usage:
%
%  [X] = MAKE_SPARSE(DATA, NF)
%
% Converts the Amazon review data structure into a sparse matrix using the
% first 1....NF word features only. If NF is not specified, then uses all
% features word features encounted in DATA.

X = make_sparse(data, count);

for i = 1:numel(stoplist)
    x = strmatch(stoplist(i),vocab,'exact');
    X(:, ~x) = 0;
end