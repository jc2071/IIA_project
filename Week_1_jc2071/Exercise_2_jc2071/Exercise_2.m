clear
close all

N =  500;
x = linspace(-2.5,2.5,N);
y = linspace(-2,2,N);
del = 1.5;
[xg,yg] = meshgrid(x,y);

[infa, infb] = refpaninf(del, xg, yg);
 
numColors = 6;
colormap(jet(numColors))
    
c = -0.15:0.05:0.15;

% figure(1)
% 
% [C,h] = contour(xg,yg,infa,c);
% title('$f_{a}$' + " Countour Plot",'Interpreter','latex');
% xlabel("x");
% ylabel("y");
% clabel(C,h,c,'FontName','Latin Modern Math')
% set(gca,'fontname','Latin Modern Math');
% 
% figure(2)
% numColors = 10;
% colormap(jet(numColors))
% [C,h] = contour(xg,yg,infb,c);
% title('$f_{b}$' + " Countour Plot",'Interpreter','latex');
% xlabel("x");
% ylabel("y");
% clabel(C,h,c,'FontName','Latin Modern Math')
% set(gca,'fontname','Latin Modern Math');

n = 100;

ae = zeros(N);
be = zeros(N);

for i = 1:n
    xc = (i-0.5)*del/n;
    yc = 0;
    gamma_a = (1 - xc/del)*del/n;   %gets a component of circulation
    gamma_b = (xc/del)*del/n;   %gets b component of circulation
    ae =  ae + psipv(xc, yc, gamma_a, xg , yg);
    be =  be + psipv(xc, yc, gamma_b, xg , yg);
end


% figure(3);
% numColors = 6;
% colormap(jet(numColors))
% [C,h] = contour(xg,yg,ae,c);
% title('$f_{a}$' + " Countour Plot estimate",'Interpreter','latex');
% xlabel("x");
% ylabel("y");
% clabel(C,h,c,'FontName','Latin Modern Math')
% set(gca,'fontname','Latin Modern Math');
% 
% figure(4); 
% numColors = 6;
% colormap(jet(numColors))
% [C,h] = contour(xg,yg,be,c);
% title('$f_{b}$' + " Countour Plot estimate",'Interpreter','latex');
% xlabel("x");
% ylabel("y");
% clabel(C,h,c,'FontName','Latin Modern Math')
% set(gca,'fontname','Latin Modern Math');
% 

subplot(2,2,1)
numColors = 6;
colormap(jet(numColors))
[C,h] = contour(xg,yg,be,c);
title('$f_{b}$' + " Countour Plot estimate",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');

subplot(2,2,2)
numColors = 10;
colormap(jet(numColors))
[C,h] = contour(xg,yg,ae,c);
title('$f_{a}$' + " Countour Plot estimate",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');

subplot(2,2,3)
numColors = 10;
colormap(jet(numColors))
[C,h] = contour(xg,yg,infa,c);
title('$f_{a}$' + " Countour Plot",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');

subplot(2,2,4)
numColors = 6;
colormap(jet(numColors))
[C,h] = contour(xg,yg,infb,c);
title('$f_{b}$' + " Countour Plot",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');

box on
print (gcf, '/Users/MCJON/Documents/Part IIA SA1 Project/IIA_project/LaTeX/Week_1\Exercise_2_Contourplots', '-depsc' )



    





