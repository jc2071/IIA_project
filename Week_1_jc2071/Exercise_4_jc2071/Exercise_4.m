clear
close all

r = 1;
N = 100;
theta = (0:N)*2*pi/N;

xs = r*cos(theta); % surface of cyclinder x
ys = r*sin(theta); % surface of cyclinder y 

x = linspace(-2.5,2.5,N);
y = linspace(-2,2,N);

[xm, ym] = meshgrid(x,y);

gamma = -2*sin(theta); %vortex sheet at pannel edge streamline corrosponding to unit free stream velocity

psi = ym; % free stream contribution (look in data book)!

for i = 1:N 
[infa, infb] = panelinf(xs(i), ys(i), xs(i+1), ys(i+1), xm, ym); % a little polar coordinate element
psi = psi + gamma(i)*infa + gamma(i+1)*infb;
end

c = -1.75:0.25:1.75;

[C,h] = contour(xm,ym,psi,c);
hold on
plot(xs, ys)
title("Countour Plot Of Cylinder In Free Stream",'Interpreter','latex');
xlabel("x");
ylabel("y");
axis normal
clabel(C,h,c,'FontName','Latin Modern Math')
set(gca,'fontname','Latin Modern Math');

