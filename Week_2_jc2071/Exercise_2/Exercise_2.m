
clear
close all

np = 101; % intergration spacing 
x = linspace(0,1,np); % this is (x/L)

for Rel = [1000, 10000, 100000] 
    disp(['Reynolds Number: ', num2str(Rel)])
    for ugrad = [-0.1,0, 0.1]
        laminar = true;
        ustart = 1; % this is Ue/U at x = 0
        ue = linspace(ustart,ustart + ugrad,np); % this is array of velocity
        intergral = zeros(size(x));
        theta = zeros(size(x));
        i = 1;
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
                disp(['at grad = ' num2str(ugrad) ' x/L: ' ...
                    num2str(x(i)) ' Retheta: ' num2str(Rethet/1000)]);
            elseif i == np
                disp(['at grad = ' num2str(ugrad) ' : No Natural Transition'])
            end
       end
           
   end 
end

