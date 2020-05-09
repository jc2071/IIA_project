function rhsvec = build_rhs(xs, ys, alpha)
% b is length np+1. b(0) = b(np+1) = 0 to satisfy auxillary
% equations.
% The intermediate elements b(2:np) are psi_fs(i) - psi_fs(i+1) positioned such
% that b(2) = psi_fs(i=1) - psi_fs(i=2)

    %Make psi_fs
    psi_fs = ( ys*cos(alpha) - xs*sin(alpha) );
    
    %Set first + last elements to zero and fill b(2:np) with difference of
    %psi_fs vectors.
    %Then transpose to column vector
    rhsvec = [0, psi_fs(1:end-2) - psi_fs(2:end-1), 0]';
end