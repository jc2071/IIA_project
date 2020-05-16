clear; close all; clc

ReL = 1e7;
ue0 = 1;
duedx = -0.5;

% Set up initial conditions of ODE
x0 = 0.01;
thick0 = zeros(2, 1);
% Part a)
for duedx = [-0.25, -0.5, -0.95]
    thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
    thick0(2) = 1.83*thick0(1);
    [delx, thickhist] = ode45( ...
        @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
        [0, 0.99], thick0);
    x = x0 + delx;
    for i = 1:length(x)
        if thickhist(i:i,1:end)/ thickhist(i:i,2:end) < 1.46
        disp('seperation')
        break
        end 
    end    
end

% Part b)
duedx = -0.5;
for ReL = [1e6,1e7, 1e8]
        thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
    thick0(2) = 1.83*thick0(1);
    [delx, thickhist] = ode45( ... 
        @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
        [0, 0.99], thick0);
    x = x0 + delx;
end

% Solve ODE
thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
thick0(2) = 1.83*thick0(1);
[delx, thickhist] = ode45( ...
    @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
    [0, 0.99], thick0);
x = x0 + delx;

figure(7);
hold on
plot(x, thickhist(:,1), 'b');
plot(x, thickhist(:,2), 'r');
hold off
xlabel('x/L')
ylabel('Nondimensional boundary layer thickness')
legend('\theta/L', '\delta e/L')