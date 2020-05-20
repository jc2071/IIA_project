function [cl, cd] = forces(circ, cp, delstarl, thetal, delstaru, thetau)


Htel = delstarl(end)/thetal(end);
Hteu = delstaru(end)/thetal(end); % Depends how we define it???
Hte = Htel + Hteu;

thetate= thetal(end) + thetau(end);
thetainf = thetate*(sqrt(1-cp(end)))^((Hte + 5)/2);

cl = -2 *circ;
cd = 2 *thetainf;
