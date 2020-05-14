
clear
close all

np = 101; % intergration spacing 
x = linspace(0,1,np); % this is (x/L)
Rels = 0:1000:1e7;
type = zeros(size(Rels));
typei = 1;
for Rel = Rels
        ugrad = -0.25;
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
                type(typei) = 1;
                typei = typei +1;
            elseif m >= 0.09
                laminar = false; 
                type(typei) = 0;
                typei = typei +1;
            end
       end
           
end

for i = 1:length(type) -1
    if type(i) < type(i+1)
        disp(Rels(i+1))
    end
end 