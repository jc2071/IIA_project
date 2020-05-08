function lhsmat = build_lhs(xs, ys)
    
    % build_lhs takes arguments xs and ys, the positions of point vortex (x,y) 
    
    np = length(xs) - 1; % number of panels  % matrix for psip (np) x (np -1)
    %i = linspace(1,np,1);
    %j = linspace(1, np +1,1);
    %ia, ja = meshgrid(i,j);
    
    psip = zeros(np, np +1);
    
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
    
   %can't use last panel as would repeat
   
   x = psip;
   rowToInsert = 1;
   rowVectorToInsert = [1,zeros(1,np)];
   psi_i1 = [x(1:rowToInsert-1,:); rowVectorToInsert; x(rowToInsert:end,:)];
   rowToInsert = length(xs);
   psi_i = [x(1:rowToInsert-1,:); rowVectorToInsert; x(rowToInsert:end,:)];

   lhsmat = psi_i1 - psi_i;
   
   
    end

    

