function rhsvec = build_rhs(xs, ys, alpha)

    psifs = ys.*cos(alpha) - xs.*sin(alpha);
    
    rhsvec_hold = circshift(psifs,1) - psifs;
    
    rhsvec = [0, rhsvec_hold(2:end -1), 0].'; %transpose
end



