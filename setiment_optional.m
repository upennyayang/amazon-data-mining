function [ values ] = setiment(vocab)
%SETIMENT Summary of this function goes here
%   Detailed explanation goes here

fidp = fopen('positive-words.txt','rt');
Cp = textscan(fidp, '%s');
fidn = fopen('negative-words.txt','rt');
Cn = textscan(fidn, '%s');
values = ones(1, numel(vocab)) * 3;
t = CTimeleft(numel(vocab));
for i = 1:numel(vocab)
    t.timeleft();
    x = strmatch(lower(vocab(i)), Cp{1}, 'exact');
    if ~isempty(x)
        values(i) = 5;
    else
        y = strmatch(lower(vocab(i)), Cn{1}, 'exact');
        if ~isempty(y)
            values(i) = 1;
        end
    end
end

end
