% 2016-2017, created by JN Kather, includes code snippets by Jan Poleszczuk
%
% Figure 3: Stroma slows tumor growth in a lymphocyte-deprived, but 
% mediates immune escape in a lymphocyte enriched environment. (A) 
% experimental design, (B) tumor mass over time for all four groups, 
% depending on probability of stroma generation (Stro low vs. high) and 
% the magnitude of immune cell influx (Lym low vs. high) (C) outcome 
% three months after baseline (60 days, dashed line). Response criteria 
% were chosen analogous to the RECIST criteria. The subgroup “Stro 
% low, Lym high” had a 100% response rate, the majority complete responses 
% (i.e. eradication of all tumor cells). Abbreviaions: PD = progressive 
% disease, SD = stable disease, PR = partial remission, CR = complete 
% remission. 

%% PREPARE
close all, clear all, format compact, clc
addpath('./subroutines_2D/'); % include all functions for the 2D model
addpath('./subroutines_ND/'); % include generic subroutines

for expname =  ...
		{'INTERVENTION_LO_STRO_LO_LYM_MANY',...
         'INTERVENTION_HI_STRO_LO_LYM_MANY',...
         'INTERVENTION_HI_STRO_HI_LYM_MANY',...
         'INTERVENTION_LO_STRO_HI_LYM_MANY' }

    
randmodulator = 100; % default 100, for duplicate: 101, for triplicate: 102
[modVars,override,tFirstRun,domSize,tAfterInterv] = ...
    getHyperparameters(expname); % get hyperparameters for current experiment
[systemTemplate, cnst] = getSystemParams('2D',domSize); % create system template
cnst.nSteps = tFirstRun(1);
cnst.drawWhen = tFirstRun(2);
requireTumorAlive = tFirstRun(1); % require tumor to be alive for at least ... 
                              % iterations to exclude random effects
disp(['###',10,'starting experiment ',char(expname),10]);

% OVERRIDE PROPERTIES
if ~isempty(fieldnames(override))
    disp('trying to override static variables BEFORE...');
    cellfun(@(f) evalin('caller',...
    ['systemTemplate.params.' f ' = override.' f ';']), fieldnames(override));
end
    
cnst.saveImage = true; % save image after each run
sysPackPre = getSystemPackage(modVars,systemTemplate,randmodulator);
disp('updated parameter container for FIRST RUN');
disp(['will perform ',num2str(numel(sysPackPre)),' runs']);


% PREPARE THE SYSTEM
rng('shuffle');
masterID = ['TvI_',dec2hex(round(rand()*10e10)),'_',char(expname)];
mkdir(['./output/',masterID]);
disp('starting the model...');

%% FIRST RUN: BEFORE INTERVENTION
globalTime = tic;
%parfor
% DEBUG DEBUG
parfor i=1:numel(sysPackPre) % FIRST RUN: RUN SYSTEM UNTIL INTERIM ANALYSIS
    disp([10,'starting first run of experiment #',num2str(i)]);
    % START PLAUSIBILITY CHECK ----------------------------------------------
    if ~checkPlausibility(sysPackPre{i})
        warning('implausible parameter set'); continue
    end
    % END PLAUSIBILITY CHECK ------------------------------------------------
    nAttempts = 1;
    while nAttempts <= 5 % try 5 times 
    partialTime = tic;
    disp('starting analysis...'); % run the model
    [sysPackPre{i}, lastImage, summaryPre{i}, imWin, fcount] = ...
        growTumor_2D(sysPackPre{i},cnst);
    disp(['finished experiment #',num2str(i), ', nAttempts = ', num2str(nAttempts),...
        ', time needed: ', num2str(toc(partialTime)), ' imWin = ', num2str(imWin)]);
    % if the tumor was eradicated prematurely, try a different seed
    if imWin~=0 && imWin <= requireTumorAlive 
        sysPackPre{i}.params.initialSeed = sysPackPre{i}.params.initialSeed + 10;
        nAttempts = nAttempts + 1;
        disp('attempt was NOT successful');
    else % successful -> save images
        if cnst.saveImage
            for k = 1:fcount
            imwrite(lastImage{k},['./output/',masterID,'/','iter_',num2str(i),...
                '_01-PRE_frame_',num2str(k),'_attempt_',num2str(nAttempts),'.png']);
            disp(['saved experiment #',num2str(i),' frame ', num2str(k), ' PRE']);
            end
        end
        disp(['attempt was successful',10]); break
    end
    end
end
disp(['total time was ',num2str(toc(globalTime))]);
if cnst.doSummary % summarize first experiment
    [finalSummaryPre,paramsPre] = summarizeExperiment_2D(sysPackPre,cnst);
end

%% SECOND RUN: AFTER INTERVENTION
disp([10,'###',10,'starting second run',10]);
% create parameter sets for SECOND RUN
sysPackPost = modifyTwoParams(sysPackPre,modVars); % second package = after intervention
disp('updated parameter container for SECOND RUN');
cnst_second = cnst; % prepare parameters for additional steps
cnst_second.nSteps = tAfterInterv; % additional steps
cnst_second.createNewSystem = false; % use existing simulation
saveImage = cnst.saveImage; 

%parfor
parfor i=1:numel(sysPackPost) % SECOND RUN
disp(['starting second run of experiment #',num2str(i)]);
    % SECOND PART: RUN SYSTEM AGAIN
    [sysPackPost{i}, lastImage, summaryPost{i}, imWin, fcount] = ...
        growTumor_2D(sysPackPost{i},cnst_second);
        if saveImage
            for k = 1:fcount
            imwrite(lastImage{k},['./output/',masterID,'/','iter_',num2str(i),...
                '_02-POST_frame_',num2str(k),'.png']);
            disp(['saved experiment #',num2str(i),' frame ', num2str(k), ' POST']);
            end
        end   
    disp(['finished second run of experiment #',num2str(i)]); 
end

if cnst.doSummary % summarize second experiment
    [finalSummaryPost,paramsPost] = summarizeExperiment_2D(sysPackPost,cnst_second);  
end

% SAVE ALL RESULTS
save(['./output/',masterID],'finalSummaryPre','paramsPre',...
    'finalSummaryPost','paramsPost','summaryPre','summaryPost');

% clean up
clear set finalSummaryPre paramsPre finalSummaryPost paramsPost
clear summaryPre summaryPost cnst_second sysPackPre sysPackPost

end

