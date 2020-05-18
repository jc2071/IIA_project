clear; close all; clc

% Loop over 5 different required cases
for duedx = [-0.25, -0.5, -0.95]
    ReLArr = 1e7;
    if duedx == -0.5
       ReLArr = [1e6, 1e7, 1e8];
    end
    
    for ReL = ReLArr
        % Set up initial conditions of ODE
        ue0 = 1;
        x0 = 0.01;
        thick0 = zeros(2, 1);
        thick0(1) = 0.023 * x0 * (ReL*x0)^(-1/6);
        thick0(2) = 1.83 * thick0(1);

        % Solve ODE
        [delx, thickhist] = ode45( ...
            @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
            [0, 0.99], thick0);
        x = x0 + delx;
        He = thickhist(:,2)./thickhist(:,1);
        
        % Determine seperation value
        xsep = 1; % x value when seperation has occured
        for i = 1:length(x)
            if He(i) < 1.46
                % Linearly interpolate to find correct x value
                xsep = x(i-1) + (1.46-He(i-1))*(x(i)-x(i-1))/(He(i)-He(i-1)); 
                break;
            end
        end
        
        % Plot graph of seperation
        figure('Name', ['du/dx = ', num2str(duedx),...
            ' and Re_L = 1e', num2str(log10(ReL))])
        hold on
        plot(x, He, 'b') % He
        plot(x, 1.46 + zeros(size(x)), 'r') % 1.46 crossing
        plot(xsep, 1.46, 'ko') % x point of seperation
        hold off
        xlabel('x/L')
        ylabel('He')
        title(['du/dx = ', num2str(duedx),' and Re_L = 1e',...
            num2str(log10(ReL)), '. Seperation at x/L = ', num2str(xsep)])
    end
end

% Generate plot of theta and de
duedx = -0.5;
ReL = 1e7;
thick0(1) = 0.023 * x0 * (ReL*x0)^(-1/6);
thick0(2) = 1.83 * thick0(1);

[delx, thickhist] = ode45(...
    @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, duedx), ...
    [0, 0.99], thick0);
x = x0 + delx;

figure(6);
hold on
plot(x, thickhist(:,1), 'color',[0.6350 0.0780 0.1840],'LineWidth',1.2);
plot(x, thickhist(:,2), 'color',[0 0.4470 0.7410] ,'LineWidth',1.2);
hold off
xlabel('x/L')
ylabel('Boundary layer thickness')
legend('\theta/L', '\delta_e/L','Location','NorthWest')
set(gca,'FontName','Times','FontSize',16);
print (gcf, 'LaTeX/Week_2/graphs\e5g1', '-depsc' )