Numbers = {}
Numbers.count = 0
function Numbers.new(cols,rows,size,padding)
    pages = pages + 1
    local page = {}
    page.number = pages

    for y = 1,rows do
        for x=1,cols do
            Numbers.count = Numbers.count + 1
            local e = Numbers.count -- så att vi kan använda den i actionen
            local num = y*cols+x-cols
            local nx = (x-1) * size + size/2 + padding*x + (page.number-1) * blockSize.width
            local ny = (y-1) * size + size/2 + padding*y
            cm:registerComponent(e,PositionComponent.new(nx,ny))
            -- ljud
            local sound = SoundManager.Load("assets/numbers/sound/"..num..".wav")
            if num>16 then
                cm:registerComponent(e,GraphicsStaticAtlasComponent.new(size,size,"assets/numbers/17_20.png",mainLayer,true,num-16))
            else
                cm:registerComponent(e,GraphicsStaticAtlasComponent.new(size,size,"assets/numbers/1_16.png",mainLayer,true,num))
            end
            nx = (x-1) * size + size/2 + padding*x + (page.number-1) * width


            cm:registerComponent(e,CollisionComponent.new(nx,ny,size,size,
            function()
                local graphics = cm:getComponentOfTypeOnEntity(e,"graphics")
                local pos = cm:getComponentOfTypeOnEntity(e,"position")
                local thread = MOAICoroutine.new()
                thread:run(function()
                    animating = true
                    local sf = (blockSize.width-100) / graphics.width
                    print("pos",pos.x)
                    graphics.prop:setPriority(500)
                    wait(graphics.prop:seekLoc ( activePage*blockSize.width - blockSize.width/2, blockSize.height/2, 1.0,MOAIEaseType.SHARP_EASE_OUT ))
                    wait(graphics.prop:seekScl ( sf, -sf, 1.0,MOAIEaseType.SHARP_EASE_IN ))
                    SoundManager.Play(sound)
                    wait(graphics.prop:seekScl ( 1, -1, 1.0,MOAIEaseType.SHARP_EASE_OUT ))
                    animating = false
                    wait(graphics.prop:seekLoc ( pos.x, pos.y, 1.0,MOAIEaseType.SHARP_EASE_IN ))
                    graphics.prop:setPriority(1)

                end)
            end))
            tm:RegisterEntity("page"..pages,Numbers.count)
        end
    end

    function page:onExiting()
        print("exiting")
    end

    function page:onEntering()
        print("entering")
    end

    function page:onExit()
        print("EXIT",page.number)
    end

    function page:onEnter()
        print("ENTER",page.number)
    end

    return page
end
