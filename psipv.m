function psixy = psipv(xc, yc, Gamma, x, y)
%Return the value of the streamfunction at a certain point due to a point
%vortex
    psixy = -Gamma*log((x-xc).^2+(y-yc).^2)/(4*pi);
end