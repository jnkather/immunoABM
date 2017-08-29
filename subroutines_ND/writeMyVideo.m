function writeMyVideo(allImages,finalPath,repeatFrames)

v = VideoWriter(finalPath,'MPEG-4');
open(v)

% write all frames to video
for i=1:numel(allImages) % iterate all images
    for j=1:repeatFrames % repeat the frame N times
    writeVideo(v,allImages{i});
    end
end
    
close(v)

end