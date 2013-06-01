function [ values ] = setiment(vocab, str)
%SETIMENT Summary of this function goes here
%   Detailed explanation goes here

C = textscan(str, '%s %s %f %f %s');
values = ones(1, numel(vocab)) * 3;
t = CTimeleft(numel(vocab));
for i = 1:numel(vocab)
    t.timeleft();
    x = strmatch(lower(vocab(i)), C{5}, 'exact');
    if ~isempty(x)
        pos = mean(C{3}(x));
        neg = mean(C{4}(x));
        if (abs(pos - neg) >= 0.5)
            values(i) = 3 + 2 * (pos - neg);
        end
    end
end

end
