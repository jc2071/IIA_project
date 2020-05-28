function wasgplot(x_foil,cp_foil,filein,alpha,Re,alphaswp,cl,cd,theta,iss)
    ipstag = iss(1);
    % Make a nice string of the Reynolds number pw444 code
    ReLongStr = num2str(Re);
    last_index = length(ReLongStr);
    for r = length(ReLongStr):-1:1
        if ReLongStr(r) ~= '0'
            last_index = r;
            break
        end
    end
    expon = num2str(floor(log10(Re)));
    if last_index == 1
        ReStr = [ReLongStr(1), 'e', expon];
    else
        ReStr = [ReLongStr(1), '.', ReLongStr(2:last_index), 'e', expon];
    end
    %% iunt, iuls, iutr, iuts, ilnt, ills, iltr, ilts --> (2,.....,9)
    %%
    f2 = figure(2);
    a2 = axes('Parent', f2);
    cla(a2)
    movegui(figure(2),'southwest');
    hold on
    plot(x_foil(1:ipstag),-cp_foil(1:ipstag),'color',...
        [0.6350 0.0780 0.1840],'linewidth',1.2)
    plot(x_foil(ipstag:end),-cp_foil(ipstag:end),'--','color',...
        [0.6350 0.0780 0.1840],'linewidth',1.2)
    legend('Upper surface','Lower surface')
    plt = yline(0,'k');
    markers = ['ko','kx','ks','kd','ko','kx','ks','kd'];
    for i = 2:9
        if iss(i) >0
            plot(x_foil(iss(i)),-cp_foil(iss(i)), markers(i-1))
        end
    end
    legend()
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
    f3 = figure(3);
    a3 = axes('Parent', f3);
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
    %%
    %%
    f4 = figure(4);
    a4 = axes('Parent', f4);
    cla(a4)
    subplot(2,1,1);
    cla % clear output
    xu = x_foil(1:ipstag+1);
    thetau = theta(1:ipstag+1);
    plot(xu,thetau,'color',...
        [0.6350 0.0780 0.1840],'linewidth',1.2)
    xlabel('x/c')
    ylabel('\theta/c')
    title('Upper momentum thickness')
    set(gca, 'FontName','Times', 'FontSize', 14,'FontWeight','normal');

    subplot(2,1,2);
    cla % clear output
    xl = x_foil(ipstag:end);
    thetal = theta(ipstag:end);
    plot(xl,thetal,'color',...
        [0.6350 0.0780 0.1840],'linewidth',1.2)
    xlabel('x/c')
    ylabel('\theta/c')
    title('Lower momentum thickness')
    set(gca, 'FontName','Times', 'FontSize', 14,'FontWeight','normal');
    
    c3 = uicontrol;
    c3.String = 'Print to eps';
    c3.Callback = @plotButtonPushed3;
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

    function plotButtonPushed3(src,event)
        set(c3,'visible','off') % Avoid plotting "print to eps"
        print (gcf, ['Data/' extractBefore(filein,".surf") ...
             '/' 'theta_' ReStr '_' num2str(alpha)], '-depsc')
        set(c3,'visible','on')
    end
    %%
end






