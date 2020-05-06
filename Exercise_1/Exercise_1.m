
xc = 0.50;
yc = 0.25;
T = 3.0;
N = 1000;
x = linspace(-2.5,2.5,N);
y = linspace(-2,2,N);
[xg,yg] = meshgrid(x,y);

psi = -T*log((xg - xc).^2 + (yg - yc).^2)/(4*pi); 

c = -0.4:0.2:1.2;
[C,h] = contour(xg,yg,psi,c);

title("Point Vortex Stream Function");
xlabel("x");
ylabel("y");
set(gca,'fontname','Latin Modern Math');
clabel(C,h,c)

