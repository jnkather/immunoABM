% to do: make sure that the scatter matrix is plotted correctly

%% preparations
%close all, 
clear all, format compact, clc
addpath('./subroutines_2D/'); % include all functions for the 2D model
addpath('./subroutines_ND/'); % include generic subroutines

inputPath = './output/';
saveResultsPath = './saveResults/';
ballsize = 1500;
numBins = 10; % default 15
recist_labels = fliplr({'PD','SD','PR','CR'});


% specify experiment
sq = @(varargin) varargin;
dd = dir('./output/*INT*.mat');
%dd = dir('./output/*THERAPY_IMMUNE_STROMAPERM_L*.mat');
inputcontainer = sq(dd.name);
    
count = 0;
%% iterate through all experiments
for iter = inputcontainer 
    count = count+1;
inputModelID = char(iter);
tic, load([inputPath,inputModelID]); toc % load model summary

% use paramsOut as independent variables
paramsTpre = nested2table(paramsPre);
paramsTpost = nested2table(paramsPost);
[xVarName, yVarName] = findVars(paramsTpost); % find two independent var names

% extract x and y data for scatter plots
currXData = paramsTpost.(xVarName);
currYData = paramsTpost.(yVarName);

% optional: override constant variables
if numel(unique(currYData)) == 1
    rounds = size(paramsTpost,1)/numel(unique(paramsTpost.(xVarName)));
    repetition = numel(unique(paramsTpost.(xVarName)));
    currYData = floor(1:(1/repetition):(rounds+1-(1/repetition)));
    warning('replacing y data');
    yVarName = 'repetitionsY';
end
if numel(unique(currXData)) == 1
    rounds = size(paramsTpost,1);
    currXData = 1:rounds;
    warning('replacing x data');
    xVarName = 'repetitionsX';
end


% use summaryOut as dependent variables
% first, convert to table
resultsPre = nested2table(finalSummaryPre);
resultsPost = nested2table(finalSummaryPost);

tVars = fieldnames(resultsPre)';
tVars = tVars(1:end-5);
for tVarName={'TU_Num'} %tVars

% POST intervention
fpost =figure();
hpost = subplot(1,1,1);
targetData = resultsPost.(char(tVarName));

scatter(currXData,currYData,ballsize,targetData,'filled');
colormap((parula))
colorbar
setAxisWider(gca); 
set(gcf,'Color','w');
xlabel(xVarName),ylabel(yVarName)
currTitle = [strrep(char(inputModelID),'_',' '),' ',strrep(char(tVarName),'_',' ')];
suptitle(currTitle);

% PRE intervention
fpre= figure();
hpre = subplot(1,1,1);
targetData = resultsPre.(char(tVarName));
scatter(currXData,currYData,ballsize,targetData,'filled');
colormap((parula))
colorbar
setAxisWider(gca); 
set(gcf,'Color','w');
xlabel(xVarName),ylabel(yVarName)
hold on
for i=1:numel(currXData)
    text(currXData(i),currYData(i),num2str(i),'HorizontalAlignment','center',...
        'VerticalAlignment','middle','Color','w','FontSize',8);
end
suptitle(currTitle);


% common color axis
cpost = get(hpost,'CLim');
cpre = get(hpre,'CLim');

cc(1) = min([cpost(1),cpre(1)]);
cc(2) = max([cpost(2),cpre(2)]);

set(hpost,'CLim',cc);
set(hpre,'CLim',cc);
drawnow

print(fpre,[saveResultsPath,'01-',currTitle,'-pre.png'],'-dpng','-r300');
print(fpost,[saveResultsPath,'02-',currTitle,'-post.png'],'-dpng','-r300');

if strcmp(tVarName,'TU_Num')
    
% RECIST
frec = figure();
targetData = resultsPost.(char(tVarName));
targetbaseline = resultsPre.(char(tVarName));
targetRecist = zeros(numel(targetData),1);
targetRecist(targetData>=(targetbaseline*1.2))  = 3.5; % PD
targetRecist(targetData< (targetbaseline*1.2))  = 2.5; % SD
targetRecist(targetData<=(targetbaseline*0.7))  = 1.5; % PR
targetRecist(targetData==0)                     = 0.5; % CR
scatter(currXData,currYData,ballsize,targetRecist,'filled');
setAxisWider(gca); 
set(gcf,'Color','w');
xlabel(xVarName),ylabel(yVarName),title('response analogous to RECIST');
recistCM = flipud([192 0 0;118 113 113; 0 0 192 ; 255 192 0]/255);
colormap(recistCM)
set(gca,'CLim',[0 4])
cb = colorbar;
set(cb,'Ticks',[0.5 1.5 2.5 3.5]);
set(cb,'TickLabels',recist_labels);
suptitle(strrep(inputModelID,'_',' '))
drawnow
print(frec,[saveResultsPath,'03-',currTitle,'-recist_scatter.png'],'-dpng','-r300');

end

end

% plot entire timeline
for k = 1:numel(finalSummaryPre)
    for k1 = 1:numel(summaryPre{1})
        try
        currSummPre(k,k1) = summaryPre{k}{k1}.TU_Num; % TU_Num
        catch % no tumor present
        currSummPre(k,k1) = 0;
        end
    end
    
    for k2 = 1:numel(summaryPost{1})
        try
        currSummPost(k,k2) = summaryPost{k}{k2}.TU_Num;
        catch % no tumor present
        currSummPost(k,k2) = 0;
        end
    end
end


% plot final timeline
finalTimeline = [currSummPre,currSummPost];
[cdx,idx] = sort(finalTimeline(:,end));

myColz = (parula(size(finalTimeline,1)));
ftimeline = figure();
hold on
hp = plot(summaryPre{1}{1}.stepsDone*(1:size(finalTimeline,2)),...
    finalTimeline','k','LineWidth',1.5);
plot([summaryPre{1}{end}.stepsDone,summaryPre{1}{end}.stepsDone],...
    [0,max(finalTimeline(:))],'k:','LineWidth',2);
axis square tight
set(gcf,'Color','w');

% collect timelines
AllFinalTimelines{count} = finalTimeline;

for i = 1:size(hp,1)
    set(hp(idx(i)),'Color',myColz(i,:));
end
colorbar
xlabel('time (iterations)');
ylabel('number of tumor cells');
suptitle(strrep(inputModelID,'_',' '))
print(ftimeline,[saveResultsPath,'04-',currTitle,'-timeline.png'],'-dpng','-r300');



% fstate= figure();
% hold on
% set(gcf,'Color','w');
% piedata = zeros(size(recist_labels));
% for i = fliplr(unique(ceil(targetRecist))')
%     mymask = (ceil(targetRecist)==i);
%     [hco,hce] = hist(finalTimeline(mymask,end),linspace(0,max(finalTimeline(:,end)),numBins));
%     barh(hce,hco,1,'FaceColor',recistCM(i,:),'EdgeColor','none');
%     piedata(i) = sum(mymask);
% end
% axis square
% currTitle = strrep(inputModelID,'_',' ');
% suptitle(currTitle)
% drawnow
% print(fstate,[saveResultsPath,'05-',currTitle,'-state.png'],'-dpng','-r300');

piedata = zeros(size(recist_labels));
for i = fliplr(unique(ceil(targetRecist))')
mymask = (ceil(targetRecist)==i);
piedata(i) = sum(mymask);
end

fpie = figure();
pp = pie(piedata,recist_labels);
colormap(recistCM(piedata>0,:))
axis square off
clear piedata
set(gcf,'Color','w');
suptitle(currTitle)
print(fpie,[saveResultsPath,'05-',currTitle,'-pie.png'],'-dpng','-r300');


% try
% % correlate TILs halfway after intervention with tumor size at the end
% for k = 1:numel(summaryPost)
%     s(k) = summaryPost{k}{end/3}.IM_intumor + summaryPost{k}{end/3}.IM_margin;
%     s(k) = s(k) / summaryPost{k}{end/3}.TU_Num; % normalize
%     t(k) = summaryPost{k}{end}.TU_Num;  
% end
% figure(),scatter((s),(t),'k.'),axis square tight
% set(gcf,'Color','w')
% xlabel(['normalized immune reaction at ',num2str(summaryPost{1}{end/3}.stepsDone),...
%     ' steps after intervention']);
% ylabel(['number of TU cells at ',num2str(summaryPost{1}{end}.stepsDone),...
%     ' steps after intervention']);
% title('predictive power of immune reaction')
% suptitle(strrep(inputModelID,'_',' '))
% end


clear finalTimeline; % reset

clear currSummPre currSummPost

end

draw_comparison_after_analyze_v1

