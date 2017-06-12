% JN Kather 2017

function [xVarName, yVarName] = findVars(paramsTable)

% get table fieldnames
fn = fieldnames(paramsTable);
% remove irrelevant fields
removeT = {'initialSeed','useMex','debugmode','smoothSE',...
    'mycellsize','Properties','Row','Variables','fillSE'};
clean_fn = fn(~ismember(fn,removeT));

% calculate standard deviation for each field
stds = [];
for ii = clean_fn'
    stds = [stds, std(paramsTable.(char(ii)))];
end

% sort by standard deviation
[~,i] = sort(stds,'descend');
% return the two field names whose values vary most
clean_fn_sorted = clean_fn(i);

xVarName = char(clean_fn_sorted(1));
yVarName = char(clean_fn_sorted(2));

end