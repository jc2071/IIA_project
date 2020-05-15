function dthickdx = thickdash(xmx0, thick, ReL, ue0, duedx)
%
% function dthickdx = thickdash(xmx0, thick)
%
% used in ode45 to solve for boundary layer thickness.
% thick = [theta; He] NB is a col vector for some reason

ue = ue0 + xmx0*duedx;
Rethet = ReL * ue * thick(1);
He = thick(2)/thick(1);

% Calulate shape factor
H = 2.803;
if He >= 1.46
    H = (11*He+15) / (48*He-59);
end

% Calculate coefficients
cf = 0.091416 * (Rethet*(H-1))^(-0.232) * exp(-1.26*H);
cdiss = 0.010018 * (Rethet*(H-1))^(-1/6);

dthickdx = [cf/2; cdiss] - [(H + 2); 3]*duedx/ue.*thick;
end