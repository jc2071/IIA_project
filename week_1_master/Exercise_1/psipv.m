function psixy = psipv(xc, yc, Gamma, x, y)
%Return the value of the streamfunction at a certain point due to a point
%vortex. x and y will be matrices xc and yc just numbers.
    psixy = -Gamma*log((x-xc).^2+(y-yc).^2)/(4*pi);
end