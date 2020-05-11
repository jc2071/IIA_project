function fancyplotsubplot(x1m,y1m,height1,c1,title1, x1label, y1label, ...
                          x2m, y2m, height2, c2, title2, x2label, y2label)
                          
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure(1)
subplot(2,1,1)
numColors = 6;
colormap(jet(numColors))
[C,h] = contour(x1m,y1m,height1,c1);
title(title1,'Interpreter','latex');
xlabel(x1label);
ylabel(y1label);
clabel(C,h,c1,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');
axis equal

subplot(2,1,2)
numColors = 6;
colormap(jet(numColors))
[C,h] = contour(x2m,y2m,height2,c2);
title(title2,'Interpreter','latex');
xlabel(x2label);
ylabel(y2label);
clabel(C,h,c2,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');
axis equal



end

