clear
close all

%https://uk.mathworks.com/matlabcentral/answers/274406-ode45-extra-parameters

ReL = 1e7;
ue0 = 1;

% Set up initial conditions of ODE
x0 = 0.01;
thick0 = zeros(2, 1);

% a)
for duedx = [-0.25, -0.5, -0.95]
    thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
    thick0(2) = 1.83*thick0(1);
    [delx, thickhist] = ode45( ...
        @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
        [0, 0.99], thick0);
    x = x0 + delx;
    
    figure(-20*duedx)
    hold on
    plot(x, thickhist(:,2)./thickhist(:,1), 'b')
    plot(x, 1.46+zeros(size(x)), 'r')
    hold off
    xlabel('x/L');
    ylabel('He');
end

% b)
duedx = -0.5;
for ReL = [1e6, 1e8]
    thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
    thick0(2) = 1.83*thick0(1);
    [delx, thickhist] = ode45( ... 
        @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
        [0, 0.99], thick0);
    x = x0 + delx;
    figure(ReL)
    hold on
    plot(x, thickhist(:,2)./thickhist(:,1), 'b')
    plot(x, 1.46+zeros(size(x)), 'r')
    hold off
    xlabel('x/L');
    ylabel('He');
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