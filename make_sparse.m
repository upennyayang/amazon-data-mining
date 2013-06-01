function [X] = make_sparse(data, vocabs, nf)
% Returns a sparse matrix representation of the data.
%
% Usage:
%
%  [X] = MAKE_SPARSE(DATA, NF)
%
% Converts the Amazon review data structure into a sparse matrix using the
% first 1....NF word features only. If NF is not specified, then uses all
% features word features encounted in DATA.

t = CTimeleft(numel(data));
for i = 1:numel(data)
    t.timeleft();
    for j = 1:numel(data(i).title_idx)
        n = find(data(i).word_idx == data(i).title_idx(j,1));
        if(sum(n) == 0)
            data(i).word_idx = [data(i).word_idx; data(i).title_idx(j,1)];
            data(i).word_count = [data(i).word_count; data(i).title_count(j,1) * 2];
        else
            data(i).word_count(n) = data(i).word_count(n) + data(i).title_count(j,1) * 2;
        end
    end
end

t = CTimeleft(numel(data));
for i = 1:numel(data)
    t.timeleft();
    data(i).word_idx = vocabs(data(i).word_idx)';
end

colidx = vertcat(data.word_idx);
counts = vertcat(data.word_count);

if nargin==2
    nf = double(max(colidx));
end

keep_idx = find(colidx <= nf);

rowidx = zeros(size(colidx));

idx = 1;

t = CTimeleft(numel(data));
for i = 1:numel(data)
    t.timeleft();
    for j = 1:numel(data(i).word_idx)
        rowidx(idx) = i;
        idx = idx + 1;
    end
end

X = sparse(rowidx(keep_idx), double(colidx(keep_idx)), double(counts(keep_idx)), numel(data), nf);