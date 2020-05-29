clear; close all; clc;

% color scheme for graphs
colors = [[0.6350 0.0780 0.1840];[0 0.447 0.741];[0.929 0.6940 0.125]];

n = 101; % Number of points

for duedx = [0, -0.25]
    c = 1; % Color of line on graph

    % Decide ReL values to loop over
    ReLarray = [1e6, 1e7];
    if duedx == -0.25
        ReLarray = [1e4, 1e5, 1e6];
    end

    for ReL = ReLarray
        int = 0; % Location of natural transition
        ils = 0; % Location of laminar separation
        itr = 0; % Location of turbulent reattachment
        its = 0; % Location of turbulent separation

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
            end
        end

        % Set remaining panels for seperated flow
        if i < n
             H = 2.803;
             theta(i+1:end) = theta(i) * (ue(i) ./ ue(i+1:end)).^(H+2);
             He(i+1:end) = He(i) * ones(size(He(i+1:end))); % He const.
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
            disp(['Laminar separation at x = ' num2str(x(ils))])
        end
        if itr > 0
           disp(['Turbulent reattachment at x = ' num2str(x(itr))])
        end
        if its > 0
           disp(['Turbulent separation at x = ' num2str(x(its))])
        end

        % Plot figures (a & b) or (c & d)
        fig =  -duedx*8; % 0 or 2 depending on gradient
        for f = 1:2
            % Decide which dependent variable to plot
            y = theta;
            if rem(f, 2) == 0
                y = He;
            end

            % Select graph and plot data
            figure(fig + f)
            hold on
            p(i) = plot(x, y, 'DisplayName', ...
                ['Re_L = 1e' num2str(log10(ReL))], ...
                'Color', colors(c,:),...
                'LineWidth', 1.2);

            % Plot transition markers
            if int > 0
                plot(x(int), y(int), 'ko', 'DisplayName', 'natural transition')
            end
            if ils > 0
                plot(x(ils), y(ils), 'kx', 'DisplayName', 'laminar separation')
            end
            if itr > 0
                plot(x(itr), y(itr), 'ks', 'DisplayName', 'turbulent reattachment')
            end
            if its > 0
                plot(x(its), y(its), 'kd', 'DisplayName', 'turbulent separation')
            end
        end
        c = c+1; % increment color of plotted line
    end
end

% Set all graph options
for i = 1:4
    figure(i)
    xlabel("x/L");
    ylabel("\theta/L");
    if rem (i, 2) == 0
        ylabel("H_e");
    end
    set(gca, 'FontName','Times', 'FontSize', 14);
    legend(legendUnq(gca, 'alpha'), 'location', 'NorthWest', 'FontSize', 10);
    print (gcf, ['LaTeX/Week_2/graphs/e6g' num2str(i)], '-depsc' )
end
