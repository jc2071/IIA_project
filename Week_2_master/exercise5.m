clear; close all; clc

ReL = 1e7;
ue0 = 1;

% Set up initial conditions of ODE
x0 = 0.01;
thick0 = zeros(2, 1);
% Part a)
disp(['For ReL = ' num2str(ReL)]);
for duedx = [-0.25, -0.5, -0.95]
    thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
    thick0(2) = 1.83*thick0(1);
    [delx, thickhist] = ode45( ...
        @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
        [0, 0.99], thick0);
    x = x0 + delx;
    for i = 1:length(x)
        if thickhist(i:i,2:2)/ thickhist(i:i,1:1) < 1.46
        disp(['For duedx = ' num2str(duedx)...
            ' seperation occurs at x/L = ' num2str(x(i))])
        break
        
        elseif i == length(x)
            disp(['For duedx = ' num2str(duedx)...
            ' No seperation'])
        end 
    end    
end

% Part b)
thick0 = zeros(2,1);
duedx = -0.5;
disp(['For duedx = ' num2str(duedx)]);
for ReL = [1e6,1e7, 1e8]
    thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
    thick0(2) = 1.83*thick0(1);
    [delx, thickhist] = ode45( ... 
        @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
        [0, 0.99], thick0);
    x = x0 + delx;
    for i = 1:length(x)
        if thickhist(i:i,2:2)/ thickhist(i:i,1:1) < 1.46
        disp(['For ReL = ' num2str(ReL)...
            ' seperation occurs at x/L = ' num2str(x(i))])
        break
        
        elseif i == length(x)
            disp(['For ReL = ' num2str(ReL)...
            ' No seperation'])
        end 
    end    
end

% Solve ODE
thick0(1) = 0.023*x0*(ReL*x0)^(-1/6);
thick0(2) = 1.83*thick0(1);
[delx, thickhist] = ode45( ...
    @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
    [0, 0.99], thick0);
x = x0 + delx;

figure(1);
hold on
plot(x, thickhist(:,1), 'g','LineWidth',1.2);
plot(x, thickhist(:,2), 'm','LineWidth',1.2);
hold off
xlabel('x/L')
ylabel('Nondimensional boundary layer thickness')
legend('\theta/L', '\delta_e/L')
set(gca,'fontname','Times');
print (gcf, 'LaTeX/Week_2/graphs\e5g1', '-depsc' )