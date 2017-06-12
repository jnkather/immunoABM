function m = getAdjacent_2D(L,MYcells,nh)

m.S = bsxfun(@plus,MYcells,nh.aux(nh.Pms(:,randi(nh.nP,1,length(MYcells)))));
m.S(L(m.S)) = 0; 			% setting occupied grid cells to false
m.indxF = find(any(m.S)); 	% selecting agents with at least one free spot
m.nC = length(m.indxF); 	% number of agents with free spot
m.randI = rand(1,m.nC); 	% initialize random number vector

end