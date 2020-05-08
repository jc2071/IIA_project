function lhsmat = build_lhs(xs, ys)
    
    % build_lhs takes arguments xs and ys, the positions of point vortex (x,y) 
    
    np = length(xs) - 1; % number of panels
    psip = zeros(np, np +1);  % matrix for psip (np) x (np -1)
   
    for i = 1:np 
        for j = 1:np + 1 
            if j == 1
                [infa ,infb] = panelinf(xs(j), ys(j), xs(j+1), ys(j+1), xs(i), ys(i));
                psip(i,j) = infa;
                
            elseif j == np +1
                [infa, infb] = panelinf(xs(j-1), ys(j-1), xs(j), ys(j), xs(i), ys(i));
                psip(i,j) = infb;
                
            else 
                [infa ,jgjh] = panelinf(xs(j), ys(j), xs(j+1), ys(j+1), xs(i), ys(i));
                [jguu ,infb] = panelinf(xs(j-1), ys(j-1), xs(j), ys(j), xs(i), ys(i));
                psip(i,j) = infa + infb;    
        end
        end        
   lhsmat = psip;
end

