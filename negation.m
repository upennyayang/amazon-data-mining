function [ negationvalue ] = negation( vocab, bigram_vocab )
%NEGATION Summary of this function goes here
%   Detailed explanation goes here

negationvalue = zeros(1, numel(bigram_vocab));

negwords = [28 154 77 2500 54 3956 2860 408 1063];

t = CTimeleft(numel(bigram_vocab));
for i = 1:numel(bigram_vocab)
    t.timeleft();
    bigrams = regexp(bigram_vocab(i), '_', 'split');
    negations = bigrams{1}(1);
    x = strmatch(negations(1), vocab(negwords), 'exact');
    if ~isempty(x)
        word = bigrams{1}(2);
        x = strmatch(word(1), vocab, 'exact');
        if ~isempty(x)
            negationvalue(i) = x;
        end
    end
end

end

