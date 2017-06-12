% JN Kather 2017

function visualize_balls_2D_blank(mySystem)

    % create tumor cell colors and immune cell colors
    TUcolors = double(hot(3*double(mySystem.params.TUpmax))); %colormap for tumor cells
    IMcolors = flipud(double(blugr(double(mySystem.params.IMkmax)+3))); % color map for immune cells
       
    % prepare figure background
    chtaxImage = double(mySystem.grid.ChtaxMap);
    chtaxImage = 1-(chtaxImage / max(chtaxImage(:)));    
    hypoxImage = double(mySystem.grid.HypoxMap);
    maxDistance = sqrt((mySystem.grid.N/2)^2+(mySystem.grid.M/2)^2); % max. possible distance
    hypoxImage = hypoxImage / maxDistance;
    
    % prepare background image
    backgroundImage = 1+0 * repmat(double(chtaxImage),1,1,3);
    ch1 = backgroundImage(:,:,1);
    ch2 = backgroundImage(:,:,2);
    ch3 = backgroundImage(:,:,3);
    
    % add fibrosis to background image
    ch1(mySystem.grid.Lf) = 246/255;
    ch2(mySystem.grid.Lf) = 250/255;
    ch3(mySystem.grid.Lf) = 5/255;
    
    % add necrosis to background image
    ch1(mySystem.grid.Ln) = 0;
    ch2(mySystem.grid.Ln) = 0;
    ch3(mySystem.grid.Ln) = 0;
    
    % add 2 mm scale bar to background image
    beginSc = 10;
    width = 3; 
    len = 134; % 2 mm length
    ch1((end-beginSc-width):(end-beginSc),beginSc:(beginSc+len)) = 0;
    ch2((end-beginSc-width):(end-beginSc),beginSc:(beginSc+len)) = 0;
    ch3((end-beginSc-width):(end-beginSc),beginSc:(beginSc+len)) = 0;
    
    % collect background image channels
    backgroundImage(:,:,1) = ch1;
    backgroundImage(:,:,2) = ch2;
    backgroundImage(:,:,3) = ch3;
                                     
    imshow(backgroundImage); % show background
    hold on % prepare to plot on top
   
    % prepare decorations
    myPos = get(0,'Screensize');
    myPos(1) = myPos(1) + myPos(3)*(1/10);
    myPos(2) = myPos(2) + myPos(4)*(1/10);
    myPos(3) = myPos(3)*(8/10);
    myPos(4) = myPos(4)*(8/10);
    set(gcf, 'Position', myPos);  % enlarge figure
    
    
    % create tumor cell coordinates
    ytu = mod(mySystem.TU.TUcells,mySystem.grid.N);
    xtu = mySystem.TU.TUcells/(mySystem.grid.N-1);   
    % retrieve tumor cell colors
    myTuc = TUcolors(mySystem.TU.TUprop.Pcap+5,:);
    % plot tumor cells
    scatter(xtu,ytu,mySystem.params.mycellsize,myTuc,'filled')
       
    try % try to draw immune cells, skip if this is impossible
    % create immune cell coordinates
    yim = mod(mySystem.IM.IMcells,mySystem.grid.N);
    xim = ceil(mySystem.IM.IMcells/mySystem.grid.N);
    % retrieve immune cell colors
    myImc = IMcolors(mySystem.IM.IMprop.Kcap+1,:);
    % plot immune cells
    scatter(xim,yim,mySystem.params.mycellsize,myImc,'filled')
    catch
        disp('no immune cells could be plotted');
    end
    
    % show full domain and add decorations
    set(gca,'XLim',[0 mySystem.grid.M]);
    set(gca,'YLim',[0 mySystem.grid.N]);
    axis equal off
    set(gcf,'Color','w');
    
    % add time counter to image
    text(beginSc,beginSc/2,[num2str(mySystem.grid.StepsDone/2),' days'],...
        'Color','k','FontWeight','bold','FontSize',18,'VerticalAlignment','top')
    
    hold off
    
end