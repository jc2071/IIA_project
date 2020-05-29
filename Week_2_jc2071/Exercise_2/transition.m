function [int, ils, Rethetdiv1000] = transition(Rel, ugrad)
%calculates point of transition for a given velocity gradient and Rel

np = 101; % intergration spacing 
laminar = true;
x = linspace(0,1,np); % this is (x/L)
ustart = 1; % this is Ue/U at x = 0
ue = linspace(ustart,ustart + ustart*ugrad,np); % this is array of velocity

Thwaites2 = zeros(size(x)); % this is the stepping of the intergral
int = 0;
ils = 0;
Rethetdiv1000 = 0;

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
        int = i; 
        Rethetdiv1000 = Rethet/1000;
    elseif m >= 0.09
        ils = i;
        laminar = false; 
        Rethetdiv1000 = Rethet/1000;
    end

if int ~= 0
    disp(['At Re = ' num2str(Rel) ' with velocity gradient = ' ...
        num2str(ugrad) ' Natural transition at ' num2str(x(int)),...
                 ' with Rethet ' num2str(Rethet)])
elseif ils ~0
    disp(['At Re = ' num2str(Rel) ' with velocity gradient = ' ...
        num2str(ugrad) ' Laminar seperation at ' num2str(x(ils)),...
                 ' with Rethet ' num2str(Rethet)])
else
    disp('no seperation')
    
end
end


