function wasgour
% CUED Wing Analysis Surface Generator
% RGM - developed for SA1 2020
% based on 'ManipulateData.m' written by Lindo Ouseph.
%
% Manipulate an aerofoil section with the trailing edge fixed at
% (x,y)=(1,0) interactively. The aerofoil shape is constructed using
% splines based on a list of nodes.
%
% WASG is designed to be run on your main SA1 folder, one level above
% the 'Geometry' folder.
%
% List of functions:
%  left mouse click - select a node, or create a new one if clicking on
%             the aerofoil between points.
%  click and drag left mouse button - move the selected point.
%  arrow keys - move the selected point at a rate 'delta'.
%  right mouse click - delete the node clicked on.gg
%  u - undo last action (up to 20).
%  r - redo, cancel last undo.
%  z - zoom, create a secondary magnified figure, centred on the last
%      cursor position, that the control is
%      temporarily transferred to. Pressing z again closes the second
%      figure and returns control to the primary one. Functions 'l', 's',
%      'b', and 't' are not available while in zoom mode.
%  l - load aerofoil from a '.surf' file.
%  s - save aerofoil into a '.surf' file.
%  b - back up aerofoil layout into a memory buffer.
%  t - restore aerofoil from backup 'b'.
%  d - delta, reset the rate of displacement of nodes when using the arrow
%      keys.

clear, close all

b=0;p=0;
delta=1e-4;
max_undo = 20;
xmax = 1.0;
xmin = 0.0;
ymax =  .2;
ymin = -.2;

pathin=[pwd,'/Geometry/'];
[filein,pathin]=uigetfile([pathin '*.surf']);
y=load([pathin,filein]);
x=y(2:end-1,1);
y=y(2:end-1,2);
L=length(x);
I=(x-1).^2+y.^2; I=find(I==max(I)); I=I(1);
Xbk=x;
Ybk=y;hZ=[];
axisZ=[];
aZ=[];
deltaZ=.2*delta;
deltxt=8e-3;
deltxtZ=1e-3;
Xbk=x;Ybk=y;Lmax=L;
xundo=[];yundo=[];
Lundo=[];Iundo=[];
xredo=[];yredo=[];
Lredo=[];Iredo=[];
Res=get(0); Res=Res.ScreenSize;

h=figure('units','normalized',...
    'outerposition',[.05 .2 1.35*Res(4)/Res(3) .6],...
    'DockControls','off',...
    'MenuBar','none',...
    'name',['Wing Analysis Section Generator: ' filein],...
    'NumberTitle','off',...
    'WindowKeyPressFcn',@Key,...
    'windowbuttondownfcn',@Down,...
    'WindowButtonMotionFcn',@Move,...
    'WindowButtonUpFcn',@Up,...
    'DeleteFcn',@figDelete);
movegui(figure(h),'northwest');
a=axes('position',[.10,.10,.87,.87]);

% %Extra UI to set Re, alpha and np
imarkers = ["kp","ko","k^","ks","kd","ko","k^","ks","kd"];
Re = 5e5; % default to slow aerofoil
alpha = 0;
alphaswp = 0:5:20;
np = 400;
% replotting = 0;
Rebg = uibuttongroup('Visible', 'off',...
     'units', 'pixels', ...
     'Position', [0 0 100 50],...
     'SelectionChangedFcn', @ReSelection);
uicontrol(Rebg,'Style',...
                  'radiobutton',...
                  'String','Slow 0.5e6',...
                  'Position',[5 25 100 20],...
                  'UserData', 5e5,...
                  'HandleVisibility','on');
              
uicontrol(Rebg,'Style','radiobutton',...
                  'String','Fast 20e6',...
                  'Position',[5 5 100 20],...
                  'UserData', 2e7,...
                  'HandleVisibility','on');
Rebg.Visible = 'on';
%np
uicontrol('Style', 'edit', 'String', '400', 'Position', [20, 55, 80, 20], 'Callback', @Setnp);
uicontrol('Style', 'text', 'String', 'np', 'Position', [0, 55, 20, 20]);
% alpha
uicontrol('Style', 'edit', 'String', '0', 'Position', [40, 80, 60, 20], 'Callback', @Setalpha);
uicontrol('Style', 'text', 'String', 'alpha', 'Position', [0, 80, 40, 20]);
% alphaswp
uicontrol('Style', 'edit', 'String', '0:5:20', 'Position', [5, 105, 100, 20], 'Callback', @Setalphaswp);
uicontrol('Style', 'text', 'String', 'alpha sweep', 'Position', [5, 130, 100, 20]);

% finito w extra ui

[xs ,ys] = splinefit([1;x;1],[0;y;0],0); % big list of x and y plotting points
plot(xs,ys,'k', ...
    [1;x],[0;y],'.k', ...
    'markersize',13,'markerfacecolor','k');

%---------------------- START INSERT
Replot() % a function so we don't need to re work all the code
% ------------ END INSERT

axis equal;
axis([xmin xmax ymin ymax])
uicontrol('style','text','Fontsize',10, ...
    'position',[1 190 80 220],...
    'string',{'O nat. tran';'^ lam sep';'sq reatch';...
    'di tur sep';'u-undo';'r-redo';'z-zoom';'l-load';'s-save';...
    'p-plot'; 'b-back up';'t-restore';'d-delta'},...
    'foregroundcolor','k');

%%% @Down - what happens when a mouse button is pressed
    function Down(varargin);
        xundo=[[x;0*(length(x)+1:Lmax)'],xundo(:,1:min([size(xundo,2),max_undo-1]))];
        yundo=[[y;0*(length(y)+1:Lmax)'],yundo(:,1:min([size(yundo,2),max_undo-1]))];
        Lundo=[L,Lundo(1:min([length(Lundo),max_undo-1]))];
        Iundo=[I,Iundo(1:min([length(Iundo),max_undo-1]))];
        p=get(a,'currentpoint');
        [V2 I]=min((x-p(1)).^2+(y-p(3)).^2);
        xx=x;
        yy=y;
        xx(I)=[];
        yy(I)=[];
        mindist2=min((xx-x(I)).^2+(yy-y(I)).^2);
        switch varargin{1}.SelectionType
            %%% Mouse left-click:
            case 'normal'
                %%% Add a knot if left-click is close to aerofoil contour:
                if V2>min(1e-4,mindist2)
                    [xs ys] = splinefit([1;x;1],[0;y;0],1);
                    ppk = 100; % needs to be the same in 'splinefit.m'
                    [V2 Is]=min((xs-p(1)).^2+(ys-p(3)).^2);
                    if V2<1e-4
                        xI=xs(Is);yI=ys(Is);
                        I = ceil(Is/ppk);
                        L=L+1;
                        Lmax=max([L,Lmax]);
                        x(I+1:L)=x(I:end);
                        y(I+1:L)=y(I:end);
                        x(I)=xI;
                        y(I)=yI;
                        xundo=[xundo;0*(size(xundo,1)+1:Lmax)'*(1:size(xundo,2))];
                        yundo=[yundo;0*(size(yundo,1)+1:Lmax)'*(1:size(yundo,2))];
                        xredo=[];
                        yredo=[];
                        Lredo=[];
                        Iredo=[];
                        b=1;
                        [xs ys] = splinefit([1;x;1],[0;y;0],0);
                        
                        
                        try delete(t);end;
                        plot(xs,ys,'k', ...
                            [1;x],[0;y],'.k', ...
                            x(I),y(I),'xk','markersize',13)
                        Replot(); % Our additions
                        axis equal
                        axis([0 1 -.2 .2])
                        t=text(x(I)+deltxt,y(I)-deltxt, ...
                            ['(',num2str(x(I),'%8.4f'),',',num2str(y(I),'%8.4f'),')'], ...
                            'color','k','fontweight','bold');
                        drawnow
                    end
                    %%% Select a knot if left-click is close to it:
                else
                    b=1;
                    %[xs ys] = splinefit([1;x;1],[0;y;0],0);%redundant?
                    try delete(t);end;
                    plot(xs,ys,'k', ...
                        [1;x],[0;y],'.k', ...
                        x(I),y(I),'xk','markersize',13)
                    Replot(); % Our additions
                    axis equal
                    axis([0 1 -.2 .2])
                    t=text(x(I)+deltxt,y(I)-deltxt, ...
                        ['(',num2str(x(I),'%8.4f'),',',num2str(y(I),'%8.4f'),')'], ...
                        'color','k','fontweight','bold');
                    drawnow
                end
                %%% Mouse right click:
            case 'alt'
                %%% Delete a knot if right-click is close to it:
                if V2<min([1e-4,mindist2])
                    L=L-1;
                    x=xx;
                    y=yy;
                    xredo=[];
                    yredo=[];
                    Lredo=[];
                    Iredo=[];
                    [xs ys] = splinefit([1;x;1],[0;y;0],0);
                    try delete(t);end;
                    plot(xs,ys,'k', ...
                        [1;x],[0;y],'.k','markersize',13)
                    Replot(); % Our additions
                    axis equal
                    axis([0 1 -.2 .2])
                    drawnow
                end
        end
    end

%%% @Up - what happens when a mouse button is released
    function Up(varargin);
        b=0;
    end

%%% @Move - what happens when the mouse moves
%%% (while holding the left button clicked for b=true)
    function Move(varargin)
        if b
            p=get(a,'currentpoint');
            x(I)=max([min([p(1),xmax]),xmin]);
            y(I)=max([min([p(3),ymax]),ymin]);
            xredo=[];
            yredo=[];
            [xs ys] = splinefit([1;x;1],[0;y;0],0);
            try delete(t);end;
            plot(xs,ys,'k', ...
                [1;x],[0;y],'.k', ...
                x(I),y(I),'xk','markersize',13)
            Replot(); % Our additions
            axis equal
            axis([0 1 -.2 .2])
            t=text(x(I)+deltxt,y(I)-deltxt, ...
                ['(',num2str(x(I),'%8.4f'),',',num2str(y(I),'%8.4f'),')'], ...
                'color','k','fontweight','bold');
            drawnow
        end
    end

%%% @Key - the various keyboard options
    function Key(varargin);
        if ~delta;delta=mean(abs(diff(y)));end
        % to be done: if varargin{2}.Modifier=='control'
        switch varargin{2}.Key
            %%% 'l' load a new .surf file
            case 'l'
                [filein,pathin]=uigetfile([pathin '*.surf']);
                set(h, 'Name', ['Wing Analysis Section Generator: ' filein]);
                y=load([pathin,filein]);
                x=y(2:end-1,1);
                y=y(2:end-1,2);
                L=length(x);
                I=(x-1).^2+y.^2; I=find(I==max(I)); I=I(1);
                Xbk=x;
                Ybk=y;
                %%% 's' save into a .surf file:
            case 's'
                dataout=[[1;x;1],[0;y;0]];
                [fileout,pathout]=uiputfile([pathin '*.surf']);
                save([pathout fileout],'dataout','-ascii')
                %%% 'b' backup configuration
            case 'p'
                Regraph()
            case 'b'
                Xbk=x;
                Ybk=y;
                disp('knot position backed up')
                %%% 't' restore last backup
            case 't'
                x=Xbk;
                y=Ybk;
                L=length(x);
                I=1;
                disp('knot position restored')
                %%% 'u' undo last action
            case 'u'
                if isempty(xundo)
                    disp('undo max reached')
                else
                    Lredo=[L,Lredo(1:min([length(Lredo),max_undo-1]))];
                    Iredo=[I,Iredo(1:min([length(Iredo),max_undo-1]))];
                    xredo=[[x;0*(length(x)+1:Lmax)'],xredo(:,1:min([size(xredo,2),max_undo-1]))];
                    yredo=[[y;0*(length(y)+1:Lmax)'],yredo(:,1:min([size(yredo,2),max_undo-1]))];
                    L=Lundo(1);
                    I=Iundo(1);
                    x=xundo(1:L,1);
                    y=yundo(1:L,1);
                    Lundo=Lundo(2:end);
                    Iundo=Iundo(2:end);
                    xundo=xundo(:,2:end);
                    yundo=yundo(:,2:end);
                end
                %%% 'r' redo - cancel last undo
            case 'r'
                if isempty(xredo)
                    disp('last action reached')
                else
                    Lundo=[L,Lundo(1:min([length(Lundo),max_undo-1]))];
                    Iundo=[I,Iundo(1:min([length(Iundo),max_undo-1]))];
                    xundo=[[x;0*(length(x)+1:Lmax)'],xundo(:,1:min([size(xundo,2),max_undo-1]))];
                    yundo=[[y;0*(length(x)+1:Lmax)'],yundo(:,1:min([size(yundo,2),max_undo-1]))];
                    L=Lredo(1);
                    I=Iredo(1);
                    x=xredo(1:L,1);
                    y=yredo(1:L,1);
                    Lredo=Lredo(2:end);
                    Iredo=Iredo(2:end);
                    xredo=xredo(:,2:end);
                    yredo=yredo(:,2:end);
                end
                %%% 'z' zoomed view
            case 'z'
                p=get(a,'currentpoint');
                axisZ=[p(1)-.05 p(1)+.05 p(3)-.03 p(3)+.03];
                try delete(t);end;
                set(h,'WindowKeyPressFcn',@emptyFunctionHandle,...
                    'windowbuttondownfcn',@emptyFunctionHandle,...
                    'WindowButtonMotionFcn',@emptyFunctionHandle,...
                    'WindowButtonUpFcn',@emptyFunctionHandle)
                hZ=figure('units','normalized',...
                    'outerposition',[.3 .3 1.05*Res(4)/Res(3) .7],...
                    'DockControls','off',...
                    'MenuBar','none',...
                    'name','zoomed view',...
                    'NumberTitle','off',...
                    'WindowKeyPressFcn',@KeyZ,...
                    'windowbuttondownfcn',@DownZ,...
                    'WindowButtonMotionFcn',@MoveZ,...
                    'WindowButtonUpFcn',@UpZ,...
                    'DeleteFcn',@figDeleteZ);
                aZ=axes('position',[.10,.10,.87,.87]);
                plot(xs,ys,'k', ...
                    [1;x],[0;y],'.k', ...
                    x(I),y(I),'xk','markersize',13)
                Replot(); % Our additions
                axis equal
                axis(axisZ)
                drawnow
                %%% press 'd' to change the rate of displacement of a knot
                %%% when using the arrow keys instead of holding left mouse
                %%% button
            case 'd'
                delta=str2double(inputdlg('enter delta'));
                deltaZ=.2*delta;
            case 'leftarrow'
                x(I)=max([x(I)-delta,xmin]);
            case 'rightarrow'
                x(I)=min([x(I)+delta,xmax]);
            case 'downarrow'
                y(I)=max([y(I)-delta,ymin]);
            case 'uparrow'
                y(I)=min([y(I)+delta,ymax]);
        end
        [xs ys] = splinefit([1;x;1],[0;y;0],0);
        set(0, 'CurrentFigure', h)
        try delete(t);end;
        plot(xs,ys,'k', ...
            [1;x],[0;y],'.k', ...
            x(I),y(I),'xk','markersize',13)
        Replot(); % Our additions
        axis equal
        axis([0 1 -.2 .2])
        t=text(x(I)+deltxt,y(I)-deltxt, ...
            ['(',num2str(x(I),'%8.4f'),',',num2str(y(I),'%8.4f'),')'], ...
            'color','k','fontweight','bold');
        drawnow
    end


%%%%%%%%%%%%%% FUNCTIONS FOR ZOOMED FIGURE %%%%%%%%%%%%%%
%%% @Down - what happens when a mouse button is pressed
    function DownZ(varargin);
        xundo=[[x;0*(length(x)+1:Lmax)'],xundo(:,1:min([size(xundo,2),max_undo-1]))];
        yundo=[[y;0*(length(y)+1:Lmax)'],yundo(:,1:min([size(yundo,2),max_undo-1]))];
        Lundo=[L,Lundo(1:min([length(Lundo),max_undo-1]))];
        Iundo=[I,Iundo(1:min([length(Iundo),max_undo-1]))];
        p=get(aZ,'currentpoint');
        [V2 I]=min((x-p(1)).^2+(y-p(3)).^2);
        xx=x;
        yy=y;
        xx(I)=[];
        yy(I)=[];
        mindist2=min((xx-x(I)).^2+(yy-y(I)).^2);
        switch varargin{1}.SelectionType
            %%% Mouse left-click:
            case 'normal'
                %%% Add a knot if left-click is close to aerofoil contour:
                if V2>min(1e-6,mindist2)
                    [xs ys] = splinefit([1;x;1],[0;y;0],1);
                    ppk = 100; % needs to be the same in 'splinefit.m'
                    [V2 Is]=min((xs-p(1)).^2+(ys-p(3)).^2);
                    if V2<1e-6
                        xI=xs(Is);yI=ys(Is);
                        I = ceil(Is/ppk);
                        L=L+1;
                        Lmax=max([L,Lmax]);
                        x(I+1:L)=x(I:end);
                        y(I+1:L)=y(I:end);
                        x(I)=xI;
                        y(I)=yI;
                        xundo=[xundo;0*(size(xundo,1)+1:Lmax)'*(1:size(xundo,2))];
                        yundo=[yundo;0*(size(yundo,1)+1:Lmax)'*(1:size(yundo,2))];
                        xredo=[];
                        yredo=[];
                        b=1;
                        [xs ys] = splinefit([1;x;1],[0;y;0],0);%redundant?
                        set(0, 'CurrentFigure', h)
                        plot(xs,ys,'k', ...
                            [1;x],[0;y],'.k', ...
                            x(I),y(I),'xk','markersize',13);last_index
                        Replot(); % Our additions
                        axis equal
                        axis([0 1 -.2 .2])
                        %drawnow
                        figure(hZ)
                        try delete(t);end;
                        plot(xs,ys,'k', ...
                            [1;x],[0;y],'.k', ...
                            x(I),y(I),'xk', ...
                            'markersize',13);
                        Replot(); % Our additions
                        axis equal
                        axis(axisZ)
                        t=text(x(I)+deltxtZ,y(I)-deltxtZ, ...
                            ['(',num2str(x(I),'%8.4f'),',',num2str(y(I),'%8.4f'),')'], ...
                            'color','k','fontweight','bold');
                        drawnow
                    end
                    %%% Select a knot if left-click is close to it:
                else
                    b=1;
                    [xs ys] = splinefit([1;x;1],[0;y;0],0);%redundant?
                    set(0, 'CurrentFigure', h)
                    plot(xs,ys,'k', ...
                        [1;x],[0;y],'.k', ...
                        x(I),y(I),'xk', ...
                        'markersize',13);
                    Replot(); % Our additions
                    axis equal
                    axis([0 1 -.2 .2])
                    %drawnow
                    figure(hZ)
                    try delete(t);end;
                    plot(xs,ys,'k', ...
                        [1;x],[0;y],'.k', ...
                        x(I),y(I),'xk', ...
                        'markersize',13);
                    Replot(); % Our additions
                    axis equal
                    axis(axisZ)
                    t=text(x(I)+deltxtZ,y(I)-deltxtZ, ...
                        ['(',num2str(x(I),'%8.4f'),',',num2str(y(I),'%8.4f'),')'], ...
                        'color','k','fontweight','bold');
                    drawnow
                end
                %%% Mouse right click:
            case 'alt'
                %%% Delete a knot if right-click is close to it:
                if V2<min([1e-6,mindist2])
                    L=L-1;
                    x=xx;
                    y=yy;
                    xredo=[];
                    yredo=[];
                    [xs ys] = splinefit([1;x;1],[0;y;0],0);
                    set(0, 'CurrentFigure', h)
                    plot(xs,ys,'k', ...
                        [1;x],[0;y],'.k', ...
                        'markersize',13);
                    Replot(); % Our additions
                    axis equal
                    axis([0 1 -.2 .2])
                    %drawnow
                    figure(hZ)
                    try delete(t);end;
                    plot(xs,ys,'k', ...
                        [1;x],[0;y],'.k', ...
                        'markersize',13);
                    Replot(); % Our additions
                    axis equal
                    axis(axisZ)
                    drawnow
                end
        end
    end

%%% @Up - what happens when a mouse button is released
    function UpZ(varargin);
        b=0;
    end

%%% @Move - what happens when the mouse moves
%%% (while holding the left button clicked for b=true)
    function MoveZ(varargin)
        p=get(aZ,'currentpoint');
        if b
            x(I)=max([min([p(1),xmax]),xmin]);
            y(I)=max([min([p(3),ymax]),ymin]);
            xredo=[];
            yredo=[];
            [xs, ys] = splinefit([1;x;1],[0;y;0],1);
            set(0, 'CurrentFigure', h)
            plot(xs,ys,'k', ...
                [1;x],[0;y],'.k', ...
                x(I),y(I),'xk','markersize',13);
            Replot(); % Our additions
            axis equal
            axis([0 1 -.2 .2])
            %drawnow
            set(0, 'CurrentFigure', hZ)
            try delete(t);end;
            plot(xs,ys,'k', ...
                [1;x],[0;y],'.k', ...
                x(I),y(I),'xk', ...
                'markersize',13);
           Replot(); % Our additions
            axis equal
            axis(axisZ)
            t=text(x(I)+deltxtZ,y(I)-deltxtZ, ...
                ['(',num2str(x(I),'%8.4f'),',',num2str(y(I),'%8.4f'),')'], ...
                'color','k','fontweight','bold');
            drawnow
        end
    end

%%% @Key - the various keyboard options
    function KeyZ(varargin);
        if ~delta;delta=mean(abs(diff(y)));end
        % to be done: if varargin{2}.Modifier=='control'
        switch varargin{2}.Key
            %%% 'u' undo last action
            case 'u'
                if isempty(xundo)
                    disp('undo max reached')
                else
                    Lredo=[L,Lredo(1:min([length(Lredo),max_undo-1]))];
                    Iredo=[I,Iredo(1:min([length(Iredo),max_undo-1]))];
                    xredo=[[x;0*(length(x)+1:Lmax)'],xredo(:,1:min([size(xredo,2),max_undo-1]))];
                    yredo=[[y;0*(length(y)+1:Lmax)'],yredo(:,1:min([size(yredo,2),max_undo-1]))];
                    L=Lundo(1);
                    I=Iundo(min([length(Iundo),2]));
                    x=xundo(1:L,1);
                    y=yundo(1:L,1);
                    Lundo=Lundo(2:end);
                    Iundo=Iundo(2:end);
                    xundo=xundo(:,2:end);
                    yundo=yundo(:,2:end);
                end
                %%% 'r' redo - cancel last undo
            case 'r'
                if isempty(xredo)
                    disp('last action reached')
                else
                    Lundo=[L,Lundo(1:min([length(Lundo),max_undo-1]))];
                    Iundo=[I,Iundo(1:min([length(Iundo),max_undo-1]))];
                    xundo=[[x;0*(length(x)+1:Lmax)'],xundo(:,1:min([size(xundo,2),max_undo-1]))];
                    yundo=[[y;0*(length(x)+1:Lmax)'],yundo(:,1:min([size(yundo,2),max_undo-1]))];
                    L=Lredo(1);
                    I=Iredo(1);
                    x=xredo(1:L,1);
                    y=yredo(1:L,1);
                    Lredo=Lredo(2:end);
                    Iredo=Iredo(2:end);
                    xredo=xredo(:,2:end);
                    yredo=yredo(:,2:end);
                end
            case 'z'
                close(hZ)
                set(h,'WindowKeyPressFcn',@Key,...
                    'windowbuttondownfcn',@Down,...
                    'WindowButtonMotionFcn',@Move,...
                    'WindowButtonUpFcn',@Up)
                return
                %%% press 'd' to change the rate of displacement of a knot
                %%% when using the arrow keys instead of holding left mouse
                %%% button
            case 'd'
                delta=str2double(inputdlg('enter delta'));
                deltaZ=.2*delta;
            case 'leftarrow'
                x(I)=max([x(I)-delta,xmin]);
            case 'rightarrow'
                x(I)=min([x(I)+delta,xmax]);
            case 'downarrow'
                y(I)=max([y(I)-delta,ymin]);
            case 'uparrow'
                y(I)=min([y(I)+delta,ymax]);
        end
        if I<1
            I=1;
        elseif I>L
            I=L;
        end
        [xs ys] = splinefit([1;x;1],[0;y;0],1);
        set(0, 'CurrentFigure', h)
        plot(xs,ys,'k', ...
            [1;x],[0;y],'.k', ...
            x(I),y(I),'xk', ...
            'markersize',13);
        Replot(); % Our additions
        axis equal
        axis([0 1 -.2 .2])
        %drawnow
        set(0, 'CurrentFigure', hZ)
        try delete(t);end;
        plot(xs,ys,'k', ...
            [1;x],[0;y],'.k', ...
            x(I),y(I),'xk', ...
            'markersize',13);
        Replot(); % Our additions
        axis equal
        axis(axisZ)
        t=text(x(I)+deltxtZ,y(I)-deltxtZ, ...
            ['(',num2str(x(I),'%8.4f'),',',num2str(y(I),'%8.4f'),')'], ...
            'color','k','fontweight','bold');
        drawnow
    end

    function figDelete(varargin)
        try close(hZ);end;
    end

    function figDeleteZ(varargin)
        set(h,'WindowKeyPressFcn',@Key,...
            'Windowbuttondownfcn',@Down,...
            'WindowButtonMotionFcn',@Move,...
            'WindowButtonUpFcn',@Up)
        return
    end

%%%% empty function to make figure 'h' inactive while 'hZ' is active
    function emptyFunctionHandle(varargin)
    end

    % function to change Re callable by radio buttons
    function ReSelection(~, event)
        Re = event.NewValue.UserData;
        disp(['Re changed to ', num2str(Re)])
        Replot()
    end
    
    function Setnp(src, ~)
        np = str2num(src.String);
        disp(['np changed to ' num2str(np)])
        Replot()
    end

    function Setalpha(src, ~)
        alpha = str2num(src.String);
        disp(['alpha changed to ' num2str(alpha)])
        Replot()
    end

    function Setalphaswp(src, ~)
        newStr = split(src.String, ':');
        start = str2num(newStr{1});
        step = str2num(newStr{2});
        stop = str2num(newStr{3});
        alphaswp = start:step:stop;
        disp('alphaswp changed to ')
        disp(alphaswp)
        Replot()
    end

    function Replot() % this is for the live updating while we move
        
    [x_foil, y_foil, cp_foil, ~, ~, ~, iss] = foilsolve([1;x;1],[0;y;0], np, Re, alpha, alphaswp);
    %[x_cam, y_cam, max_thicc, max_thicc_position] = cambersolve(x_foil, y_foil);
    [xspln, yspln] = splinefit ( x, y, np*5 );
    rte = sqrt((xspln-1).^2 + yspln.^2);
    indle = find(rte==max(rte));
    indle = indle(1);  % in case of double match
    cawd = rte(indle);
    %scale and move te to (0,0)
    x1 = (x_foil - 1) * cawd;
    y1 = y_foil * cawd;
    % rotate to correct position
    coz = 1-xspln(indle);
    zin = yspln(indle);
    rotmat = [coz, zin; -zin, coz]/cawd;
    x2y2 = rotmat * [x1;y1];
    x_plot = x2y2(1,:) + 1;
    y_plot = x2y2(2,:);
    
    %downstram - upstream
    cp_foil_grad = [cp_foil(1:iss(1)) - cp_foil(2:iss(1)+1), cp_foil(iss(1)+1:np+1) - cp_foil(iss(1):np)];
    
    % Plot things ontop of WASG
    dd = zeros(size(x_plot)); % dummy required by surface
    col = cp_foil_grad; % colour according to cp
    hold on
    surface([x_plot;x_plot],[y_plot;y_plot],[dd;dd],[col;col],...
        'facecol','no','edgecol','interp','linew',2);
    %colormap(h, [0 1 0; 1 1 0; 1 0 0]);
    hold on
    for im = 1:9
        if iss(im) ~= 0
           plot(x_plot(iss(im)), y_plot(iss(im)), imarkers(im),...
               'Markersize', 10, 'markerfacecolor', 'm');
        end
    end
    hold off
    %[x_cam, y_cam, max_thicc, max_thicc_position] = cambersolve(x_foil, y_foil);
    %plot(x_cam,y_cam, '--') % want to get thickness, hence camber etc...
    %text(0.9,-0.15,['Max thicc: ' num2str(round(max_thicc)) '%'])
    %text(0.9,-0.16,['At position x/c: ' num2str(round(max_thicc_position,2))])
    end

    function Regraph() % this happens when we ask for it
        [x_foil, y_foil, cp_foil, theta_foil, cl_foil, cd_foil, iss] = foilsolve([1;x;1],[0;y;0], np, Re, alpha, alphaswp);
        wasgplot(x_foil,cp_foil,filein,alpha,Re,alphaswp,cl_foil,cd_foil,theta_foil,iss)
        figure(h)
    end

end