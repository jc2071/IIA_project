function [int, ils, itr, its, delstar, theta] = bl_solv(x,cp, ReL)
%This is a boundary layer solver, need extra argument ReL

ue = sqrt(1-cp); % ue/U at end of the panels
n = length(x); % Defined number of panels (np +1)

int = 0; % Location of natural transition
ils = 0; % Location of laminar seperation 
itr = 0; % Location of turbulent reattachment
its = 0; % Location of turbulent seperation

% Arrays
integral = zeros(1,n);
theta = zeros(1,n);
He = zeros(1,n);
delstar = zeros(1,n); % Displacement thickness

% Initial conditions, starting at 0.01, should we use He(1) as 1.57258?
integral(1) = ueintbit(0, 0, x(1), ue(1));
theta(1) = sqrt( 0.45/ReL * integral(1)/ue(1)^6);
m = -ReL * theta(1)^2 * ue(1) / x(1);
H = thwaites_lookup(m);
%He(1) = laminar_He(H);
He(1) = 1.57258;
delstar(1) = H * theta(1);

laminar = true;
i = 1;

% Laminar section of BL
while laminar && i < n 
    i = i + 1; % start at n == 2

    % Calculate momentum and energy thickness
    integral(i) = integral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
    theta(i) = sqrt( 0.45/ReL * integral(i)/ue(i)^6 );

    Rethet = ReL * ue(i) * theta(i);
    m = -ReL * theta(i)^2 * (ue(i)-ue(i-1)) / (x(i)-x(i-1));
    H = thwaites_lookup(m);
    He(i) = laminar_He(H);
    delstar(i) = H * theta(i);

    % Check for transition or seperation
    if log(Rethet) >= 18.4*He - 21.74 % Transition
       laminar = false;
       int = i;
    elseif m >= 0.09 % Seperation
       laminar = false;
       ils = i;
       He(i) = 1.51509; % Laminar seperation value of He
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
[delx, thickhist] = ode45(...
    @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, u_grad), ...
    [0, x(i)-x(i-1)], thick0);

% Put ODE result into array
theta(i) = thickhist(end, 1);
He(i) = thickhist(end, 2)/theta(i);

% Check for turbulent reattachement if laminar seperated
if ils > 0 && itr == 0 && He(i) > 1.58
   itr = i;
end

% Check for turbulent separation
if He(i) < 1.46
   its = i; 
else
   delstar(i)=(11*He(i)+15)/(48*He(i)-59) *theta(i);
end

end

% Set remaining panels for seperated flow
if i < n
 H = 2.803;
 theta(i+1:end) = theta(i) * (ue(i) ./ ue(i+1:end)).^(H+2);
 He(i+1:end) = He(i) * ones(size(He(i+1:end))); %He const
 delstar(i)=H *theta(i);
end


