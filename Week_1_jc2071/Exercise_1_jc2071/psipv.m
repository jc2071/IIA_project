function psixy = psipv(xc, yc, Gamma,x,y)
    
    psixy = -Gamma*log((x - xc).^2 + (y - yc).^2)/(4*pi);
    
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


end

