% We want to plot AOA agaisnt, Cl, Cd and L/D. Also want to see presusre
% distrubution

clear; close all; clc

nc = 100;
x_step = linspace(0,1,nc);
alpha = -16:1:16;
pmp = zeros(1,length(alpha));
index = 0;
for i = alpha
    index = index +1;
    pm = 0;
    load(['Data/naca0012/9e6_' num2str(i) '.mat'], 'xs','cp','thetal','thetau');
    cp_upper = flip(cp(1:length(thetau)));
    cp_lower = cp(length(thetau) + 1:end);
    xs_upper = flip(xs(1:length(thetau)));
    xs_lower = xs(length(thetau) + 1:end);
    
    for nx = 1:nc
         [~,upper_index] = min(abs(xs_upper-x_step(nx)));
         [~,lower_index] = min(abs(xs_lower-x_step(nx)));
    pm = pm + x_step(nx)*(cp_upper(upper_index) - cp_lower(lower_index))*1/nc;
    end
    pmp(index) = pm;
end

plot(alpha,pmp, 'LineWidth', 1.5, 'color','r')
xlabel('alpha')
ylabel('C_M')