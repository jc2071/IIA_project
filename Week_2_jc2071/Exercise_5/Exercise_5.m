 
clear
close all

global Re ue0 duedx

n = 101;
xspan = linspace(0,0.99,n);
ustart = 1;
Re = 1e7;
duedx = -0.50;
ue0 = 1;

x0 = 0.01;
thick0 = zeros(2,1);
thick0(1) = 0.023*x0*(Re*x0)^(-1/6);
thick0(2) = 1.83*thick0(1);
[delx, thickhist] = ode45(@thickdash, xspan, thick0);

He = thickhist(:,2)./ thickhist(:,1);   
He = He(He>1.46);
hz = length(He);

theta = thickhist(1:hz,1:1);
delta = thickhist(1:hz,2:2);

x = x0 +delx;

plot(x(1:hz),theta, 'color', 'blue');
hold on
plot(x(1:hz), delta, 'color', 'magenta');
xlabel("x/L");
ylabel("\theta/L - \delta_e /L");
legend('Kinetic energy thickness','Momentum thickness','location', 'NorthWest')
set(gca,'fontname','Times');
