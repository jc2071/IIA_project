function  fancyplot( xm, ym, height, c, title1, xlabel1, ylabel1 )

[C,h] = contour( xm, ym, height, c );
title(title1,'Interpreter','latex');
xlabel(xlabel1);
ylabel(ylabel1);
clabel(C,h,c,'FontName','Times', 'FontSize',8)
set(gca,'fontname','Times', 'FontSize',12);
axis equal

end

