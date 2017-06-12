% JN Kather 2017
function masterT = nested2table(inputNest)
masterT = struct2table(inputNest{1}); % first row
for k = 2:numel(inputNest) % all other rows
    masterT = [masterT; struct2table(inputNest{k})];
end
end