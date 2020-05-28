function wasgplot(x_foil,cp_foil,filein,alpha,Re,alphaswp,cl,cd,theta)
    [~,le_index] = min(abs(x_foil)); % Gets le index
    
    % Make a nice string of the Reynolds number pw444 code
    ReLongStr = num2str(Re);
    disp(ReLongStr)
    last_index = length(ReLongStr);
    for r = length(ReLongStr):-1:1
        if ReLongStr(r) ~= '0'
            last_index = r;
            disp(last_index)
            break
        end
    end
    expon = num2str(floor(log10(Re)));
    if last_index == 1
        ReStr = [ReLongStr(1), 'e', expon];
    else
        ReStr = [ReLongStr(1), '.', ReLongStr(2:last_index), 'e', expon];
    end
    %%
    %%
    figure(2)
    cla % clear output
    movegui(figure(2),'southwest');
    hold on
    plot(x_foil(1:le_index),-cp_foil(1:le_index),'color',...
        [0.6350 0.0780 0.1840],'linewidth',1.2)
    plot(x_foil(le_index:end),-cp_foil(le_index:end),'--','color',...
        [0.6350 0.0780 0.1840],'linewidth',1.2)
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
    %%
    %%
    figure(3)
    cla % clear output
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
    %%
    %%
    figure(4)
    subplot(2,1,1);
    cla % clear output
    xu = x_foil(1:le_index);
    thetau = theta(1:le_index);
    plot(xu,thetau)

    subplot(2,1,2);
    cla % clear output
    xl = x_foil(le_index:end);
    thetal = theta(le_index:end);
    plot(xl,thetal)
    %%
    %%
    function plotButtonPushed1(src,event)
        set(c1,'visible','off') % Avoid plotting "print to eps"
        print (gcf, ['Data/' extractBefore(filein,".surf") ...
            '/' 'cp_' ReStr '_' num2str(alpha)], '-depsc')
        set(c1,'visible','on')
    end

    function plotButtonPushed2(src,event)
        set(c2,'visible','off') % Avoid plotting "print to eps"
        print (gcf, ['Data/' extractBefore(filein,".surf") ...
             '/' 'LD_' ReStr '_' num2str(alpha)], '-depsc')
        set(c2,'visible','on')
    end
    %%
end






