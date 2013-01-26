RandomNumbers = {}
RandomNumbers.count = 1000
function RandomNumbers.new(cols,rows,size,padding)
    pages = pages + 1
    local page = {}
    page.number = pages
    for y = 1,rows do
        for x=1,cols do
            RandomNumbers.count = RandomNumbers.count + 1
            local e = RandomNumbers.count -- så att vi kan använda den i actionen
            local num = y*cols+x-cols
            local nx = (x-1) * size + size/2 + padding*x + (page.number-1) * blockSize.width
            local ny = (y-1) * size + size/2 + padding*y
            cm:registerComponent(e,PositionComponent.new(nx,ny))
            local sound = SoundManager.Load("assets/numbers/sound/"..num..".wav")
            if num>16 then
                cm:registerComponent(e,GraphicsStaticAtlasComponent.new(size,size,"assets/numbers/17_20.png",mainLayer,true,num-16))
            else
                cm:registerComponent(e,GraphicsStaticAtlasComponent.new(size,size,"assets/numbers/1_16.png",mainLayer,true,num))
            end
            cm:registerComponent(e,CollisionComponent.new(nx,ny,size,size,
            function()
                local graphics = cm:getComponentOfTypeOnEntity(e,"graphics")
                local pos = cm:getComponentOfTypeOnEntity(e,"position")
                local thread = MOAICoroutine.new()
                thread:run(function()
                    animating = true
                    local sf = 540 / graphics.width
                    graphics.prop:setPriority(500)
                    wait(graphics.prop:seekLoc ( activePage*width - width/2, height/2, 1.0,MOAIEaseType.SHARP_EASE_OUT ))
                    wait(graphics.prop:seekScl ( sf, -sf, 1.0,MOAIEaseType.SHARP_EASE_IN ))
                    SoundManager.Play(sound)
                    wait(graphics.prop:seekScl ( 1, -1, 1.0,MOAIEaseType.SHARP_EASE_OUT ))
                    animating = false
                    wait(graphics.prop:seekLoc ( pos.x, pos.y, 1.0,MOAIEaseType.SHARP_EASE_IN ))
                    graphics.prop:setPriority(1)
                end)
            end))
            tm:RegisterEntity("page"..page.number,e)
        end
    end

    function page:onExiting()
        print("exiting")
    end

    function page:onEntering()
        print("entering")
    end

    function page:onExit()
        print("EXIT - randomizing",page.number)
        Shuffle(page.number)
    end

    function page:onEnter()
        print("ENTER",page.number)
    end

    Shuffle(page.number)
    return page
end

function Shuffle(pageNumber)
    local randomIcons = tm:GetEntitiesWithTag("page"..pageNumber)
    for i=1,#(randomIcons or {}) do
        local r = math.random(1,#randomIcons)
        local pos = cm:getComponentOfTypeOnEntity(randomIcons[i],"position")
        local rpos = cm:getComponentOfTypeOnEntity(randomIcons[r],"position")
        pos.x,rpos.x = rpos.x,pos.x
        pos.y,rpos.y = rpos.y,pos.y
    end
    GraphicsSystem.Update(cm)
end
