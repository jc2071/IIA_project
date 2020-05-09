function lhsmat = build_lhs(xs, ys)
    
    np = length(xs) - 1; %number of panels
    psip = zeros(np, np+1); %initilise matrix its hights is all the i, its j is all the pannel

for j = 1:np
    [infa, infb] = panelinf(xs(j), ys(j), xs(j+1), ys(j+1), xs(1:end -1).', ys(1:end-1).');
    psip(:,j:j+1) = psip(:,j:j+1) + [infa, infb]; %copied but understood, mostly, from pw444 :) 
    
    % gets the j and j +1 column and adds to it infa(j) at j and infb(j)
    % at j+1, therefore satisfying j-1 at j. at j = 1 we only have infa(j)
    % at j = np the last one only gets j-1, so also okay.
end


lhsmat = [1, zeros(1,np); psip(2:end,:) - psip(1:np-1,:); zeros(1,np), 1];
end
