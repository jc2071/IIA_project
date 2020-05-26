clear; close all; clc

number = input('Enter number of overlay: ','s');
n = str2num(number);
np = 100;
nphr = 5*np;
xmax = 1.0;
xmin = 0.0;
ymax =  6;
ymin = -2;
colors = [[0.6350 0.0780 0.1840];[0 0.447 0.741];[0.929 0.6940 0.125]];
h = figure('Visible', 'off');
for i = 1:n
    set(0, 'CurrentFigure', h)
    geometry = input(['Enter Geometry file ' num2str(i) ,'/', num2str(n)  ': ' ],'s');
    secfile = ['Geometry/' geometry '.surf'];
    [xk, yk] = textread ( secfile, '%f%f' );
    [xshr yshr] = splinefit ( xk, yk, nphr );
    %  Resize section so that it lies between (0,0) and (1,0)
    [xsin ysin] = resyze ( xshr, yshr );
    %  Interpolate to required number of panels (uniform size)
    [xs ys] = make_upanels ( xsin, ysin, np );
    hold on
    axis([xmin xmax ymin ymax])
    plot(xs,ys, 'color',colors(i,:),'DisplayName',geometry,'LineWidth', 1.2)
end

hold on
load('Data/naca0012/3e6_10.mat', 'cp', 'xs');
plot(xs,-cp, 'm')
hold off

disp('Plotting...')
legend
set(h, 'Visible', get(0,'DefaultFigureVisible'))