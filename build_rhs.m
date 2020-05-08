function rhsvec = build_rhs(xs, ys, alpha)
%Return b vector of psi_fs(i) - psifs(i+1) with 0s top and bottom
    psi_fs = (ys*cos(alpha) - xs*sin(alpha));
    temp = ( circshift(psi_fs, 1) - psi_fs );    
    rhsvec = [0, temp(2:length(temp)-1), 0]'; %t ransposed to col
end