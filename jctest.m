plot(1:10,1:10)

function myButtonTest()
PushButton = uicontrol(figure(2),'Style', 'push', 'String', 'Reload plots','Position', [300 10 120 30],'CallBack', @PushB);

replotting = 0; 
    
function PushB(source,event)
replotting = true;
disp(replotting)
replotting = false;
disp(replotting)
end
end