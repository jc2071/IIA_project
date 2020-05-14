clear
close all

% Set parameters
U = 1;
Re = 1e3; % Based on reference length L and speed U
x = linspace(0, 1, 101);
sz = size(x);
ue = U*ones(sz);
int = zeros(sz);
theta = zeros(sz);
blasius = 0.664/sqrt(Re)*sqrt(x);

% We start the loop at the second element as everything is 0 at x = 0
% We can see about vectorisation later
for i = 2:length(x)
    int(i) = int(i-1) + ueintbit(x(i-1), ue(i-1), x(i), ue(i));
    theta(i) = sqrt( 0.45/Re * int(i)/ue(i)^6 );
end

plot(x, theta, 'b')
hold on
plot(x, blasius, 'r')
hold off
legend({'Thwaites', 'Blasius'}, 'Location', 'southeast');