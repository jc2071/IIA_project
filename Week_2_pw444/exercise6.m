clear
close all

n = 101; % Number of points
ReL = 1e5;
duedx = -0.25;

int = 0; % Location of natural transition
ils = 0; % Location of laminar seperation 
itr = 0; % Location of turbulent reattachment
its = 0; % Location of turbulent seperation

% Arrays
x = linspace(0, 1, n);
sz = size(x);
integral = zeros(sz);
theta = zeros(sz); %Thwaites solution
He = zeros(sz);
ue = linspace(1, 1+duedx, n);

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
    He(i) = laminar_He( thwaites_lookup(m) );
    
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
    ue_grad = (ue(i)-ue(i-1))/(x(i)-x(i-1)); % ue grad. of panel
    ue0 = ue(i);
    
    % Perform ODE calculation using anonymous function
    [delx, thickhist] = ode45(...
        @(xmx0, thick)thickdash(xmx0, thick, ReL, ue0, ue_grad), ...
        [0, x(i)-x(i-1)], thick0);
    
    % Put ODE result into array
    theta(i) = thickhist(end, 1);
    He(i) = thickhist(end, 2)/theta(i);
    
    % Check for turbulent reattachement if laminar seperated
    if ils > 0 && itr == 0 && He(i) > 1.58
       itr = i;
    end
    
    % Check for turbulent seperation
    if He(i) < 1.46
       its = i; 
    end
end

% Set remaining panels for seperated flow
if i < n
     H = 2.803;
     theta(i+1:end) = (ue(i)./ue(i+1:end)).^(H+2);
     He(i+1:end) = He(i)*ones(size(He(i+1:end))); % not sure about this
end

% Display how boundary layer evolved
disp(['For ReL = ' num2str(ReL) ' and duedx = ' num2str(duedx)])
if int == 0 && ils == 0
    disp('Flow remained laminar')
end
if int > 0
    disp(['Natural Transition at x = ' num2str(x(int))])
end
if ils > 0
    disp(['Laminar seperation at x = ' num2str(x(ils))])
end
if itr > 0
   disp(['Turbulent reattachment at x = ' num2str(x(itr))])
end
if its > 0
   disp(['Turbulent seperation at x = ' num2str(x(its))]) 
end

figure(1)
plot(x, theta)
xlabel('x')
ylabel('\theta')

figure(2)
plot(x, He)
xlabel('x')
ylabel('He')
