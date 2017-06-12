function Lt = updateTumorGrid(L,TUcells)
    Lt = false(size(L)); % reset tumor grid
    Lt(TUcells) = true; % update tumor grid
end