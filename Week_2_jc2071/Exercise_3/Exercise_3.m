
clear
close all

np = 101; % intergration spacing 
x = linspace(0,1,np); % this is (x/L)
ugrad = -0.25;

for Rel = [1e5, 1e4, 1e3] 
    disp(['Reynolds Number: ', num2str(Rel)])
    laminar = true;
    ustart = 1; % this is Ue/U at x = 0
    ue = linspace(ustart,ustart + ugrad,np); % this is array of velocity
    intergral = zeros(size(x));
    theta = zeros(size(x));
    i = 1;
    int = 0;
    ils = 0;
    while laminar && i < np
        i = i +1;
        intergral(i) = intergral(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
        theta(i) = sqrt(intergral(i)  * 0.45/ Rel /ue(i)^6);
        m = - Rel* theta(i)^2 * ugrad;
        H = thwaites_lookup(m);
        He = laminar_He(H);
        Rethet = Rel * ue(i) * theta(i);
        if log(Rethet) >= 18.4*He - 21.74
            laminar = false;
            int = i;
            disp(['at grad = ' num2str(ugrad) ' natural transition at x/L: ' ...
                num2str(x(int)) ' Retheta: ' num2str(Rethet/1000)]);
        elseif m >= 0.09
            laminar = false; 
            ils = i;
            disp(['at grad = ' num2str(ugrad) ' laminar seperation at x/L: ' ...
                num2str(x(ils)) ' Retheta: ' num2str(Rethet/1000)]);
        elseif i == np
            disp(['at grad = ' num2str(ugrad) ' : No Turbulence'])
        end
    end
end 



