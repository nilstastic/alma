RepeatNumbers = {}
RepeatNumbers.count = 2000
function RepeatNumbers.new(cols,rows,size,padding)
    pages = pages + 1
    local page = {}
    page.number = pages
    page.selected = -1
    for y = 1,rows do
        for x=1,cols do
            RepeatNumbers.count = RepeatNumbers.count + 1
            local e = RepeatNumbers.count -- så att vi kan använda den i actionen
            local num = y*cols+x-cols
            local nx = (x-1) * size + size/2 + padding*x + (page.number-1) * blockSize.width
            local ny = (y-1) * size + size/2 + padding*y
            cm:registerComponent(e,PositionComponent.new(nx,ny))
            local sound = SoundManager.Load("assets/numbers/sound/"..num..".wav")
            cm:registerComponent(e,SelectedEntityComponent.new())
            if num>16 then
                cm:registerComponent(e,GraphicsStaticAtlasComponent.new(size,size,"assets/numbers/17_20.png",mainLayer,true,num-16))
            else
                cm:registerComponent(e,GraphicsStaticAtlasComponent.new(size,size,"assets/numbers/1_16.png",mainLayer,true,num))
            end
            cm:registerComponent(e,CollisionComponent.new(nx,ny,size,size,
            function(automatic)
                if not automatic then -- dvs det är en användare som klickat
                    if(page.selected==e) then
                        print("WINNER")
                        page.selected = -1
                    else
                        print("LOOSER")
                        page.selected = -1
                    end
                end

                local graphics = cm:getComponentOfTypeOnEntity(e,"graphics")
                local pos = cm:getComponentOfTypeOnEntity(e,"position")
                local thread = MOAICoroutine.new()
                thread:run(function()
                    animating = true
                    local sf = 540 / graphics.width
                    graphics.prop:setPriority(500)
                    wait(graphics.prop:seekLoc ( activePage*width - width/2, height/2, 1.0,MOAIEaseType.SHARP_EASE_OUT ),page)
                    wait(graphics.prop:seekScl ( sf, -sf, 1.0,MOAIEaseType.SHARP_EASE_IN ),page)
                    SoundManager.Play(sound)
                    wait(graphics.prop:seekScl ( 1, -1, 1.0,MOAIEaseType.SHARP_EASE_OUT ),page)
                    animating = false
                    wait(graphics.prop:seekLoc ( pos.x, pos.y, 1.0,MOAIEaseType.SHARP_EASE_IN ),page)
                    graphics.prop:setPriority(1)
                    ResetPage(page)
                    if page.number==activePage and page.selected==-1 and not animating and not page.exit then
                        print("AUTOMATIC TRIGGER")
                        TriggerRandomEntity(page)
                    end
                end)


            end))
            tm:RegisterEntity("page"..page.number,e)
        end
    end

    function page:onExit()
        print("EXIT",page.number)
        page.exit = true
        --ResetPage(page)

    end

    function page:onExiting()
        --ResetPage(page)
        print("exiting")
    end

    function page:onEntering()
        --ResetPage(page)
        print("entering")
    end

    function page:onEnter()
        page.exit = false
        print("ENTER",page.number)
        ResetPage(page)
        TriggerRandomEntity(page)
    end


    return page
end

function TriggerRandomEntity(page)
    local numbers = tm:GetEntitiesWithTag("page"..page.number)
    local randomEntity = numbers[math.random(1,#numbers)]
    page.selected = randomEntity
    cm:getComponentOfTypeOnEntity(randomEntity,"collision").action(true)
end

function ResetPage(page)
    local numbers = tm:GetEntitiesWithTag("page"..page.number)
    for i=1, #numbers do
        local graphics = cm:getComponentOfTypeOnEntity(numbers[i],"graphics")
        local pos = cm:getComponentOfTypeOnEntity(numbers[i],"position")
        graphics.prop:setScl ( 1, -1)
        graphics.prop:setPriority(1)
        graphics.prop:setLoc ( pos.x, pos.y)
    end
end