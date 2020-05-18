clear; close all; clc;

n = 101; % Defines number of panels

for ReL = [5e6, 10e6, 20e6]
    disp(['---------------------', fprintf('\n')])
    disp(['ReL: ', num2str(ReL)])
    
    for duedx = [-0.1, 0, 0.1]
        ue = linspace(1, 1+duedx, n);
        disp(['Velocity gradient = ', num2str(duedx)])
        % Reset arrays
        x = linspace(0, 1, n);
        integral = zeros(1,n);
        theta = zeros(1,n);
      
        % Loop parameters
        laminar = true;
        i = 1;

        while laminar && i < n
            i = i + 1;

            % Calculate momentum thickness
            integral(i) = integral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
            theta(i) = sqrt( 0.45/ReL * integral(i)/ue(i)^6 );

            % Check for natural transition
            Rethet = ReL * ue(i) * theta(i);
            m = -ReL * theta(i)^2 * (ue(i)-ue(i-1)) / (x(i)-x(i-1));
            He = laminar_He( thwaites_lookup(m) );
            if log(Rethet) >= 18.4*He - 21.74
               laminar = false; % Stop loop if natural transition
               disp([num2str(x(i)),'   :   ',num2str(Rethet)])
            end
            if i == n
               disp('No transition occured') 
            end
        end
    end
end