function [sysOut, lastFrame, summary, imWin, fcount, masterID] = ...
    runSystem(sysTempl,cnst,expname,saveImage,saveVideo)
% last preparations
masterID = ['Experiment_',char(expname)];
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

if imWin~=0 && imWin < cnst.requireAlive % attempt unsuccessful, try again
    sysTempl.params.initialSeed = sysTempl.params.initialSeed + 10;
else, break     % attempt successful
end

end
disp(['total time was ',num2str(toc(globalTime))]);

if saveImage
imwrite(lastFrame{end},['./output/',masterID,'/lastState.png']); % save last frame as image
end
if saveVideo
    writeMyVideo(lastFrame,['./output/',masterID,'/Movie'],4); % save whole process as video
end
end