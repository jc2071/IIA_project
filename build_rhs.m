function rhsvec = build_rhs(xs, ys, alpha)
%Return b vector of psifs(i) - psifs(i+1)
    psifs = ys*cos(alpha) - xs*sin(alpha);
    rhsvec = psifs - circshift(psifs, -1);
end