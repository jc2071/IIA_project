clear
close all

% Define the cylinder & angle of attack
np = 100;
r = 1;
theta = (0:np)*2*pi/np;
xs = r*cos(theta);
ys = r*sin(theta);
alpha = [0, pi/18];

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
plot(theta/pi, gam);
xlabel('$\frac{\theta}{pi}$', 'Interpreter','latex')
ylabel('\gamma')
axis([0 2 -2.5 2.5]);
print (gcf, ['LaTeX/Week_1/graphs\e5g', num2str(i)], '-depsc' )
end