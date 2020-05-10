function [infa, infb] = refpaninf(del, X, Yin)
% Calculate the influence coefficients for a reference panel of vorticity.
% X and Y can be 3D arrays with del a k-index vector giving length of each
% panel.

%This still needs sorting out
Y = zeros(size(Yin));
for n = 1:numel(Yin)
    if abs(Yin(n)) < 1e-8
        Y(n) = 1e-8; % why not using a *sign(Yin)??? why does it nan my matrix
    else
        Y(n) = Yin(n);
    end
end


%Calculate integrals using elemenet operations where neccesary
I0 = -( X.*log(X.^2 + Y.^2) - (X-del).*log((X-del).^2 + Y.^2) ...
-2*del +2*Y.*(atan(X./Y)-atan((X-del)./Y)) )/(4*pi);

I1 = ( (X.^2 + Y.^2).*log(X.^2 + Y.^2) ...
-((X-del).^2+Y.^2).*log((X-del).^2+Y.^2) -2*X.*del + del.^2)/(8*pi);

% Each of these is a 3D array. Elemental division of a 3D array by k-vector
% divides each sheet by k-vector value at that k index.
infa = (1-X./del).*I0 - I1./del;
infb = (X./del).*I0 + I1./del;

end