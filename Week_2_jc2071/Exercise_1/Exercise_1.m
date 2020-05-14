
clear
close all

np = 101;
x = linspace(0,1,np); % this is (x/L)
ustart = 1; % this is Ue/U at x = 0
ugrad = 0; % this is velocity gradient
ue = linspace(ustart,ustart + ustart*ugrad,np); 
Rel = 1000;
intergral = zeros(size(x));
theta = zeros(size(x));

Blassius = (0.664/sqrt(Rel)) * sqrt(x); 

for i = 2:length(x) %gets np -1 points
    intergral(i) = intergral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
    theta(i) = sqrt(intergral(i)  * 0.45/ Rel /ue(i)^6);
end 

plot(x, Blassius, 'color', 'magenta');
hold on
plot(x, theta,'-', 'color', 'blue');
xlabel("x/L");
ylabel("\theta/L");
legend('Blassius','Thwaites','location', 'NorthWest')
set(gca,'fontname','Times');

