
clear
close all

np = 1001; % intergration spacing 
laminar = true;
x = linspace(0,1,np); % this is (x/L)
ustart = 1; % this is Ue/U at x = 0
ugrad = 0; % this is velocity gradient
ue = linspace(ustart,ustart + ustart*ugrad,np); % this is array of velocity
Rel = 20e6;

Thwaites2 = zeros(size(x)); % this is the stepping of the intergral

i = 1;
while laminar && i < np
    i = i +1;
    Thwaites2(i) = Thwaites2(i-1) +(0.45* ue(end)^-6)/ Rel * ...
        ueintbit(x(i-1), ue(i-1), x(i), ue(i));
    m = - Rel* Thwaites2(i) * ugrad;
    H = thwaites_lookup(m);
    He = laminar_He(H);
    Rethet = Rel * ue(i) * sqrt(Thwaites2(i));
    if log(Rethet) >= 18.4*He - 21.74
        laminar = false;
        disp([x(i) Rethet/1000])
    end
end 


plot(x(1:i), sqrt(Thwaites2(1:i)));
hold on
scatter(x(i),sqrt(Thwaites2(i)),130, 'x');


