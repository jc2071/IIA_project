clear; close all; clc;

n = 101;                          % Defines number of panels
x = linspace(0,1,n);              % This is x/L
ues = 1;                          % This is ue/U at x = 0
duedx = 0;                        % Velocity gradient
ue = linspace(ues,ues + duedx,n); % Array of ue/U
ReL = 1e3;
integral = zeros(size(x));
theta = zeros(size(x));

Blasius = (0.664/sqrt(ReL)) * sqrt(x); 

for i = 2:length(x)
     % Calculate momentum thickness theta
    integral(i) = integral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
    theta(i) = sqrt(integral(i)  * 0.45/ ReL /ue(i)^6);
end 

% Plot results
hold on
plot(x, Blasius, 'color', [0.6350 0.0780 0.1840],'LineWidth', 1.2);
plot(x, theta, 'color', [0 0.4470 0.7410],'LineWidth', 1.2);
hold off
xlabel("x/L");
ylabel("\theta/L");
legend('Blasius','Thwaites','location', 'NorthWest')
set(gca,'fontname','Times','FontSize',14);
print (gcf, 'LaTeX/Week_2/graphs\e1g1', '-depsc' )