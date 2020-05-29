function f = ueintbit(xa, ua, xb, ub)
%Calculates eqn 10 between two points, by adding all of these up we can get
%the full intergral
    
    ubar = (ua + ub)/2;
    
    deltau = ub - ua;
    
    deltax = xb - xa;
    
    f = ((ubar^5) + 5/6 * ubar^3 * (deltau)^2 + 1/16 * ubar * ...
    (deltau)^4) * deltax;

end

