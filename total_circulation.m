function Gamma = total_circulation(xs, ys, g)
% Takes 2 row vectors describing surface points and one col vec describing
% the circulation per unit length of each point and returns the total
% circulation due to this surface.

%Number of panels. All input vectors are of length np + 1
np = length(xs) - 1;

% A column vector of average circulation on each panel.
avg_gamma = (g(1:np) + g(2:np+1))/2;

%A row vector of the length of each panel
len = sqrt( (xs(2:np+1)-xs(1:np)).^2 + (ys(2:np+1)-ys(1:np)).^2 );

%The total circulation is each average gamma multiplied by each length
% Since gam is a col vector we can sum by dotting them.
Gamma =  dot(len ,avg_gamma);