clear
close all

ReL = 1e7;
ue0 = 1;
duedx = 0;

% Set up initial conditions of ODE
x0 = 0.01;
thick0 = zeros(2, 1);
thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
thick0(2) = 1.83*thick0(1);

% Solve ODE - pass in extra parameters through an anonymous function
[delx, thickhist] = ode45(@(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), [0, 0.99], thick0);
x = x0 + delx;

% Generate 7th and 9th power law solutions
th7 = 0.037 * x .* (ReL*x).^(-1/5);
th9 = 0.023 * x .* (ReL*x).^(-1/6);

hold on
plot(x,thickhist(:,1), 'b')
plot(x, th7, 'r')
plot(x, th9, 'g')
hold off
xlabel('Distance along wall: x/L');
ylabel('Momentum thickness \theta / L' );
legend('ODE Solution', '7th Power law', '9th power law');