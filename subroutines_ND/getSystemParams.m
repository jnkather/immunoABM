function [mySystem, cnst] = getSystemParams(dims,spaceSetting)
disp('requested system parameters');

% START GENERAL SYSTEM PROPERTIES -------------------------------------------
mySystem.params.initialSeed = 1;   % initial random seed, default 1
mySystem.params.useMex = false;    % use MEX compiled subroutines wherever applicable
mySystem.params.debugmode = false; % check consistency in each iteration, computationally expensive
% END SYSTEM PROPERTIES -------------------------------------------

% START INITIALIZE TUMOR CELLS -------------------------------------------
mySystem.params.TUpprol = 0.5055;   % HISTO GENERATED - probability of proliferation
mySystem.params.TUpmig = 0.35;      % probability of migrating, default 0.35
mySystem.params.TUpdeath = 1-(1-0.0319)^4;  % HISTO GENERATED - probability of spontaneous death
mySystem.params.TUpmax = 10;        % max. proliferation capacity, default 10
mySystem.params.TUps = 0.7;         % probability of symmetric division, default 0.7
% END INITIALIZE TUMOR CELLS ---------------------------------------------

% START INITIALIZE LYMPHOCYTES ------------------------------------------
mySystem.params.IMkmax = 5;         % killing capacity of immune cells, default 5
mySystem.params.IMpmax = 10;        % proliferation capacity of immune cells, default 10
mySystem.params.IMpprol = 0.0449;   % HISTO GENERATED - probability of proliferation
mySystem.params.IMpmig = 0.8;       % probability of migrating, default 0.7
mySystem.params.IMpkill = 0.3;      % probability of killing, default 0.15
mySystem.params.IMpdeath = 1-(1-0.0037)^4;  % HISTO GENERATED - probability of spontaneous death
mySystem.params.IMrwalk = 0.8;      % random influence on movement, default 0.75
mySystem.params.IMspeed = 97;       % speed of immune cell movement, default 90
mySystem.params.IMinfluxProb = 0.3; % probability of immune cell influx, def. 0.72
mySystem.params.IMinflRate = 1;     % how many immune cells appear simultaneously
% END INITIALIZE LYMPHOCYTES --------------------------------------------

% START INITIALIZE NECROSIS AND FIBROSIS  ---------------------------------
mySystem.params.distMaxNecr = 134;     % if necrosis occurs, then it occurs within 2 mm (134 = approx. 2 mm)
mySystem.params.probSeedNecr = 0.00004; % seed necrosis
mySystem.params.probSeedFibr = 0.00025;   % probability of turning into fibrosis
seedFrac = 0.3;
mySystem.params.necrFrac = seedFrac;  % size of necrotic seed, 0...1, default 0.3
mySystem.params.fibrFrac = seedFrac;  % size of fibrotic seed, 0...1, default 0.3
mySystem.params.stromaPerm = 0.0025;        % 0 = stroma not permeable, 1 = fully permeable
% END INITIALIZE NECROSIS AND FIBROSIS  ---------------------------------

% START DEFINING ADDITIONAL CONSTANTS -----------------------------------
cnst.verbose = true;            % draw intermediary steps? default true
cnst.createNewSystem = true;    % create new system at the start, default true
cnst.saveImage = true;          % save image directly after each iteration, default true
cnst.doImage = false;           % plot result again afterwards, default false
cnst.doVideo = false;           % create a video afterwards, default false
cnst.doSummary = true;          % summarize the result, default true
cnst.inTumor = 1;               % defines "in tumor" ROI, default 1
cnst.marginSize = 5;            % default "invasive margin" ROI, default 5
cnst.around = 120;              % defines "adjacent tissue" ROI, default 120 = 1 mm
% END DEFINING ADDITIONAL CONSTANTS -----------------------------------

% START DEFINING DIMENSION VARIABLES  -----------------------------------
if strcmp(dims,'2D') % parameters that are specific for 2D
defRadius = 4;
mySystem.params.smoothSE = strel('disk',defRadius); % smoothing structuring element for region growth
mySystem.params.fillSE = strel('disk',defRadius); % smoothing structure for hypoxia map
mySystem.grid.N = spaceSetting(1);  % domain dimension vertical, default 380
mySystem.grid.M = spaceSetting(2);  % domain dimension horizontal, default 380
mySystem.params.mycellsize = 5;   % ball size in scatter plot, default 2

elseif strcmp(dims,'3D') % parameters that are specific for 3D
mySystem.params.smoothSE = ones(3,3,3); % smoothing structuring element for region growth
mySystem.grid.N = spaceSetting(1);  % domain dimension 1, default 80
mySystem.grid.M = spaceSetting(2);  % domain dimension 2, default 50
mySystem.grid.P = spaceSetting(3);  % domain dimension 3, default 30

else
    error('dimension must be 2D or 3D')
end

% START PLAUSIBILITY CHECK ----------------------------------------------
checkPlausibility(mySystem);
% END PLAUSIBILITY CHECK ------------------------------------------------

end