% dirty script :( run it after "analyze_parameter_grid"

% plot collected timelines
targetElements = 24;

% zero-pad timelines
for i=1:numel(AllFinalTimelines)
    currlength = size(AllFinalTimelines{i},2)
    if currlength<targetElements
        addMe = zeros(size(AllFinalTimelines{i},1),...
            targetElements-currlength);
        AllFinalTimelines{i} = [AllFinalTimelines{i},addMe];
    end
end

for j=1:numel(inputcontainer)
    inputcontainer{j} = strrep(inputcontainer{j},'_',' ');
end

% crop timelines to targetElements
for i = 1:numel(AllFinalTimelines)
    currTimeline = AllFinalTimelines{i};
    
    if size(currTimeline,2)>targetElements
        currTimeline = currTimeline(:,1:targetElements);
    end
    
    AllFinalTimelinesEdited{i} = currTimeline; 
end

xes = summaryPre{1}{1}.stepsDone*((1:size(AllFinalTimelines{1},2)));
xes = xes/2;
xes = [0,xes(1:targetElements)];
%xes = [0,xes];
tint = summaryPre{1}{end}.stepsDone/2;
allColz = lines(numel(AllFinalTimelines));
figure(),hold on
for i = 1:numel(AllFinalTimelines) % pre-plot for legend
    mymean = [0, mean(AllFinalTimelinesEdited{i})];
    mystd = [0, std(AllFinalTimelinesEdited{i})];
    plot(xes,mymean,'LineWidth',3,'Color',allColz(i,:));
end

warning('replacing legend entries')
overrideInputContainer = ({'Stro low, Lym high','Stro high, Lym low','Stro low, Lym low','Stro high, Lym high'})
lgd = legend(overrideInputContainer,'Location','NorthWest','AutoUpdate','off');

for i = 1:numel(AllFinalTimelines)
    mymean = [0, mean(AllFinalTimelinesEdited{i})];
    mymean(isinf(mymean)) = 0;
    mystd = [0, std(AllFinalTimelinesEdited{i})];
    mystd(isinf(mystd)) = 0;
    plot(xes,mymean,'LineWidth',3,'Color',allColz(i,:));
    patch([xes,fliplr(xes)],[mymean-mystd,fliplr(mymean+mystd)],allColz(i,:),'EdgeColor','none','FaceAlpha',0.5);
end

mysq = @(varargin) varargin;
plot([tint,tint],...
    [0,max(max(cell2mat(mysq(AllFinalTimelinesEdited{:}))))],'k:','LineWidth',2);


set(gcf,'Color','w')
xlabel('time (days)'); ylabel('tumor load (# tumor cells)'); 

axis tight
xx = axis;
xx(1) = 0; xx(3) = 0;
axis(xx)

drawnow
print(gcf,[saveResultsPath,'00-',currTitle,'-TIMELINE.png'],'-dpng','-r450');
