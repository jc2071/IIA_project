
clear; close all; clc

global Re duedx

np = 101; % intergration spacing 
x = linspace(0,1,np); % this is (x/L)
Re = 1e7;
duedx = 0;
u0 = 1;
%disp(['Reynolds Number: ', num2str(Re)])
laminar = true;
ue = linspace(u0,u0 + duedx,np); % this is array of velocity
intergral = zeros(size(x)); % an intermediate step
theta = zeros(size(x)); % momentum thickness

int = 0; % check for natural trans
ils = 0; % check for laminar seperation
itr = 0; % check for turbulent reattachment
its = 0; % check for turbulent seperation

i = 1; 
He = zeros(size(x)); % He for all positions
He(1) = 1.57258; % set He(1) as not defined otherwise, use Blassius

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
    elseif m >= 0.09
        He(i) = 1.51509;
        laminar = false; 
        ils = i; % marks position at whih seperation
        deltae = He(i) * theta(i);
    elseif i == np -1
        disp(['at grad = ' num2str(duedx) ' : No Turbulence'])
        deltae = He(i) * theta(i);
    end
end

global ue0 % setting global variables, 
         ... pw444 does this slightly different
     
while i <np && its == 0
    i = i +1;
    ue0 = ue(i-1);
    thick0 = zeros(2,1);
    thick0(1) = theta(i-1);
    thick0(2) = deltae;
    [delx, thickhist] = ode45(@thickdash,[0, x(i) - x(i-1)], thick0);
    thickhist(:,2);
    theta(i) = thickhist(end,1);
    deltae = thickhist(end,2);
    He(i) = thickhist(end,2)/ thickhist(end,1);
    
    if He < 1.46
        its = i;
    elseif itr ==0 && ils > 0 && He(i) > 1.58 % not too sure on this?
        itr = i;
    end
end

if i < np && its == 0
    H = 2.803;
    i = i +1;
    theta(i) = theta(i-1)*(ue(i-1)/ue(i))^(H+2);
end

plot(x, theta)
