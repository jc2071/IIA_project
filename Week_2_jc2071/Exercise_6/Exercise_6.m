
clear; close all; clc

colors = ['r', 'm','b']; 
c = 1;
for Rel = [1e4,1e5,1e6]
    global Re duedx ue0
    np = 101; % intergration spacing 
    x = linspace(0,1,np); % this is (x/L)
    Re = Rel; % weird but has to be done, maybe?
    duedx = -0.25;
    laminar = true;
    ue = linspace(1,1 + duedx,np); % this is array of velocity
    
    intergral = zeros(size(x)); % an intermediate step
    theta = zeros(size(x)); % momentum thickness
    
    int = 0;
    ils = 0; 
    itr = 0; 
    its = 0; 

    i = 1; 
    He = zeros(size(x)); He(1) = 1.57258; % set He(1) as not defined otherwise, use Blassius

    while laminar && i < np
        i = i +1;
        intergral(i) = intergral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
        theta(i) = sqrt(intergral(i)  * 0.45/ Re /ue(i)^6);
        m = - Re* theta(i)^2 * duedx;
        H = thwaites_lookup(m);
        He(i) = laminar_He(H);
        Rethet = Re * ue(i) * theta(i);
        if log(Rethet) >= 18.4*He(i) - 21.74
            laminar = false;
            int = i; % marks postion at which natural transiton
            deltae = He(i) * theta(i);
            c = c+1;
        elseif m >= 0.09
            He(i) = 1.51509;
            laminar = false; 
            ils = i; % marks position at whih seperation
            deltae = He(i) * theta(i);
            c = c +1;
        elseif i == np -1
            disp(['at grad = ' num2str(duedx) ' : No Turbulence'])
            c = c +1;
        end
    end

    while i <np && its == 0
        i = i +1;
        ue0 = ue(i-1);
        thick0 = zeros(2,1);
        thick0(1) = theta(i-1);
        thick0(2) = deltae;
        [delx, thickhist] = ode45(@thickdash,[0, x(i) - x(i-1)], thick0);
        theta(i) = thickhist(end,1);
        deltae = thickhist(end,2);
        He(i) = thickhist(end,2)/ thickhist(end,1);
        
        if He(i) < 1.46
            its = i;
        elseif ils > 0 && itr ==0 && He(i) > 1.58 % not too sure on this?
            itr = i;
        end
    end
    
    while i <np
        H = 2.803;
        i = i +1;
        theta(i) = theta(i-1)*(ue(i-1)/ue(i))^(H+2);
        He(i) = He(i-1);
    end
    
    figure(1)
    hold on
    plot(x, theta, 'DisplayName', ...
        ['Re = ' num2str(Re, '%.1e')], 'Color', num2str(colors(c-1)))
    figure(2)
    hold on
    plot(x, He, 'DisplayName', ...
        ['Re = ' num2str(Re, '%.1e')], 'Color', num2str(colors(c-1)))
end

figure(1)
xlabel("x/L");
ylabel("\theta/L");
legend('show', 'location','NorthWest')
set(gca,'fontname','Times');
box on

figure(2)
xlabel("x/L");
ylabel("He");
legend('show', 'location','NorthWest')
set(gca,'fontname','Times');
box on