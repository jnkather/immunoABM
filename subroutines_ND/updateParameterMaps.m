function [ChtaxMap, HypoxMap] = updateParameterMaps(Lt,Ln,Lf,fillSE,distMaxNecr)
% update chemotaxis map, has to be double for immune cell migration to 
% work locally
ChtaxMap = double(bwdist(Lt,'euclidean')); 
% update hypoxia map
HypoxMap = min(double(bwdist(~imdilate(Lt|Ln|Lf,fillSE),'euclidean')),distMaxNecr) / distMaxNecr;

% HypoxMap is essentially a distance map for the distance from the tumor edge
% within the tumor. All values larger than distMaxNecr are cut at this
% threshold. Then, the mask is normalized to 0 ... 1 with 1 being distMaxNecr
end