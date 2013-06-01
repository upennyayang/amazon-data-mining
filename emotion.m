function [ Ye ] = emotion( data, values, negationvalue )
%EMOTION Summary of this function goes here
%   Detailed explanation goes here

t = CTimeleft(numel(data));
Ye = ones(numel(data), 1) * 3;
for i = 1:numel(data)
    t.timeleft();
    v = values(data(i).word_idx);
    v = v(v~=3);
    last = 3;
    pos = sum(v>3);
    neg = sum(v<3);
    
    if ~isempty(v)
        %n = (1:numel(v)) / 100;
        %v = v .* (1 + n);
        %num = sum(n) + numel(v);
        last = v(numel(v));
    end
    %else
        num = numel(v);
    %end
    total = sum(v);
    s = negationvalue(data(i).bigram_idx);
    s = s(s ~= 0);
    lastbi = 0;
    for j = 1:numel(s)
        if values(s(j)) ~= 3
            total = total - 1.5 * (2 * values(s(j)) - 6);
            lastbi = values(s(j));
        end
    end
    
    if num ~= 0
        Ye(i) = total / num;
    end
    
    if Ye(i)>2 && pos < neg
        Ye(i)=2;
    elseif Ye(i)<4 && pos > neg
        Ye(i)=4;
    end
    
    if Ye(i) <= 2
        Ye(i) = Ye(i) - 1;
    end  
    
    %if last == lastbi
    %    Ye(i) = 1;
    %elseif last < 3
    %    Ye(i) = Ye(i) - 1;
    %elseif last > 3
    %    Ye(i) = Ye(i) + 1;
    %end
    
    if Ye(i) >= 3
        Ye(i) = ceil(Ye(i));
    else
        Ye(i) = floor(Ye(i));
    end
    
    if Ye(i) < 1
        Ye(i) = 1;
    end
    if Ye(i) > 5
        Ye(i) = 5;
    end
end

end

