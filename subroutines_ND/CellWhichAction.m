function [P,D,Mi] = CellWhichAction(randI,pprol,pdeath,pmig)
P = randI <= pprol; % GROW: proliferation
D = (randI <= (pdeath+pprol)) & (randI > pprol); % DIE: spontaneous death can happen anytime
Mi = (randI <= (pdeath+pprol+pmig)) &  (randI > (pdeath+pprol)); % GO: migrate if no grow and no die
end