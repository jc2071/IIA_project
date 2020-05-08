function [infa, infb] = refpaninf(del, x, yin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if abs(yin) < 1e-8
        y = 1e-2;
    else
        y = yin;
        
    I0 = -1/(4*pi) * (x.*log(x.^2 + y.^2) - (x - del).*log((x - del).^2 + y.^2) - 2*del + 2*y.*(atan(x./y) - atan((x - del)./y)));
    I1 = 1/(8*pi) * ((x.^2 + y.^2).*log(x.^2 + y.^2) - ((x - del).^2 + y.^2).*log((x - del).^2 +y.^2) - 2.*x.*del + del^2);
    
 
    
    infa = (1 - x/del).*I0 - I1/del;

    infb = (x/del).*I0 + I1/del;
    
end

