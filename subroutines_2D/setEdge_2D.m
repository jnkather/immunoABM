function myArray = setEdge_2D(myArray,myValue)
% setEdge_2D sets the edges of a 2D array to a specified value
%	in this agent based model this function is typically used to
%   set the edges of the grid as occupied so that cells cannot migrate there

myArray(1,:) = myValue; 
myArray(:,1) = myValue; 
myArray(end,:) = myValue; 
myArray(:,end) = myValue; 
end