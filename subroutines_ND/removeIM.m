function [IMcells,IMprop] = removeIM(IMcells,IMprop,idx)

    IMcells(idx) = [];           % remove from stack
    IMprop.Pcap(idx) = [];     % remove Pmax property
    IMprop.Kcap(idx) = [];       % remove Kmax property
    IMprop.engaged(idx) = [];       % remove engagement property
    
end

