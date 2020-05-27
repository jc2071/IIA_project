function wasgplot(x_foil,cp_foil,filein,alpha,Re,alphaswp,cl,cd)
    Rep = sprintf('%.1e', Re);
    figure(2)
    movegui(figure(2),'southwest');
    plot(x_foil,-cp_foil,'color', [0.929 0.6940 0.125])
    xlabel('x/c')
    ylabel('-cp')
    set(gca, 'FontName','Times', 'FontSize', 14);
    c1 = uicontrol;
    c1.String = 'Print to eps';
    c1.Callback = @plotButtonPushed1;
    
    figure(3)
    movegui(figure(3),'NorthEast');
    plot(alphaswp,cl./cd)
    xlabel('x/c')
    ylabel('L/D')
    set(gca, 'FontName','Times', 'FontSize', 14);
    c2 = uicontrol;
    c2.String = 'Print to eps';
    c2.Callback = @plotButtonPushed2;
    

    function plotButtonPushed1(src,event)
        set(c1,'visible','off')
        print (gcf, [extractBefore(filein,".surf") '-cp_' Rep...
            '_' num2str(alpha)], '-depsc' )
        set(c1,'visible','on')
    end

    function plotButtonPushed2(src,event)
        set(c2,'visible','off')
        print (gcf, [extractBefore(filein,".surf") '-LD_' Rep...
            '_' num2str(alpha)], '-depsc' )
        set(c2,'visible','on')
    end
  
end





