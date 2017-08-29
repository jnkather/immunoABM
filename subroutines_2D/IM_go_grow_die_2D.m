% JN Kather 2017 (jakob.kather@nct-heidelberg.de)
% inspired by Jan Poleszczuk
% this function can be compiled with the MATLAB code generator

function [L, IMcells, IMprop] =  IM_go_grow_die_2D(IMcells, IMprop, IMpprol, IMpmig, ...
        IMpdeath, IMrwalk, IMkmax, ChtaxMap, L, nh)
    
m = getAdjacent_2D(L,IMcells,nh); % create masks for adjacent positions

% P, D and Mi are mutually exclusive; Ps and De are dependent on P
[P,D,Mi] = CellWhichAction(m.randI,IMpprol,IMpdeath,IMpmig);
De = P & (IMprop.Pcap(m.indxF) == 0); % proliferation capacity exhaution -> Die
del = D | De; % cells to delete
act = find((P | Mi) & ~del); % indices to the cells that will perform action

for iloop = 1:numel(act) % only for those that will do anything
    currID = act(iloop); % number within stack of currently acting cell
    ngh = m.S(:,m.indxF(currID)); % cells neighborhood
    ngh2 = ngh(ngh>0); % erasing places that were previously occupied
    indOL = find(~L(ngh2)); %selecting all free spots  
    chemo = ChtaxMap(ngh2(:)); % extract chemotaxis value at neighbors
    chemo = chemo(~L(ngh2)); % block occupied spots   
    if ~isempty(chemo) % use spot with highest chemo value
        chemo = chemo/max(chemo(:)); % normalize
        chemo = (1-IMrwalk) * chemo + IMrwalk * rand(size(chemo));
        [~,cid] = min(chemo); % lowest distance 
        indO = indOL(cid(1));   
        if ~isempty(indO) %if there is still a free spot
            L(ngh2(indO)) = true; % add new cell to grid
            if P(currID) % proliferation
                IMcells = [IMcells uint32(ngh2(indO))]; % add new cell to stack
                IMprop.Pcap(m.indxF(currID)) = IMprop.Pcap(m.indxF(currID))-1; % decrease remaining prol. cap.
                IMprop.Pcap = [IMprop.Pcap, IMprop.Pcap(m.indxF(currID))]; % update property vector for Pmax
                IMprop.Kcap = [IMprop.Kcap, IMkmax]; % update property vector for remaining kills
                IMprop.engaged = [IMprop.engaged, 0]; % update property vector for engagement
            else % migration
                L(IMcells(m.indxF(currID))) = false; %freeing spot
                IMcells(m.indxF(currID)) = uint32(ngh2(indO));
            end
        end
    end
end

if ~isempty(del) % updating immune cell death
    L(IMcells(m.indxF(del))) = false;     % remove immune cell from grid
    [IMcells,IMprop] = removeIM(IMcells,IMprop,m.indxF(del)); % second, remove from stack
end
 
end
