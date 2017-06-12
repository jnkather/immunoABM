function seedmap = expandSeedMap(seedmap,smoothSE,frac)

    sngh = smoothSE.Neighborhood;
    sngh(rand(size(sngh))>frac) = 0;
    sngh = imclose(sngh,ones(5)); % fill holes in mask
    seedmap = imdilate(seedmap,sngh);
    
end