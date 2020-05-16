clear; close all; clc

np = 101; % Defines number of panels
x = linspace(0,1,np); % This is x/L
ues = 1; % This is Ue/U at x = 0
duedx = 0; % Velocity gradient
ue = linspace(ues,ues + duedx,np); % Array of Ue/U
ReL = 1000;
integral = zeros(size(x));
theta = zeros(size(x));

Blasius = (0.664/sqrt(ReL)) * sqrt(x); 

for i = 2:length(x)
     % Calculate momentum thickness
    integral(i) = integral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
    theta(i) = sqrt(integral(i)  * 0.45/ ReL /ue(i)^6);
end 

plot(x, Blasius, 'color', 'magenta');
hold on
plot(x, theta,'-', 'color', 'blue');
xlabel("x/L");
ylabel("\theta/L");
legend('Blasius','Thwaites','location', 'NorthWest')
set(gca,'fontname','Times');
print (gcf, 'LaTeX/Week_2/graphs\e1g1', '-depsc' )