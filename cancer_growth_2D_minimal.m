% 2016-2017, created by JN Kather, includes code snippets by Jan Poleszczuk
% license: see separate license file

% What is this?
% - this is an agent-based model of tumor cell - immune cells interactions
% How does it work?
% - open this file in Matlab and run it. A model run with default
% parameters will be started. 

%% PREPARE
close all, clear all, format compact, clc
addpath('./subroutines_2D/'); % include all functions for the 2D model
addpath('./subroutines_ND/'); % include generic subroutines

% all parameters for the model are stored in the structure "sysTempl".
% Hyperparameters are stored in the structure "cnst". If you want to 
% manually change parameters, you need to overwrite the respective value 
% in sysTempl.params or in cnst, for example by adding
% "sysTempl.params.TUps = 0.65" after the call to "getSystemParams"
[sysTempl, cnst] = getSystemParams('2D',[300 300]);
% override some system parameters (just for this example)
sysTempl.params.mycellsize = 10;          % size of cells for visualization
sysTempl.params.TUps = 0.75;         
sysTempl.params.IMinfluxProb = 0.6;
sysTempl.params.IMinflRate = 1;
sysTempl.params.IMpkill = 0.25;   
sysTempl.params.probSeedFibr = 0.01;
sysTempl.params.probSeedNecr = 0.0001;
sysTempl.params.initialSeed = 71;

% add/override some global variables after loading the system
cnst.nSteps   = 240;    % how many iterations in the first place
cnst.drawWhen = 1;    % draw after ... iterations
cnst.saveImage = true;  % save image after each run
requireAlive = 150;     % require tumor to be alive for some time
expname = 'minimal';    % experiment name that will be used to save results

% last preparations
masterID = ['TestRun_',char(expname)];
mkdir(['./output/',masterID]); % create output directory to save results

%% RUN THE MODEL
% the model run is started by calling "growTumor_2D(...)". Because the
% tumor should not spontaneously die in the first few rounds, this process
% can be repeated four times until the tumor is still alive in the round
% specified by "requireAlive"
globalTime = tic;    % start timer
for nAttempts = 1:5  % try again if the tumor died too early
    
[sysOut, lastFrame, summary, imWin, fcount] = growTumor_2D(sysTempl,cnst);
% input variables:
% sysTempl: contains all parameters for the system (in the field
% sysTempl.params). Also, this strucutre will be used to save all model
% details later on. 
% cnst: contains all hyperparamters
%
% output variables:
% sysOut: this is a modified version of sysTempl that contains all
% information about the model in its final state, e.g. the positions and
% properties of all agents.
% lastFrame: contains a snapshot image of the the system everytime it was
% visualized (controlled by cnst.drawWhen)
% summary: contains summary statistics, e.g. number of tumor cells
% imWin: true if no tumor cells are left anymore
% fcount: how many times was the system visualized?

if imWin~=0 && imWin < requireAlive % attempt unsuccessful, try again
    sysTempl.params.initialSeed = sysTempl.params.initialSeed + 10;
else, break     % attempt successful
end

end
disp(['total time was ',num2str(toc(globalTime))]);

% save last frame as image
imwrite(lastFrame{end},['./output/',masterID,'/lastState.png']);

% save whole process as video
saveVideo(lastFrame,['./output/',masterID,'/Movie'],4);
