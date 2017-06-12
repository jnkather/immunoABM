% JN Kather 2017, jakob.kather@nct-heidelberg.de

function summaryOut = summarizeSystem_2D(mySystem,cnst)
%summarizeSystem_NM summarizes the state of a 2D system
%   Input is the "mySystem" structure with fields grid, params, TU, IM
%   and the "cnst" structure, containing basic constants
%   This function genreates a structure "summaryOut" containing all 
%   relevant measurements of the system's state

    % create basic results
    summaryOut.TU_Num = numel(mySystem.TU.TUcells); % tumor cell number
    summaryOut.TU_FracStem = sum(mySystem.TU.TUprop.isStem) ...
        / numel(mySystem.TU.TUprop.isStem); % stem cell fraction
    summaryOut.IM_Num = numel(mySystem.IM.IMcells); % immune cell number
    summaryOut.IM_FracExhaust = sum(mySystem.IM.IMprop.Kcap == 0) ...
        / numel(mySystem.IM.IMcells); % fraction of exhausted immune cells
    
	% if there is a chemotaxis map, then create spatial results
    if isfield(mySystem.grid,'ChtaxMap')
    Mask_intumor = imfill(mySystem.grid.ChtaxMap<cnst.inTumor,'holes');   % binary mask ROI 1
    Mask_margin = mySystem.grid.ChtaxMap<cnst.marginSize & ~Mask_intumor; % binary mask ROI 2
    Mask_around = mySystem.grid.ChtaxMap<cnst.around & ~Mask_margin & ~Mask_intumor;  % binary mask ROI 3
	
	% count cells in regions
    summaryOut.IM_intumor = sum(Mask_intumor(mySystem.IM.IMcells));%/numel(mySystem.IM.IMcells);
    summaryOut.IM_margin = sum(Mask_margin(mySystem.IM.IMcells));%/numel(mySystem.IM.IMcells);
    summaryOut.IM_around = sum(Mask_around(mySystem.IM.IMcells));%/numel(mySystem.IM.IMcells);
	
	% more features: tumor/stroma ratio, tumor/necrosis ratio, stromal immune cell fraction
    summaryOut.TU_Stro_ratio_log = log(double(numel(mySystem.TU.TUcells))/double(sum(mySystem.grid.Lf(:))));
    summaryOut.TU_Necr_ratio_log = log(double(numel(mySystem.TU.TUcells))/double(sum(mySystem.grid.Ln(:))));
    summaryOut.IM_instroma = sum(mySystem.grid.Lf(mySystem.IM.IMcells));%/numel(mySystem.IM.IMcells);
    end
    
    % copy hyper-parameters
    summaryOut.stepsDone = mySystem.grid.StepsDone;
    summaryOut.N = mySystem.grid.N;
    summaryOut.M = mySystem.grid.M;
    
end