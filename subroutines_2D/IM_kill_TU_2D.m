% JN Kather 2016
% this function can be compiled to yield a massive speed increase
function [TUcells, TUprop, IMcells, IMprop, L, Lt] = ...
IM_kill_TU_2D(TUcells, TUprop, IMcells, IMprop, L, Lt,IMpkill,nh,ChtaxMap,engagementDuration)

% pre-select immune cells that may be close enough to the tumor
candidates = ChtaxMap(IMcells)<=1;
if sum(candidates(:)) % if there are candidates
    % select cells that are going to kill
    K = candidates & (IMprop.engaged==0) & (IMprop.Kcap>0) & (rand(1,length(IMcells))<IMpkill);
    actK = find(K); % cell indices
    if ~isempty(actK) % if there is a cell that is going to kill
    targetIDs = int32(zeros(1,0)); % preallocate
    killerIDs = int32(zeros(1,0)); % preallocate
    % start tumor cell killing, same random order as before
    St = bsxfun(@plus,IMcells(actK),nh.aux(nh.Pms(:,randi(nh.nP,1,length(actK)))));
    % iterate through all immune cells and look at their neighborhood
    for jj = 1:size(St,2) 
        neighbPosit = St(randperm(length(nh.aux)),jj);
        instakill = ismember(neighbPosit(:),TUcells(:));
        % if the cell encounters another cell to kill
        if sum(instakill) > 0 
            % if more than 1 possible targets then use the first one
            possibleTargets = neighbPosit(instakill); % possible targets
            killwhat = int32(possibleTargets(1)); % kill only the first candidate   
            targetIDs = [targetIDs, killwhat]; % add target ID to stack
            killerIDs = [killerIDs, IMcells(actK(jj))]; % add killer ID to stack
        end
    end

    % find indices to killed cell and killer cell. If the unlikely case
    % happens that one tumor cell is simultaneously killed by two immune cells,
    % then both will be exhausted
    auxKillTU = ismember(TUcells,targetIDs); % which tumor cells are killed
    auxKillIM = ismember(IMcells,killerIDs); % which immmune cells do kill

    if sum(auxKillTU)>0                 % if killing happens, then update  
        L(TUcells(auxKillTU)) = false;  % FIRST remove from L grid
        Lt(TUcells(auxKillTU)) = false;  % ... and remove from Lt grid
        [TUcells,TUprop] = removeTU(TUcells,TUprop,auxKillTU); % second, remove from stack
        IMprop.Kcap(auxKillIM) = IMprop.Kcap(auxKillIM)-1; % exhaust killers
        IMprop.engaged(auxKillIM) = engagementDuration; % killers are engaged
    end

    end % end actual killing filter
end % end candidate filter
end % end function
