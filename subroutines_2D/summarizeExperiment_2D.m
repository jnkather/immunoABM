function [summaryOut,paramsOut] = summarizeExperiment_2D(mySystemPackage,cnst)
% SUMMARIZE RESULTS
for i=1:numel(mySystemPackage)
    % summarize the system
    if isfield(mySystemPackage{i},'TU')
        summaryOut{i} = summarizeSystem_2D(mySystemPackage{i},cnst);
        paramsOut{i} = mySystemPackage{i}.params;
    else
        summaryOut{i} = [];
        paramsOut{i} = [];
    end
end
end