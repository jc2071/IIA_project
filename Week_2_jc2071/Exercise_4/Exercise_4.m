 
clear
close all

global Re ue0 duedx

n = 101;
xspan = linspace(0,0.99,n);
ustart = 1;
Re = 1e7;
duedx = -0.25;
ue0 = 1.5;

x0 = 0.01;
thick0 = zeros(2,1);
thick0(1) = 0.023*x0*(Re*x0)^(-1/6);
thick0(2) = 1.83*thick0(1);
[delx, thickhist] = ode45(@thickdash, xspan, thick0);

x = x0 +delx;

theta7 = 0.037.*x.*(Re*x).^(-1/5);
theta9 = 0.023.*x.*(Re*x).^(-1/6);

plot(x, thickhist(:,1))
hold on
plot(x,theta7);
hold on
plot(x,theta9);
xlabel("x/L");
ylabel("\theta/L");
legend('Numerical Solution','1/7 power law','1/9 power law','location', 'NorthWest')
set(gca,'fontname','Times');
