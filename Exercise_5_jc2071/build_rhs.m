function rhsvec = build_rhs(xs, ys, alpha)

    psifs = ys*cos(alpha) - xs*sin(alpha);

    rhsvec_hold = psifs - circshift(psifs,-1);
    rhsvec_trim = rhsvec_hold(2:end -1);
    
    rhsvec = [0, rhsvec_trim, 0].'; %transpose
end



