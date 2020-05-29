% Determine critical velocity gradient
n = 101;
x = linspace(0, 1, n);
sz = size(x);
ReL = 1e5;
duedx = -0.5;

transition_occurs = true;
while transition_occurs && abs(duedx) > 0

    duedx = duedx + 0.01;

    int = 0; % Location of natural transition
    ils = 0; % Location of laminar separation
    itr = 0; % Location of turbulent reattachment
    its = 0; % Location of turbulent separation

    integral = zeros(sz);
    theta = zeros(sz);
    He = zeros(sz);
    He(1) = 1.57258;
    ue = linspace(1, 1+duedx, n);
    laminar = true;
    i = 1;

    while laminar && i < n
        i = i + 1; % start at n == 2

        integral(i) = integral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
        theta(i) = sqrt( 0.45/ReL * integral(i)/ue(i)^6 );

        Rethet = ReL * ue(i) * theta(i);
        m = -ReL * theta(i)^2 * (ue(i)-ue(i-1)) / (x(i)-x(i-1));
        He(i) = laminar_He( thwaites_lookup(m) );

        % Check for transition or separation
        if log(Rethet) >= 18.4*He - 21.74 % Transition
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
    disp('-----------------------------')
    disp(['Velocity gradient: ', num2str(duedx)])
    disp(['Turbulent separation occured at x: ', num2str(x(its))])
    if its == 0
        transition_occurs = false;
    end
end
