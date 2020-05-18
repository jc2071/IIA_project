clear; close all; clc;

n = 101; % Number of points
colors = [[0.6350 0.0780 0.1840];[0 0.447 0.741];[0.929 0.6940 0.125]]; 
figure_num = 1;
fig = 1;
for duedx = [0, -0.25]
    fig = fig +2;
    c = 1;
    
    ReLarray = [1e6, 1e7];
    if duedx == -0.25
        ReLarray = [1e4, 1e5, 1e6];
    end
    
    for ReL = ReLarray
        int = 0; % Location of natural transition
        ils = 0; % Location of laminar seperation 
        itr = 0; % Location of turbulent reattachment
        its = 0; % Location of turbulent seperation

        % Arrays
        x = linspace(0, 1, n);
        sz = size(x);
        
        integral = zeros(sz);
        theta = zeros(sz);
        He = zeros(sz);
        He(1) = 1.57258;
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

            % Check for turbulent seperation
            if He(i) < 1.46
               its = i; 
            end
        end

        % Set remaining panels for seperated flow
        if i < n
             H = 2.803;
             theta(i+1:end) = theta(i)*(ue(i)./ue(i+1:end)).^(H+2);
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

        figure(fig-2)
        hold on
        plot(x, theta, 'DisplayName', ...
            ['Re = ' num2str(ReL, '%.1e')], 'Color', colors(c,:),...
            'LineWidth', 1.2)
        figure(fig-1)
        hold on
        plot(x, He, 'DisplayName', ...
            ['Re = ' num2str(ReL, '%.1e')], 'Color', colors(c,:),...
            'LineWidth', 1.2)
        c = c+1;
        figure_num = figure_num +1;
    end
end

figure(1)
xlabel("x/L");
ylabel("\theta/L");
legend('show', 'location','NorthWest')
set(gca,'FontName','Times','FontSize',16);
print (gcf, 'LaTeX/Week_2/graphs\e6g1', '-depsc' )

figure(2)
xlabel("x/L");
ylabel("He");
legend('show', 'location','NorthWest')
set(gca,'FontName','Times','FontSize',16);
print (gcf, 'LaTeX/Week_2/graphs\e6g2', '-depsc' )

figure(3)
xlabel("x/L");
ylabel("\theta/L");
legend('show', 'location','NorthWest')
set(gca,'FontName','Times','FontSize',16);
print (gcf, 'LaTeX/Week_2/graphs\e6g3', '-depsc' )

figure(4)
xlabel("x/L");
ylabel("He");
legend('show', 'location','NorthWest')
set(gca,'FontName','Times','FontSize',16);
print (gcf, 'LaTeX/Week_2/graphs\e6g4', '-depsc' )
