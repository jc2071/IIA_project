function dthickdx = thickdash(xmx0, thick)

    global Re ue0 duedx 

    He = thick(2) / thick(1);
    
    Retheta = Re*thick(1)*ue0
  
    if He >= 1.46
        H = (11*He + 15)/(48*He - 59);
    else
        H = 2.803;
    end 
        
    cf = 0.091416*((H-1)*Retheta)^-0.232 * exp(-1.260*H);
    
    cdiss = 0.010018*((H-1)*Retheta)^(-1/6);
    
    dthickdx = zeros(2,1);
    dthickdx(1) = cf/2 - (H+2)/ue0 * duedx *thick(1);
    dthickdx(2) = cdiss - 3/ue0 * duedx *thick(2);
   
end

