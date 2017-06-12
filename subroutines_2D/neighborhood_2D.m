function nh = neighborhood_2D(N)
    nh.aux = int32([-N-1 -N -N+1 -1 1 N-1 N N+1])'; % indices to heighborhood
    nh.Pms = perms(uint8(1:8))'; % permutations of adjacent positions
    nh.nP = size(nh.Pms,2); % number of possible permutations
end