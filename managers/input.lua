local msx,msy = 0,0
local down = false
local sx = 0
activePage = 1
animating = false
local moving = false
local double = false
local mf = 0 -- mouseframe
local df = 0 -- downframe
local lastActivePage = -1
function MouseDown(mouseDown)
    down = mouseDown
    print("DOWN")
    if down then
        sx = msx
        moving =  MOAISim.getElapsedFrames()<=mf+10
        double = MOAISim.getElapsedFrames()<=df+30
        df = MOAISim.getElapsedFrames()
        print("drag",mf,MOAISim.getElapsedFrames())
    end

    print("___",msx,msy)

    local cx,cy,cz = camera:getLoc()

    -- glid till närmaste sida
    if not down then
        print("moving",cx,activePage,lastActivePage)
        local closestPage = math.floor(cx/blockSize.width+0.5) + 1
        lastActivePage = activePage
        if closestPage>0 and closestPage<=pages then
            activePage = closestPage
            GuiActivePage(activePage)
        end

        if activePage~=lastActivePage then
            pageItems[activePage].onEntering()
            pageItems[lastActivePage].onExiting()
        end

        local thread = MOAICoroutine.new()
        thread:run(function()
            wait(camera:seekLoc((activePage-1)*blockSize.width,cy,cz,0.3,MOAIEaseType.SHARP_EASE_IN))

            if activePage~=lastActivePage then
                pageItems[activePage].onEnter()
                pageItems[lastActivePage].onExit()
            end

        end)
    end


    -- kolla kollisioner
    if down and not moving and not animating then
        -- lock
        local lock = cm:getComponentOfTypeOnEntity(9999,"collision")
        if PointInCenteredRectangle(msx,msy,lock.x,lock.y,lock.width,lock.height) and double==true then
            lock.action()
        else
            local numbers = tm:GetEntitiesWithTag("page"..activePage)
            for i=1,#numbers do
                local col = cm:getComponentOfTypeOnEntity(numbers[i],"collision") -- numbers[i]
                if col~=nil and PointInCenteredRectangle(msx+(blockSize.width*(activePage-1)),msy,col.x,col.y,col.width,col.height) then
                    col.action()
                    break
                end
            end
        end
    end

    if double then
        df = -1
    end

end


function MouseMove(mouseX,mouseY)
    if animating then return end
    msx,msy = mouseX*blockSize.div,mouseY*blockSize.div
    mf = MOAISim.getElapsedFrames()

    if down and sx>-1 and not locked then
        local cx,cy,cz = camera:getLoc()
        camera:seekLoc((activePage-1)*blockSize.width-(msx-sx),cy,cz)
    end
end

function TouchClick(eventType, idx, mouseX, mouseY, tapCount)
    msx,msy = mouseX,mouseY

    if eventType == MOAITouchSensor.TOUCH_MOVE then
        --print("touch move",MOAISim.getElapsedFrames())
        down = true
        --print(msx,msy)
        MouseMove(msx,msy)
    elseif eventType == MOAITouchSensor.TOUCH_DOWN then -- drag
        --print("touch down",MOAISim.getElapsedFrames())
        if locked then
            MouseDown(true)
        end
        sx = msx * blockSize.div
        --MouseDown(true)
    elseif eventType == MOAITouchSensor.TOUCH_UP then
        --print("touch up")
        if not locked then
            MouseDown(true)
        end
        MouseDown(false)
    end


end

device = nil
if MOAIInputMgr.device.mouseLeft then
    MOAIInputMgr.device.mouseLeft:setCallback(MouseDown)
    MOAIInputMgr.device.pointer:setCallback(MouseMove)
    device = "PC"
end

if MOAIInputMgr.device.touch then
    MOAIInputMgr.device.touch:setCallback(TouchClick)
    device = "IOS"
end

