function [IMcells,IMprop] = shuffleIM(IMcells,IMprop)

shf = randperm(length(IMcells)); % prepare random shuffling
IMcells = IMcells(shf); % randomly shuffle cells
IMprop.Pcap = IMprop.Pcap(shf); % shuffle Pmax property accordingly
IMprop.Kcap = IMprop.Kcap(shf); % shuffle Kmax property accordingly

end