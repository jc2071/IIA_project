close all

% ReL = 1e5; % Defined externally when running the script
% output = true; % Defined externally to silence script

n = 101; % Number of panels
duedx = -0.25; % Edge velocity gradient
int = 0; % Location of natural transition
ils = 0; % Location of laminar seperation 

% Arrays
x = linspace(0, 1, n);
integral = zeros(n);
theta = zeros(n); %Thwaites solution
ue = linspace(1, 1+duedx, n);

% Loop Parameters
laminar = true;
i = 1;

if output
    disp(['ReL = ' num2str(ReL)])
end



while laminar && i < n
    i = i + 1;

    % Calculate momentum thickness
    integral(i) = integral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
    theta(i) = sqrt( 0.45/ReL * integral(i)/ue(i)^6 );

    % Check for transition or seperation
    Rethet = ReL * ue(i) * theta(i);
    m = -ReL * theta(i)^2 * (ue(i)-ue(i-1)) / (x(i)-x(i-1));
    He = laminar_He( thwaites_lookup(m) );
    if log(Rethet) >= 18.4*He - 21.74 % Transition
       laminar = false;
       int = i;
    elseif m >= 0.09 % Seperation
        laminar = false;
        ils = i;
    end
    
    if i == n && output
       disp('No transition or seperation occured') 
    end
end

if int ~= 0 && output
    disp(['Natural transition at x = ' num2str(x(int)) ...
        ' with Re_theta ' num2str(Rethet)])
end

if ils ~= 0 && output
    disp(['Seperation at x = ' num2str(x(ils))])
end

% To run

% output = true;
% for ReL = [1e3, 1e4, 1e5]
% exercise3
% end

% output = false;
% for ReL = 1e5:1e3:1e6
% exercise3
% if int > ils
% disp(['Transition starts at ReL = ', num2str(ReL)])
% break
% end
% end
