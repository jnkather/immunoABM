function sysPack = modifyTwoParams(sysPack,modVars)

% perform dynamic modifications
disp('performing dynamic modifications');
fns = fieldnames(modVars); % extract variable names
fns(strcmp(fns,'fix'))=[]; % remove 'fix' field
if numel(fns)>2, error('more than two variables'); end
numA = numel(modVars.(char(fns(1))));
numB = numel(modVars.(char(fns(2))));
copy1 = modVars.(char(fns(1)));
copy2 = modVars.(char(fns(2)));
for i = 1:numA % modify up to two parameters -> this is the intervention
    for j = 1:numB
        sysPack{i,j}.params.(char(fns(1))) = copy1(i); 
        sysPack{i,j}.params.(char(fns(2))) = copy2(j);
    end
end

% check if there is an additional fixed modification
if isfield(modVars,'fix')
   fixfns = fieldnames(modVars.fix);
   disp('performing fixed modifications');
   for i = 1:numel(fixfns)
       for k = 1:numel(sysPack)
          sysPack{k}.params.(char(fixfns(i))) = modVars.fix.(char(fixfns(i)));
       end
   end
end

end