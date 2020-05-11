%  Script for use in studying resolution requirements of panel method 
%  calculation.  To alter incidence, edit 'alpha' below.  To alter
%  Van de Vooren geometry parameters, see vdvfoil.m.

%  free-stream incidence
alpha = pi/12;

%  Van de Vooren geometry and pressure distribution
npin = 2000;
[xsin, ysin, cpex] = vdvfoil( npin, alpha );

figure(1)
plot(xsin,ysin)
axis('equal')
xlabel('x/c')
ylabel('y/c')
title('Van de Vooren aerofoil')

disp('Starting 100 panel calculation ...')
np = 100;
[xs, ys] = make_upanels( xsin, ysin, np );

A = build_lhs ( xs, ys );
b = build_rhs ( xs, ys, alpha );

gams = A\b;
xs1 = xs;
cp1 = 1 - gams.^2;

disp('Starting 200 panel calculation ...')
np = 200;
[xs, ys] = make_upanels( xsin, ysin, np );

A = build_lhs ( xs, ys );
b = build_rhs ( xs, ys, alpha );

gams = A\b;
xs2 = xs;
cp2 = 1 - gams.^2;

disp('Starting 400 panel calculation ...')
np = 400;
[xs, ys] = make_upanels( xsin, ysin, np );

A = build_lhs ( xs, ys );
b = build_rhs ( xs, ys, alpha );

gams = A\b;
xs4 = xs;
cp4 = 1 - gams.^2;

disp('Starting 800 panel calculation ...')
np = 800;
[xs, ys] = make_upanels( xsin, ysin, np );

A = build_lhs ( xs, ys );
b = build_rhs ( xs, ys, alpha );

gams = A\b;
xs8 = xs;
cp8 = 1 - gams.^2;

figure(2)
plot(xsin,-cpex,xs1,-cp1,'--',xs2,-cp2,'-.',xs4,-cp4,'-+',xs8,-cp8,'-x')
xlabel('x/c')
ylabel('-c_p')
title('Van de Vooren cps; varying panel size')
legend('exact','100pans','200pans','400pans','800pans')

figure(3)
plot(xsin,-cpex,xs1,-cp1,'--')
legend('exact','100 panels')

figure(4)
plot(xsin,-cpex,xs2,-cp2,'--')
legend('exact','200 panels')

figure(5)
plot(xsin,-cpex,xs4,-cp4,'--')
legend('exact','400 panels')

figure(6)
plot(xsin,-cpex,xs8,-cp8,'--')
legend('exact','800 panels')
