
clear
close all

np = 1001;
x = linspace(0,1,np); % this is (x/L)
ustart = 1; % this is Ue/U at x = 0
ugrad = 0; % this is velocity gradient
ue = linspace(ustart,ustart + ustart*ugrad,np); 
Rel = 1000;

Blassius = (0.664/sqrt(Rel)) * sqrt(x); 
Thwaites2 = zeros(size(x)); % this is the stepping of the intergral gives
    ... dimensionless momentum thickness squared

for i = 2:length(x) %gets np -1 points
    Thwaites2(i) = Thwaites2(i-1) +(0.45* ue(end)^-6)/ Rel * ...
        ueintbit(x(i-1), ue(i-1), x(i), ue(i));
end 

plot(x, Blassius, 'color', 'magenta');
hold on
plot(x, sqrt(Thwaites2),'-', 'color', 'blue');
xlabel("x/L");
ylabel("\theta/L");
legend('Blassius','Thwaites')
set(gca,'fontname','Times');


