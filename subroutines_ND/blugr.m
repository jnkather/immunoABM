function cmap = blugr(n)
   
    cmap = zeros(n,3);
    cmap(:,1) = linspace(0,0/255,n);
    cmap(:,2) = linspace(0,176/255,n);
    cmap(:,3) = linspace(1,240/255,n);
    
end