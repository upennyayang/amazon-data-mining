%% New features beyond bag-of-words

%% Load the data
load ../data/data_no_bigrams.mat;

% Make the training data
X = make_sparse(train);
Y = double([train.rating]');

%% Remove words that is too rare or too frequent
valid_idx=find(sum(X)>100 & sum(X)<12000);
X=X(:,valid_idx);

% Remove words from stoplist
% [~, ~,removed_idx] = intersect(stoplist',vocab);     
% X(:,removed_idx)=[];   


%% Add feature of titles
X_title=make_sparse_title(train);
X=[X X_title];

% %% Add feature of category
% categories = double([train.category]');
% categories_LUT=[1,2,3,4,5,6,7,8,9,10,11];
% categories_matrix=bsxfun(@eq,categories,categories_LUT);
% X=[X categories_matrix];


%%  Add features in date
month_list=zeros(size(train));    
day_list=zeros(size(train));
year_list=zeros(size(train));

%create a month to number look up table:
LUT={'January',1;'February',2;'March',3;'April',4;'May',5;'June',6;'July',7; 'August',8;'September',9;'October',10;'November',11; 'December',12};
days=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
months=[1,2,3,4,5,6,7,8,9,10,11,12];
years=[1999,2000,2001,2002,2003,2004,2005,2006,2007];    
for i=1:size(train,2)
    date=train(i).date;    
    % month feature:
    [month, day_year]=strtok(date);         
    for idx=1:12
        if strcmp(LUT{idx,1},month)==1
            break;
        end
    end
    month_list(i)=LUT{idx,2}; 
    % day feauture:
    [day, ~]=strtok(day_year,',');  
    day_list(i)=str2double(day);
    % year feauture:
    [~, year]=strtok(day_year); 
    year_list(i)=str2double(year);
end
% Generate month,day and year feature matrix.
month_matrix = bsxfun(@eq, month_list', months);
day_matrix= bsxfun(@eq, day_list',days);
year_matrix=bsxfun(@eq,year_list',years);

X=[X month_matrix day_matrix year_matrix];

%% Add feauture in helpful

helpful_list=zeros(size(train));
helpful_scale=[NaN,0,1,2,3,4,5,6,7,8,9,10];
for i=1:size(train,2)
    helpful=train(i).helpful;    
    %convert all "number of total" into scale with maximum of 10. (round)
    %eg. if "3 of 5" thinks it's helpful, we set it as score of 6.
    [number,of_total]=strtok(helpful);
    [~,total]=strtok(of_total);
    scale=round(10*str2double(number)/str2double(total));
    helpful_list(i)=scale;                 
end

helpful_matrix=bsxfun(@eq,helpful_list',helpful_scale);
X=[X helpful_matrix];


%%  Run training
Yk = bsxfun(@eq, Y, [1 2 4 5]);
nb = nb_train_pk([X]'>0, [Yk]);

%% Make the testing data and run testing
Xtest = make_sparse(test, size(X, 2));
Yhat = nb_test_pk(nb, Xtest'>0);

%% Make predictions on test set

% Convert from classes 1...4 back to the actual ratings of 1, 2, 4, 5
[tmp, Yhat] = max(Yhat, [], 2);
ratings = [1 2 4 5];
Yhat = ratings(Yhat)';
save('-ascii', 'submit_features.txt', 'Yhat');
