function psixy = psipv ( xc, yc, Gamma, x, y )
%
% function psixy = psipv ( xc, yc, Gamma, x, y )
%
% xc, yc are coords of vortex of strength Gamma
% x, y are matrices at which the streamfunction is evaluated
% returns a matrix of size(x)

psixy = -Gamma*log((x-xc).^2+(y-yc).^2)/(4*pi);

end