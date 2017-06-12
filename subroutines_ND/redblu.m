function cmap = redblu(n)
    
    cmap = zeros(n,3);
    cmap(:,1) = linspace(0,1,n);
    cmap(:,3) = linspace(1,0,n);
    
end