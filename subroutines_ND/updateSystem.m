
function [mySystem,currentSummary] = updateSystem(mySystem,TUcells,TUprop,...
    IMcells,IMprop,ChtaxMap,HypoxMap,L,Lt,Ln,Lf,i,cnst)

    % copy all variables back to mySystem
    mySystem.TU.TUcells = TUcells;
    mySystem.TU.TUprop.isStem = TUprop.isStem;
    mySystem.TU.TUprop.Pcap = TUprop.Pcap;
    mySystem.IM.IMcells = IMcells;
    mySystem.IM.IMprop.Kcap = IMprop.Kcap;
    mySystem.IM.IMprop.Pcap = IMprop.Pcap;  
    mySystem.grid.ChtaxMap = ChtaxMap;
    mySystem.grid.HypoxMap = HypoxMap;
    mySystem.grid.Ln = Ln;
    mySystem.grid.Lf = Lf;
    mySystem.grid.L = L;
    mySystem.grid.Lt = Lt;
    mySystem.grid.StepsDone = i;

    % create immune grid
    mySystem.grid.Li = false(size(L));
    mySystem.grid.Li(IMcells) = true;
    
    % summarize system
    if ndims(L) == 2
        currentSummary = summarizeSystem_2D(mySystem,cnst);
    elseif ndims(L) == 3
        error('not yet implemented');
    end
    
end
