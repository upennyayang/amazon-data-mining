function [ X ] = make_sparse_new( data, vocab, count, values )
%MAKE_SPARSE_NEW Summary of this function goes here
%   Detailed explanation goes here

Xb = make_sparse_bigram(data);
X = make_sparse(data, count);
X = [X Xb];
%idx = (values ~= 3);
%X = X(:, idx(1:size(X, 2)));

t = CTimeleft(numel(data));
len = zeros(size(data, 2), 1);
tlen = zeros(size(data, 2), 1);
blen = zeros(size(data, 2), 1);
help = zeros(size(data, 2), 1);
pos = zeros(size(data, 2), 1);
ppos = zeros(size(data, 2), 1);
neg = zeros(size(data, 2), 1);
nneg = zeros(size(data, 2), 1);
category = zeros(size(data, 2), 1);
for i =1:numel(data)
    t.timeleft();
    len(i) = sum(data(i).word_count);
    tlen(i) = numel(data(i).title_idx);
    blen(i) = sum(data(i).bigram_count);
    if(strcmp(data(i).helpful, '') ~= 1)
        helpful = sscanf(char(regexp(data(i).helpful,'of','split'))','%d');
        weight = helpful(1) / helpful(2) * 10;
    else
        weight = 1;
    end
    help(i) = weight;
    v = values(data(i).word_idx);
    v = v(v~=3);
    pos(i) = sum(v>3) / len(i) * 100;
    neg(i) = sum(v<3) / len(i) * 100;
    category(i) = data(i).category;
end

X = [X len category pos + neg];

end