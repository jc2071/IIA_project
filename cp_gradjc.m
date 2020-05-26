function [xgrads, grads] = cp_gradjc(x,cp,np)
    
    xgrads = x(1:floor(np/2 +1));
    grads = zeros(1,floor(np/2 +1));
    
    for i = 1:length(grads)
        if i < length(grads)
        grads(i) = (cp(i+1) - cp(i)) / (x(i+1) - x(i));
        else 
        grads(i) = (cp(i) - cp(i-1)) / (x(i) - x(i-1));
        end
    end