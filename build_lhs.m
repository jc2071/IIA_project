function lhsmat = build_lhs(xs, ys)
%lhsmat returns the [A] matrix. If we can get panelinf to output 3d arrays
%we can even remove the last for loop.

np = length(xs) - 1;
psip = zeros(np, np+1);

%Get shorter versions of xs and ys of length np and as column vectors
xs_trun = xs(1:np)';
ys_trun = ys(1:np)';

%Loop over the panels and add the influence coefficients to the psi_p
%matrix
for j = 1:np
    [infa, infb] = panelinf(xs(j), ys(j), xs(j+1), ys(j+1), xs_trun, ys_trun);
    psip(:,j:j+1) = psip(:,j:j+1) + [infa; infb];
end

%Construct the [A] matrix. 1st + Last row same as identity matrix. Central
%bit is [A]i = psip(i+1) - psip(i).
lhsmat = [1, zeros(np); psip(2:end,:) - psip(1:np-1,:); zeros(np), 1];
end