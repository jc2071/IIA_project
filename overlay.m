close; clear all

number = input('Enter number of overlay: ','s');
Re = input('Enter Reynolds number: ','s');
alpha = input('Enter AOA (degree): ','s');
n = str2num(number);
np = 100;
nphr = 5*np;
xmax = 1.0;
xmin = 0.0;
ymax =  0.2;
ymin = -0.2;
colors = [[0.6350 0.0780 0.1840];[0 0.447 0.741];[0.929 0.6940 0.125]];
h = figure('Visible', 'off', 'Name', ['Re- ' Re ' Angle of attack- ' alpha]);
disp('------------------------')
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
    axis([xmin xmax ymin ymax])
    subplot(3,1,1)
    title('Airfoil geometry') 
    hold on
    plot(xs,ys, 'color',colors(i,:),'DisplayName',geometry,'LineWidth', 1.2)
    legend
    hold off
    subplot(3,1,2)
    title('Pressure distrubution') 
    hold on
    load(['Data/' geometry '/' Re '_' alpha '.mat'],'cp' , 'xs');
    xlim([xmin xmax]); axis 'auto y'
    plot(xs,-cp,'color',colors(i,:),'DisplayName',geometry,'LineWidth', 1.2)
    legend
    hold off
    subplot(3,1,3)
    title('Pressure gradients') 
    hold on
    load(['Data/' geometry '/' Re '_' alpha '.mat'],'cp' , 'xs');
    xlim([xmin xmax]); axis 'auto y';
    [xgrads, cpgrads] = cp_gradjc(xs,cp,np);
    plot(xgrads, cpgrads,'color',colors(i,:),'DisplayName',geometry,'LineWidth', 1.2);
    legend;
    hold off
end

set(h, 'Visible', get(0,'DefaultFigureVisible'))
