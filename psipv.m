function psixy = psipv(xc, yc, Gamma, x, y)
    psixy = -Gamma*log((x-xc)^2+(y-yc)^2)/(4*pi);
end