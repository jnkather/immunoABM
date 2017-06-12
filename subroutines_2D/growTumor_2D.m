% JN Kather 2017, jakob.kather@nct-heidelberg.de

function [mySystem, finalImage, finalSummary, imWin, fcount] = ...
    growTumor_2D(mySystem,cnst)
% growTumor_2D performs the actual agent-based modeling in 2D
%       input are two structures: mySystem, defining the initial state of
%       the system; and cnst, defining some global constants

% START PREPARATIONS -------------------------------------------
% throw all model parameters to workspace
cellfun(@(f) evalin('caller',[f ' = mySystem.params.' f ';']), fieldnames(mySystem.params));
cellfun(@(f) evalin('caller',[f ' = mySystem.grid.' f ';']), fieldnames(mySystem.grid));
if cnst.createNewSystem % create a new (empty) system
    [L, TUcells, IMcells, TUprop, IMprop] = initializeSystem_2D(N,M,TUpmax);
    Ln = false(size(L));    % initialize necrosis map
    Lf = false(size(L));    % initialize fibrosis map
else % use existing system and grow it further
    cellfun(@(f) evalin('caller',[f ' = mySystem.TU.' f ';']), fieldnames(mySystem.TU));
    cellfun(@(f) evalin('caller',[f ' = mySystem.IM.' f ';']), fieldnames(mySystem.IM));
end
% END PREPARATIONS -------------------------------------------
    
% START INITIALIZE AUX VARIABLES  ----------------------------------------
nh = neighborhood_2D(N);   % get neighborhood indices
L = setEdge_2D(L,true);    % set boundary to occupied
rng(initialSeed);       % reset random number generator 
imWin = 0;              % set immune win flag to 0
fcount = 0;             % frame counter for video export
finalImage = [];        % set empty resulting image
% END INITIALIZE AUX VARIABLES   -----------------------------------------

% START ITERATION
for i = 1:cnst.nSteps % iterate through time steps

% adjust fibrosis permeability
Lperm = rand(size(L))<stromaPerm; % randomly create permeability map
L(Lf) = ~Lperm(Lf); % occupied means not permeable

% START TUMOR CELL ROUND ------------------------------------------------
L([IMcells,TUcells]) = true; % ensure that all cells are present on the grid
[TUcells,TUprop] = shuffleTU(TUcells,TUprop);
[L, TUcells, TUprop] = TU_go_grow_die_2D( L, nh, TUcells, TUprop, TUpprol, TUpmig, TUpdeath, TUps);
Lt = updateTumorGrid(L,TUcells); % update tumor grid
L([IMcells,TUcells]) = true; % ensure that all cells are present on the grid
% END TUMOR CELL ROUND ---------------------------------------------------

% START MODIFY PARAMETER MAPS --------------------------------------------
[ChtaxMap, HypoxMap] = updateParameterMaps(Lt,Ln,Lf,fillSE,distMaxNecr);
% END MODIFY PARAMETER MAPS

% START IMMUNE CELL ROUND ------------------------------------------------
L([IMcells,TUcells]) = true; % ensure that all cells are present on the grid
if rand()<=IMinfluxProb % randomly trigger influx
[L,IMcells,IMprop] = IMinflux(L,IMcells,IMprop,IMpmax,IMkmax,IMinflRate);
end

[IMcells,IMprop] = shuffleIM(IMcells,IMprop); % randomly shuffle immune cells
L(Ln) = false; % for immune cell movement, necrosis is invisible
L([IMcells,TUcells]) = true; % ensure that all cells are present on the grid

if numel(IMcells)>0 % if there are any immune cells 
for j = 1:(IMspeed-1) % allow immune cells to move N times per round
    [L, IMcells] =  IM_go_2D(IMcells, IMpmig, IMrwalk, ChtaxMap, L, nh);
end

% tumor cell killing by immune cells (1/2)
[TUcells, TUprop, IMcells, IMprop, L, Lt] = ...
IM_kill_TU_2D(TUcells, TUprop, IMcells, IMprop, L, Lt,IMpkill,nh,ChtaxMap);

% allow immune cells to move once more, to proliferate or die
[L, IMcells, IMprop] =  IM_go_grow_die_2D(IMcells, IMprop, IMpprol, IMpmig, ...
        IMpdeath, IMrwalk, IMkmax, ChtaxMap, L, nh); 

% tumor cell killing by immune cells (2/2)
[TUcells, TUprop, IMcells, IMprop, L, Lt] = ...
IM_kill_TU_2D(TUcells, TUprop, IMcells, IMprop, L, Lt,IMpkill,nh,ChtaxMap);

end

L(Ln|Lf) = true; % fully turn on necrosis and fibrosis again
% END IMMUNE CELL ROUND --------------------------------------------------

% START NECROSIS  --------------------------------------------
necrNum = sum(rand(numel(TUcells),1) <= probSeedNecr);
if numel(TUcells)>1 && necrNum>0 % seed necrosis
    seedCoords = randsample(TUcells,necrNum,true,HypoxMap(TUcells));
    necrosisSeeds = false(N,M);
    necrosisSeeds(seedCoords) = true; 
    %disp([num2str(necrNum), ' cell(s) will trigger necrosis']);
    % smooth and expand necrotic seed map
    necrosisSeeds = expandSeedMap(necrosisSeeds,smoothSE,necrFrac);
    seedCoords = find(necrosisSeeds);
    targetIdx = ismember(TUcells,seedCoords); % find indexes of erased tumor cells
    Lt(TUcells(targetIdx)) = false; % remove cell from grid Lt
    Ln(TUcells(targetIdx)) = true; % add to necrosis grid    
    [TUcells,TUprop] = removeTU(TUcells,TUprop,targetIdx); % second, remove from stack
end
% END NECROSIS  ----------------------------------------------

% START FIBROSIS ------------------------------------------------------
fibrosify = ~IMprop.Kcap & (rand(1,numel(IMcells))<probSeedFibr);
if sum(fibrosify) % exchausted immune cells seed fibrosis
    Lfseed = false(size(L));
    Lfseed(IMcells(fibrosify)) = true; 
    % smooth and expand fibrotic seed map
    Lfseed = expandSeedMap(Lfseed,smoothSE,fibrFrac);
    Lfseed(TUcells) = false;
    Lf(Lfseed & ~Ln) = true; %update Lf grid
    [IMcells,IMprop] = removeIM(IMcells,IMprop,fibrosify); % remove fibrosifying immune cells
    L(Lf) = true; % update L grid (master grid)
end
% END FIBROSIS ----------------------------------------------------------

% START DRAWING ---------------------------------------------------------
tumorIsGone = (sum(Lt(:))==0);
if (mod(i-1,cnst.drawWhen)==cnst.drawWhen-1) || tumorIsGone % plot status after N epochs 
    fcount = fcount+1;
    disp(['finished iteration ',num2str(i)]);
    % export current state of the system
    [mySystem,currentSummary] = updateSystem(mySystem,TUcells,TUprop,...
        IMcells,IMprop,ChtaxMap,HypoxMap,L,Lt,Ln,Lf,i,cnst);
    if cnst.verbose % enforce drawing and create image from plot
    visualize_balls_2D_blank(mySystem);
    drawnow, currFrame = getframe(gca);
    finalImage{fcount} = currFrame.cdata;
    finalSummary{fcount} = currentSummary;
    else finalImage = []; finalSummary = [];
    end
end
% END DRAWING -----------------------------------------------------------

% if there are no tumor cells anymore then the game is over
if tumorIsGone
    disp('Immune cells win');
    imWin = i;
    return
end
if debugmode && findInconsistency(Lt,Lf,Ln,TUcells,IMcells,TUprop,IMprop)  
     error('SEVERE ERROR: INCONSISTENCY FOUND');
end % END DEBUG
end % END ITERATION
end % END FUNCTION
        