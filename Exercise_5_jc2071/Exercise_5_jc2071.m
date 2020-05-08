
r = 1;
N = 5;
theta = (0:N)*2*pi/N;

xs = r*cos(theta); % surface of cyclinder x
ys = r*sin(theta); % surface of cyclinder y 

build_lhs(xs, ys)
