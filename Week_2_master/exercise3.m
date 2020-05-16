clear; close all; clc

n = 101; % Defines number of panels
x = linspace(0,1,n); % This is x/L
duedx = -0.25; % Edge velocity gradient

for Rel = [1e5, 1e4, 1e3] 
    disp(['Reynolds Number: ' num2str(Rel) ', duedx = ' num2str(duedx)]);
    ues = 1; % this is Ue/U at x = 0
    ue = linspace(ues,ues + duedx,n); % this is array of velocity
    intergral = zeros(size(x));
    theta = zeros(size(x));
    
    int = 0; % Location of natural transition
    ils = 0; % Location of laminar seperation 
    
    laminar = true;
    i = 1;
    while laminar && i < n
        i = i +1;
         % Calculate momentum thickness
        intergral(i) = intergral(i-1) + ueintbit(x(i-1), ue(i-1), x(i),...
                                                                  ue(i));
        theta(i) = sqrt(intergral(i)  * 0.45/ Rel /ue(i)^6);
        m = - Rel* theta(i)^2 * duedx;
        H = thwaites_lookup(m);
        He = laminar_He(H);
        Rethet = Rel * ue(i) * theta(i);

        if log(Rethet) >= 18.4*He - 21.74
            laminar = false;
            int = i;
            disp(['natural transition at x/L: ' ...
                num2str(x(int)) ' Retheta: ' num2str(Rethet/1000)]);

        elseif m >= 0.09
            laminar = false; 
            ils = i;
            disp(['laminar seperation at x/L: ' ...
                num2str(x(ils)) ' Retheta: ' num2str(Rethet/1000)]);

        elseif i == n
            disp('No transition or seperation occured')

        end
    end
end 
