
clear
close all

np = 101; % intergration spacing 
x = linspace(0,1,np); % this is (x/L)
ustart = 1; % this is Ue/U at x = 0
ugrad = -0.25;
ue = linspace(ustart,ustart + ustart*ugrad,np); % this is array of velocity
Rel = 7e5:100:7.7e5;
Thwaites2 = zeros(size(x)); % this is the stepping of the intergral
int = 0;
ils = 0;

check_1 = true; 

while check_1 == true
    for j = 1:length(Rel)
        for i = 2:np
            Thwaites2(i) = Thwaites2(i-1) +(0.45* ue(end)^-6)/ Rel(j) * ...
                ueintbit(x(i-1), ue(i-1), x(i), ue(i));
            m = - Rel(j)* Thwaites2(i) * ugrad;
            H = thwaites_lookup(m);
            He = laminar_He(H);
            Rethet = Rel(j) * ue(i) * sqrt(Thwaites2(i));
            log(Rethet) - (18.4*He - 21.74)
            if log(Rethet) >= (18.4*He - 21.74) && m >= 0.09
                check_1 = false; 
                %disp(Rel(j));
                break
            end
        end
    end 
end 


