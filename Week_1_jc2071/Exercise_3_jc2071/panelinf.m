function [infa ,infb] = panelinf(xa, ya, xb, yb, x, y)
    
    del = sqrt((xb-xa)^2+(yb-ya)^2); %length of panel
    rx = x - xa;
    ry = y - ya;
    tx = xb - xa;
    ty = yb - ya;
    nx = ya - yb;
    ny = xb - xa;
    X = (rx*tx + ry*ty)/del;
    Y = (rx*nx + ry*ny)/del;

    [infa ,infb] = refpaninf(del, X, Y);

end
