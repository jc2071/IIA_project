n = 6
x = linspace(0,1,100);
y = x.^2;
xmax = 1.0;
xmin = 0.0;
ymax =  .2;
ymin = -.2;

for i = 1:n
    figure(i)
    plot(x,i*y)
    axis equal
    axis([xmin xmax ymin ymax])
end

autoArrangeFigures(3, 2, 1);

