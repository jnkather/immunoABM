function [modVars,overrideBefore,timeFirstRun,domainSize,addSteps] = getHyperparameters(expname)

% nI = sample the parameter space in how many levels per dimension, default 10
% caution: if you change nI, do so before assigning other parameters

% default time and space parameters
timeFirstRun = [50 50];
domainSize = [600 600];
addSteps = 500; 
nI = 8;
overrideBefore = struct([]);
    
switch char(expname) % parameters change after intervention
    
    case 'default' % for developing purposes
    timeFirstRun = [750 50];
    domainSize = [500 500];
    addSteps = 0; 
    modVars = [];
    
    case 'TUmod'
    modVars.TUps = linspace(0.5,1,nI);
    modVars.TUpmig = linspace(0.2,0.4,nI);
    
    case 'IMstro'
    modVars.probSeedFibr = linspace(0.01,0.2,nI);
    modVars.IMinfluxProb = linspace(0.4,0.8,nI);
        
    case 'TUstro'
    modVars.probSeedFibr = linspace(0.1,0.6,nI);
    modVars.TUps = linspace(0.3,0.9,nI);
    
    case 'IMmobile'
    modVars.IMpmig = linspace(0.3,0.6,nI);
    modVars.IMrwalk = linspace(0.3,0.9,nI); 
    
    case 'IMfierce'
    modVars.IMpkill = linspace(0.1,0.7,nI);
    modVars.IMrwalk = linspace(0.3,0.9,nI); 
    
    case 'IMpattern'
    modVars.probSeedFibr = linspace(0.1,0.6,nI);
    modVars.IMrwalk = linspace(0.3,0.9,nI); 

    case 'NecroFibro'
    modVars.probSeedFibr = linspace(0.1,0.6,nI);
    modVars.probSeedNecr = linspace(0.000001,0.0002,nI); 

    case 'IMnum'
    modVars.IMinfluxProb = linspace(0.1,0.9,nI);
    modVars.IMinflRate = 1:5; 
    
    case 'PermIM'
    modVars.IMinfluxProb = linspace(0.45,0.85,nI);  
    modVars.stromaPerm = linspace(0,0.15,nI); 
    
    case 'Figure_Showcase_INFL_FIBR'
    domainSize = [336 336]; % 5 mm by 5 mm
    timeFirstRun = [50 50];
    addSteps = 300; 
    modVars.IMinfluxProb = [0.60,0.62,0.74,0.75,0.80];
    modVars.probSeedFibr = [0.01,0.05,0.10,0.12];
    
    case 'Figure_Showcase_INFL_KILL'
    domainSize = [336 336]; % 5 mm by 5 mm
    timeFirstRun = [50 50];
    addSteps = 300; 
    modVars.IMinfluxProb = [0.4,0.75];
    modVars.IMpkill = [0.05,0.1,0.25];
    
    case 'Figure_Showcase_FIBR_KILL'
    domainSize = [336 336]; % 5 mm by 5 mm
    timeFirstRun = [50 50];
    addSteps = 300; 
    modVars.probSeedFibr = [0.01,0.12,0.2];
    modVars.IMpkill = [0.05,0.1,0.25];
    
    % INTERVENTIONS VER 2
    
%     case 'INTERVENTION_HI_STRO_HI_LYM'
%     domainSize = [400 400]; 
%     timeFirstRun = [120 30];
%     addSteps = 300; 
%     modVars.probSeedFibr = [0.06, 0.06];
%     modVars.IMinflRate =   [8, 8, 8, 8];
%     %overrideBefore.IMinflRate = 0;
%     
%     case 'INTERVENTION_HI_STRO_LO_LYM'
%     domainSize = [400 400];
%     timeFirstRun = [120 30];
%     addSteps = 300; 
%     modVars.probSeedFibr = [0.06, 0.06];
%     modVars.IMinfluxProb =  [0.4, 0.4, 0.4, 0.4];    
%     %overrideBefore.IMinfluxProb = 0;
%     
%     case 'INTERVENTION_LO_STRO_LO_LYM'
%     domainSize = [400 400]; 
%     timeFirstRun = [120 30];
%     addSteps = 300; 
%     modVars.probSeedFibr = [0.0001, 0.0001];
%     modVars.IMinfluxProb =  [0.4, 0.4, 0.4, 0.4];   
%     %overrideBefore.IMinfluxProb = 0;
%     
%     case 'INTERVENTION_LO_STRO_HI_LYM'
%     domainSize = [400 400];
%     timeFirstRun = [120 30];
%     addSteps = 300; 
%     modVars.probSeedFibr = [0.0001, 0.0001];
%     modVars.IMinflRate =   [8, 8, 8, 8];    
%     %overrideBefore.IMinflRate = 0;

% +++++++++++++++++

        case 'INTERVENTION_HI_STRO_HI_LYM_MANY'
    domainSize = [400 400]; % was 500 500
    timeFirstRun = [120 15]; % was 120 30
    addSteps = 240;  % was 360
    modVars.probSeedFibr = repmat(0.06,[1 5]);   %was repmat(0.06,[1 5]); 
    modVars.IMinflRate =   repmat(8,[1 10]);   %was repmat(8,[1 10]);  
    %overrideBefore.IMinflRate = 0;
    
    case 'INTERVENTION_HI_STRO_LO_LYM_MANY'
    domainSize = [400 400]; % was 500 500
    timeFirstRun = [120 15]; % was 120 30
    addSteps = 240;  % was 360 
    modVars.probSeedFibr =  repmat(0.06,[1 5]);   %was repmat(0.06,[1 5]); 
    modVars.IMinfluxProb =  repmat(0.2,[1 10]);   %was repmat(0.4,[1 10]);  
    %overrideBefore.IMinfluxProb = 0;
    
    case 'INTERVENTION_LO_STRO_LO_LYM_MANY'
    domainSize = [400 400]; % was 500 500 
    timeFirstRun = [120 15]; % was 120 30
    addSteps = 240;  % was 360
    modVars.probSeedFibr = repmat(0.003,[1 5]);   %was repmat(0.0001,[1 5]); 
    modVars.IMinfluxProb =  repmat(0.2,[1 10]);   %was repmat(0.4,[1 10]);  
    %overrideBefore.IMinfluxProb = 0;
    
    case 'INTERVENTION_LO_STRO_HI_LYM_MANY'
    domainSize = [400 400]; % was 500 500
    timeFirstRun = [120 15]; % was 120 30
    addSteps = 240;  % was 360
    modVars.probSeedFibr = repmat(0.003,[1 5]);   %was repmat(0.0001,[1 5]); 
    modVars.IMinflRate =   repmat(8,[1 10]);   %was repmat(8,[1 10]);  
    %overrideBefore.IMinflRate = 0;
    
    % **************
    case 'GRIDSEARCH_STRO_V1A' % PREP DONE
    domainSize = [500 500];
    timeFirstRun = [50 50];
    addSteps = 650; 
    modVars.probSeedFibr = 0.03:0.015:0.18;
    modVars.IMinfluxProb = 0.2:0.07:1; 
    
    case 'GRIDSEARCH_STRO_V1AL' % PREP DONE
    domainSize = [500 500];
    timeFirstRun = [50 50];
    addSteps = 650; 
    modVars.probSeedFibr = 0.03:0.015:0.18;
    modVars.IMinfluxProb = 0.2:0.07:1;   
    clear overrideBefore
    overrideBefore.smoothSE = strel('disk',5);
    
    case 'GRIDSEARCH_STRO_V1B' % PREP DONE
    domainSize = [274 274];
    timeFirstRun = [50 50];
    addSteps = 650; 
    modVars.probSeedFibr = 0.03:0.015:0.18;
    modVars.IMinfluxProb = 0.2:0.07:1;    

    case 'GRIDSEARCH_STRO_V2A' % PREP DONE
    domainSize = [500 500];
    timeFirstRun = [50 50];
    addSteps = 650; 
    modVars.TUps = 0.52:0.02:0.75;
    modVars.probSeedFibr = 0.01:0.02:0.2;
    
    case 'GRIDSEARCH_STRO_V2B' % PREP DONE
    domainSize = [274 274];
    timeFirstRun = [50 50];
    addSteps = 400; 
    modVars.TUps = 0.52:0.02:0.75;
    modVars.probSeedFibr = 0.01:0.02:0.2;
    
    case 'GRIDSEARCH_STRO_V3' % PREP DONE
    domainSize = [979 979];
    timeFirstRun = [50 50];
    addSteps = 950; 
    modVars.probSeedNecr = 0.00005*(6:4:50);
    modVars.IMinfluxProb = 0.1:0.1:1;  
    clear overrideBefore
    overrideBefore.probSeedFibr = 0.02;
    
    case 'GRIDSEARCH_STRO_V3L' % PREP DONE
    domainSize = [979 979];
    timeFirstRun = [50 50];
    addSteps = 950; 
    modVars.probSeedNecr = 0.00005*(6:2:25);
    modVars.IMinfluxProb = 0.1:0.1:1;  
    clear overrideBefore
    overrideBefore.probSeedFibr = 0.02;    
    overrideBefore.smoothSE = strel('disk',5);  
    
    % ----------- IMMUNOTHERAPY SIMULATION
    
    case 'THERAPY_IMMUNE_ONLY' % PREP DONE
    domainSize = [500 500];
    timeFirstRun = [250 50];
    addSteps = 250; 
    modVars.IMinflRate =  2:2:12;
    modVars.IMinfluxProb = repmat(0.4,[1,11]);  
    clear overrideBefore
    overrideBefore.probSeedFibr = 0.06;    
    overrideBefore.IMinfluxProb = 0.4; 
    overrideBefore.stromaPerm = 0; 
    overrideBefore.IMpkill = 0.6; 
    
    case 'THERAPY_IMMUNE_STROMAPERM' % PREP DONE
    domainSize = [400 400];
    timeFirstRun = [300 50];
    addSteps = 300; 
    modVars.IMinflRate =  3:1:12;
    modVars.stromaPerm = 0:0.05:0.45; 
    clear overrideBefore
    overrideBefore.probSeedFibr = 0.04;    
    overrideBefore.IMinfluxProb = 0.4; 
    overrideBefore.stromaPerm = 0; 
    overrideBefore.IMpkill = 0.6; 
    
    % ----------- IMMUNOTHERAPY SIMULATION
    
  otherwise % ------- ALL L1 L2 L3 L4 levels
    domainSize = [400 400];
    timeFirstRun = [240 60];
    addSteps = 240; % previously: 300
	clear overrideBefore
    overrideBefore.probSeedFibr = 0.01;    % was 0.04
   % overrideBefore.IMinfluxProb = 0.4; 
   % overrideBefore.TUps = 0.70; 
    overrideBefore.stromaPerm = 0;  
   % overrideBefore.IMpkill = 0.1; % was 0.25
    
    repeatMe1 = [1 3]; % default 1 3
    repeatMe2 = [1 8]; % default 1 8
    
    myInfl = [1      2      4     8];
    myPerm = [0      0.04    0.08   0.16];

	switch char(expname) % GRADUAL
	
	case 'THERAPY_IMMUNE_STROMAPERM_L1-L1'		% LOW IMMUNE --------
	modVars.IMinflRate = repmat(myInfl(1),repeatMe1);
    modVars.stromaPerm = repmat(myPerm(1),repeatMe2); 
	
	case 'THERAPY_IMMUNE_STROMAPERM_L1-L2'
	modVars.IMinflRate = repmat(myInfl(1),repeatMe1);
    modVars.stromaPerm = repmat(myPerm(2),repeatMe2); 
	
	case 'THERAPY_IMMUNE_STROMAPERM_L1-L3'
	modVars.IMinflRate = repmat(myInfl(1),repeatMe1);
    modVars.stromaPerm = repmat(myPerm(3),repeatMe2); 
	
	case 'THERAPY_IMMUNE_STROMAPERM_L1-L4'
	modVars.IMinflRate = repmat(myInfl(1),repeatMe1);
    modVars.stromaPerm = repmat(myPerm(4),repeatMe2); 	
	
		case 'THERAPY_IMMUNE_STROMAPERM_L2-L1'		% LO MID IMMUNE --------
		modVars.IMinflRate = repmat(myInfl(2),repeatMe1);
		modVars.stromaPerm = repmat(myPerm(1),repeatMe2); 
		
		case 'THERAPY_IMMUNE_STROMAPERM_L2-L2'
		modVars.IMinflRate = repmat(myInfl(2),repeatMe1);
		modVars.stromaPerm = repmat(myPerm(2),repeatMe2); 
	
		case 'THERAPY_IMMUNE_STROMAPERM_L2-L3'
		modVars.IMinflRate = repmat(myInfl(2),repeatMe1);
		modVars.stromaPerm = repmat(myPerm(3),repeatMe2); 
	
		case 'THERAPY_IMMUNE_STROMAPERM_L2-L4'
		modVars.IMinflRate = repmat(myInfl(2),repeatMe1);
		modVars.stromaPerm = repmat(myPerm(4),repeatMe2); 	
	
			case 'THERAPY_IMMUNE_STROMAPERM_L3-L1'		% HI MID IMMUNE --------
			modVars.IMinflRate = repmat(myInfl(3),repeatMe1);
			modVars.stromaPerm = repmat(myPerm(1),repeatMe2); 
		
			case 'THERAPY_IMMUNE_STROMAPERM_L3-L2'
			modVars.IMinflRate = repmat(myInfl(3),repeatMe1);
			modVars.stromaPerm = repmat(myPerm(2),repeatMe2); 
			
			case 'THERAPY_IMMUNE_STROMAPERM_L3-L3'
			modVars.IMinflRate = repmat(myInfl(3),repeatMe1);
			modVars.stromaPerm = repmat(myPerm(3),repeatMe2); 
			
			case 'THERAPY_IMMUNE_STROMAPERM_L3-L4'
			modVars.IMinflRate = repmat(myInfl(3),repeatMe1);
			modVars.stromaPerm = repmat(myPerm(4),repeatMe2); 	
		
				case 'THERAPY_IMMUNE_STROMAPERM_L4-L1' 			% HI IMMUNE --------
				modVars.IMinflRate = repmat(myInfl(4),repeatMe1);
				modVars.stromaPerm = repmat(myPerm(1),repeatMe2); 
			
				case 'THERAPY_IMMUNE_STROMAPERM_L4-L2'
				modVars.IMinflRate = repmat(myInfl(4),repeatMe1);
				modVars.stromaPerm = repmat(myPerm(2),repeatMe2); 	
				
				case 'THERAPY_IMMUNE_STROMAPERM_L4-L3'
				modVars.IMinflRate = repmat(myInfl(4),repeatMe1);
				modVars.stromaPerm = repmat(myPerm(3),repeatMe2); 
			
				case 'THERAPY_IMMUNE_STROMAPERM_L4-L4'
				modVars.IMinflRate = repmat(myInfl(4),repeatMe1);
				modVars.stromaPerm = repmat(myPerm(4),repeatMe2); 	
			
	end
    
    
end

end