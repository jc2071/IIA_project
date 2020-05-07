

clear
close all

N =  100;
x = linspace(-2.5,2.5,N);
y = linspace(-2,2,N);
del = 1.5;

for i = 1:N
    for j = 1:N
        xg(i,j) = x(i);
        yg(i,j) = y(j);
        [infa(i,j), infb(i,j)] = refpaninf(del, xg(i,j), yg(i,j));
    end
end

numColors = 6;
colormap(jet(numColors))
    
c = -0.15:0.05:0.15;

figure(1)

[C,h] = contour(xg,yg,infa,c);
title('$f_{a}$' + " Countour Plot",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Latin Modern Math')
set(gca,'fontname','Latin Modern Math');

figure(2)
numColors = 10;
colormap(jet(numColors))
[C,h] = contour(xg,yg,infb,c);
title('$f_{b}$' + " Countour Plot",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Latin Modern Math')
set(gca,'fontname','Latin Modern Math');

n = 100;
for i = 1:n
    xe(i) = (i - 0.5)*del/n; %center of each block
    ye(i) = 0;
    gae(i) = (1 - xe(i)/del)*del/n; %gets a component of circulation
    gbe(i) = (xe(i)/del)*del/n; %gets b component of circulation
end

%now get estimate by summing up over all points

for i = 1:N
    for j = 1:N
        ae(i,j) = 0; %reset values for a estimate
        be(i,j) = 0; %reset values for b estimate
        for p = 1:n
            ae(i,j) = ae(i,j) + psipv(xe(p), ye(p), gae(p), xg(i,j), yg(i,j));
            
            be(i,j) = be(i,j) + psipv(xe(p), ye(p), gbe(p), xg(i,j), yg(i,j));
            
        end
    end
end

figure(3);
numColors = 6;
colormap(jet(numColors))
[C,h] = contour(xg,yg,ae,c);
title('$f_{b}$' + " Countour Plot estimate",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Latin Modern Math')
set(gca,'fontname','Latin Modern Math');

figure(4); 
numColors = 6;
colormap(jet(numColors))
[C,h] = contour(xg,yg,be,c);
title('$f_{b}$' + " Countour Plot estimate",'Interpreter','latex');
xlabel("x");
ylabel("y");
clabel(C,h,c,'FontName','Latin Modern Math')
set(gca,'fontname','Latin Modern Math');





    





