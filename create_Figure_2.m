% JN Kather 2017, jakob.kather@nct-heidelberg.de
% this script will create the data for Figure 2: 
%
% Figure 2: The model reproduces major immunological phenotypes of tumors. 
% In general, four types of immune phenotypes can be distinguished: hot 
% and cold tumors, immune excluded or eradicated tumors (fibrous scar). 
% The agent-based model yields all those four phenotypes, depending only 
% on the variation of two parameters (related to fibrosis generation and 
%tumor cell killing). (A) cold tumor, (B) hot tumor, (C) immune excluded 
% phenotype, (D) tumor eradication. Scale bars: 2 mm.

close all, clear all, format compact, clc
addpath('./subroutines_2D/'); % include all functions for the 2D model
addpath('./subroutines_ND/'); % include generic subroutines
rng('default');

[sysTempl, cnst] = getSystemParams('2D',[336 336]);
cnst.nSteps   = 350;    % how many iterations in the first place
cnst.drawWhen = 350;    % draw after ... iterations
saveImage = true; 
saveVideo = false;
randmod = 200; % random modulator, choose 100 or 200

% vary two variables: fibrosis seeding and killing probability
modVars.probSeedFibr =  [0,0.0100,0.1200,0.2000];       
modVars.IMpkill =       [0,0.0100,0.0500,0.2500];       
sysPack = getDualSysPack(sysTempl,modVars,randmod);

% -------------------------------------------------------------------------
parfor i=1:numel(sysPack)
        expname = ['Figure_3_',num2str(i),'_',dec2hex(round(rand()*10e10))]; 
        [sysOut, lastFrame, summary, imWin, fcount, masterID] = ...
            runSystem(sysPack{i},cnst,expname,saveImage,saveVideo); % run the system
end
