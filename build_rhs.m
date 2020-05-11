function rhsvec = build_rhs(xs, ys, alpha)
%
% function rhsvec = build_rhs(xs, ys, alpha)
%
% Calculate the b vector from the psi free stream.

%Make psi_fs
psi_fs = ( ys*cos(alpha) - xs*sin(alpha) );

%Set first + last elements to zero and fill b(2:np) with difference of
%psi_fs vectors.
%Then transpose to column vector
rhsvec = [0, psi_fs(1:end-2) - psi_fs(2:end-1), 0]';
end