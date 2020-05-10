function lhsmat = build_lhs(xs, ys)

% psip is an infa (np*np) matrix and an infb (np*np) matrix added together 
% but the infb matrix is shifted by one along the j axis. 
% psip = [ fa_1 [ fa_2 + fb_1 ... fa_np + fb_np-1 ] fb_np ]
%      = [ fa_1 ... fa_np, 0]
%      + [  0, fb_1 ... fb_np]

np = length(xs) - 1;

% Get xs and ys as column vectors of length np
% These are the spatial coordinates at which we calculate psi
xs_spatial = xs(1:np)';
ys_spatial = ys(1:np)';

% return infa and infb np,1,np array
[infa, infb] = panelinf(xs(1:np), ys(1:np), xs(2:end), ys(2:end), ...
xs_spatial, ys_spatial);

%reshape so that k axis is along j axis instead
infa = reshape(infa, np, np);
infb = reshape(infb, np, np);

% combine infa and infb into psip
psip = [infa, zeros(np,1)] + [zeros(np,1), infb];

% Construct [A]. 1st + Last row same as identity matrix.
% Central elements are [A]i = psip(i+1) - psip(i).
lhsmat = [1, zeros(1,np); psip(2:end,:) - psip(1:np-1,:); zeros(1,np), 1];

end