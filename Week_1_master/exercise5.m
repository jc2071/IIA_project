clear
close all

% Define the cylinder & angle of attack
np = 100;
r = 1;
theta = (0:np)*2*pi/np;
xs = r*cos(theta);
ys = r*sin(theta);
alpha = [0, pi/18];
color = ['r', 'b']

for i = 1:length(alpha)
% Calculate gamma vector
A = build_lhs(xs,ys);
b = build_rhs(xs,ys,alpha(i));
gam = A\b;

% Print total circulation
Gam = total_circulation(xs, ys, gam);
disp(Gam)

% Plot gamma values against theta/pi
figure(i)
plot(theta/pi, gam, 'color', color(i));
xlabel('$\frac{\theta}{\pi}$','FontSize', 22, 'Interpreter','latex')
ylabel('\gamma', 'FontSize', 22)
set(gca,'fontname','Times', 'FontSize',14);
axis([0 2 -2.5 2.5]);
print (gcf, ['LaTeX/Week_1/graphs\e5g', num2str(i)], '-depsc' )
end