clear
close all

% Set parameters
xmin = -2.5;
xmax = 2.5;
nx = 51;

ymin = -2;
ymax = 2;
ny = 41;

del = 1.5;

% Create matrices
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
[xm, ym] = meshgrid(x, y);

[infa, infb] = refpaninf(del, xm, ym);

% For discrete approximation set up approximate result matrices
nv = 100;
aprxinfa = zeros(size(xm));
aprxinfb = zeros(size(xm));

% Loop over each discrete vortex and seperate out the gamma_a and gamma_b
% coefficients
for k = 1:nv
    xc = (k-0.5)*del/nv;
    yc = 0;
    Gamma_a = (1-(k-0.5)/nv)*del/nv;
    Gamma_b = ((k-0.5)/nv)*del/nv;
    aprxinfa = aprxinfa + psipv(xc, yc, Gamma_a, xm , ym);
    aprxinfb = aprxinfb + psipv(xc, yc, Gamma_b, xm , ym);
end


% Plotting Options
c = -0.15:0.05:0.15;

figure(1)
subplot(2,1,1)
numColors = 6;
colormap(jet(numColors))
[C,h] = contour(xm,ym,infa,c);
title('$f_{a}$' + " Countour Plot",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');
axis equal

subplot(2,1,2)
numColors = 10;
colormap(jet(numColors))
[C,h] = contour(xm,ym,aprxinfa,c);
title('$f_{a}$' + " Countour Plot Estimate",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');
axis equal
print (gcf, 'LaTeX/Week_1/graphs\e2g1', '-depsc' )

figure(2)
subplot(2,1,1)
numColors = 10;
colormap(jet(numColors))
[C,h] = contour(xm,ym,infb,c);
title('$f_{b}$' + " Countour Plot",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');
axis equal

subplot(2,1,2)
numColors = 6;
colormap(jet(numColors))
[C,h] = contour(xm,ym,aprxinfb,c);
title('$f_{b}$' + " Countour Plot Estimate",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Times', 'FontSize', 6)
set(gca,'fontname','Times');
axis equal
print (gcf, 'LaTeX/Week_1/graphs\e2g2', '-depsc' )