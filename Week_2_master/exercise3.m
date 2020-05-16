clear; close all; clc;

n = 101; % Defines number of panels
x = linspace(0,1,n); % x/L
duedx = -0.25; % Edge velocity gradient

for ReL = [1e5, 1e4, 1e3] 
    disp(['Reynolds Number: ' num2str(ReL) ', duedx = ' num2str(duedx)]);
    
    ues = 1; % this is ue/U at x = 0
    ue = linspace(ues,ues + duedx,n); % this is array of velocity
    integral = zeros(size(x));
    theta = zeros(size(x));
    
    int = 0; % Location of natural transition
    ils = 0; % Location of laminar seperation 
    
    laminar = true;
    i = 1;
    
    while laminar && i < n
        i = i + 1;
         
        % Calculate momentum thickness
        integral(i) = integral(i-1) ...
            + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
        theta(i) = sqrt(integral(i)  * 0.45/ ReL /ue(i)^6);
        Rethet = ReL * ue(i) * theta(i);
        
        % Calculate Energy shape factor
        m = - ReL * theta(i)^2 * duedx;
        He = laminar_He( thwaites_lookup(m) );

        if log(Rethet) >= 18.4*He - 21.74 % Transition
            laminar = false;
            int = i;
            disp(['Natural transition at x/L: ' ...
                num2str(x(int)) ' Retheta: ' num2str(Rethet/1000)]);

        elseif m >= 0.09
            laminar = false; 
            ils = i;
            disp(['Laminar seperation at x/L: ' ...
                num2str(x(ils)) ' Retheta: ' num2str(Rethet/1000)]);

        elseif i == n
            disp('No transition or seperation occured')

        end
    end
end 
