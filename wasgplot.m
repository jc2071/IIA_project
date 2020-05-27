function wasgplot(x_foil,cp_foil,filein,alpha,Re,alphaswp,cl,cd)
    [~,le_index] = min(abs(x_foil)); % Gets le index
    
    Rep = sprintf('%.1e', Re);
    figure(2)
    cla
    movegui(figure(2),'southwest');
    hold on
    plot(x_foil(1:le_index),-cp_foil(1:le_index),'color', [0.6350 0.0780 0.1840],'linewidth',1.2)
    plot(x_foil(le_index:end),-cp_foil(le_index:end),'--','color', [0.6350 0.0780 0.1840],'linewidth',1.2)
    legend('Upper surface','Lower surface')
    plt = yline(0,'k');
    plt.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold off
    xlabel('x/c');
    ylabel('-cp');
    set(gca, 'FontName','Times', 'FontSize', 14);
    c1 = uicontrol;
    c1.String = 'Print to eps';
    c1.Callback = @plotButtonPushed1;
    max_ld = max(cl./cd);
    
    figure(3)
    cla
    movegui(figure(3),'northeast');
    hold on
    plot(alphaswp,cl./cd, 'color' , [0.6350 0.0780 0.1840], 'linewidth' ,1.2)
    text(16,10,['Max L/D: ' num2str(round(max_ld))])
    yline(0,'k')
    hold off
    xlabel('\alpha')
    ylabel('L/D')
    set(gca, 'FontName','Times', 'FontSize', 14);
    c2 = uicontrol;
    c2.String = 'Print to eps';
    c2.Callback = @plotButtonPushed2;

    function plotButtonPushed1(src,event)
        set(c1,'visible','off')
        print (gcf, [extractBefore(filein,".surf") '-cp'], '-depsc')
        set(c1,'visible','on')
    end

    function plotButtonPushed2(src,event)
        set(c2,'visible','off')
        print (gcf, [extractBefore(filein,".surf") '-LD'], '-depsc' )
        set(c2,'visible','on')
    end
  
end






