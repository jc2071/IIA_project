function [cl, cd] = forces(circ, cp, delstarl, thetal, delstaru, thetau)

thetate = thetal(end) + thetau(end);
deltate = delstarl(end) + delstaru(end); % Depends how we define it???
Hte = deltate/thetate;

thetainf = thetate*(sqrt(1-cp(end)))^((Hte + 5)/2);

cl = -2 *circ;
cd = 2 *thetainf;
