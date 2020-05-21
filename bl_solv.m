function [int, ils, itr, its, delstar, theta, He] = bl_solv (x, cp, ReL)
%
% function [int, ils, itr, ils, delstar, theta] = bl_solve (x, cp)
%
% bl_solve takes 2 vectors x and cp and ReL! x is distance from leading stagnation
% point. The x(1) is not the stagnation point but the next one along.
% cp is the pressure coeficcint at each of these point and allows to find
% ue

int = 0; % Location of natural transition
ils = 0; % Location of laminar separation
itr = 0; % Location of turbulent reattachment
its = 0; % Location of turbulent separation

% Set up arrays
n = length(x); % Number of points, one more than panels

integral = zeros(1, n);
theta = zeros(1, n);
delstar = zeros(1, n);
He = zeros(1, n);
ue = sqrt(1-cp);

% Loop variables
laminar = true;
i = 1;

% Manually calculate first panel as BL starts at x(0)
% Calculate displacement, momentum and energy thickness
integral(1) = ueintbit(0, 0, x(1), ue(1));
theta(1) = sqrt( 0.45/ReL * integral(1)/ue(1)^6 );

Rethet = ReL * ue(1) * theta(1);
m = -ReL * theta(1)^2 * ue(1)/x(1);
H = thwaites_lookup(m);
He(1) = laminar_He(H);
delstar(1) = H * theta(1);

% Check for immediate transition or separation
if log(Rethet) >= 18.4 * He(1) - 21.74 % Transition
   laminar = false;
   int = 1;
elseif m >= 0.09 % separation
   laminar = false;
   ils = 1;
   He(1) = 1.51509; % Laminar separation value of He
end

while laminar && i < n
    i = i + 1; % start at i == 2

    % Calculate displacement, momentum and energy thickness
    integral(i) = integral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
    theta(i) = sqrt( 0.45/ReL * integral(i)/ue(i)^6 );

    Rethet = ReL * ue(i) * theta(i);
    m = -ReL * theta(i)^2 * (ue(i)-ue(i-1)) / (x(i)-x(i-1));
    H = thwaites_lookup(m);
    He(i) = laminar_He(H);
    
    delstar(i) = H * theta(i);

    % Check for transition or separation
    if log(Rethet) >= 18.4*He(i) - 21.74 % Transition
       laminar = false;
       int = i;
    elseif m >= 0.09 % separation
       laminar = false;
       ils = i;
       He(i) = 1.51509; % Laminar separation value of He
    end
end

% Turbulent section of BL
while its == 0 && i < n
    i = i + 1;

    % Calculate ODE initial conditions & parameters
    thick0 = [theta(i-1); He(i-1)*theta(i-1)]; % [theta;de]
    u_grad = (ue(i)-ue(i-1))/(x(i)-x(i-1)); % ue grad. of panel
    ue0 = ue(i-1);

    % Perform ODE calculation using anonymous function
    [~, thickhist] = ode45(...
        @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, u_grad), ...
        [0, x(i)-x(i-1)], thick0);
    
    % Put ODE result into arrays
    theta(i) = thickhist(end, 1);
    He(i) = thickhist(end, 2)/theta(i);
    H = (11 * He(i) + 15)/( 48 * He(i) - 59);

    % Check for turbulent reattachement if laminar seperated
    if ils > 0 && itr == 0 && He(i) > 1.58
       itr = i;
    end

    % Check for turbulent separation
    if He(i) < 1.46
       H = 2.803;
       its = i;
    end
    
    delstar(i) = H * theta(i); % Calculate after checking for separation
    
end

% Set remaining panels for seperated flow
if i < n
     H = 2.803;
     theta(i+1:end) = theta(i) * (ue(i) ./ ue(i+1:end)).^(H+2);
     delstar(i+1:end) = H * theta(i+1:end);
end