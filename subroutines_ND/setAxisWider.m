function setAxisWider(axhand)

axis(axhand,'square','tight');

myXLim = get(axhand,'XLim');
myYLim = get(axhand,'YLim');

offsetX = myXLim(2)*0.05;
offsetY = myYLim(2)*0.05;

set(axhand,'XLim',[myXLim(1)-offsetX,myXLim(2)+offsetX]);
set(axhand,'YLim',[myYLim(1)-offsetY,myYLim(2)+offsetY]);
end