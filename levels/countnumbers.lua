CountNumbers = {}
CountNumbers.count = 3000
function CountNumbers.new(cols,rows,size,padding)
    pages = pages + 1
    local page = {}
    page.number = pages
    page.size = size
    page.padding = padding
    page.numItems = cols * rows
    page.lastSelected = -1
    page.lastItem = 0
    for y = 1,rows do
        for x=1,cols do
            CountNumbers.count = CountNumbers.count + 1
            local e = CountNumbers.count -- så att vi kan använda den i actionen
            page.lastItem = e
            local num = y*cols+x-cols
            local nx = (x-1) * size + size/2 + padding*x + (page.number-1) * blockSize.width
            local ny = (y-1) * size + size/2 + padding*y
            cm:registerComponent(e,PositionComponent.new(nx,ny))
            cm:registerComponent(e,SelectedEntityComponent.new())
            if num>16 then
                cm:registerComponent(e,GraphicsStaticAtlasComponent.new(size,size,"assets/numbers/17_20.png",mainLayer,true,num-16))
            else
                cm:registerComponent(e,GraphicsStaticAtlasComponent.new(size,size,"assets/numbers/1_16.png",mainLayer,true,num))
            end
            cm:registerComponent(e,CollisionComponent.new(nx,ny,size,size,
            function()
                animating = true
                if (e==page.lastSelected+1 or page.lastSelected==-1) and e~=page.lastItem then
                    local graphics = cm:getComponentOfTypeOnEntity(e,"graphics")
                    local sf = (page.size+page.padding) / graphics.width
                    graphics.prop:seekScl ( sf, -sf, 1.0,MOAIEaseType.SHARP_EASE_IN )
                    page.lastSelected = e
                else
                    local numbers = tm:GetEntitiesWithTag("page"..page.number)
                    for i=1,#numbers do
                        local graph = cm:getComponentOfTypeOnEntity(numbers[i],"graphics")
                        graph.prop:seekScl ( 1, -1, 1.0,MOAIEaseType.SHARP_EASE_IN )
                    end
                    page.lastSelected = -1
                end

                if e==page.lastItem then
                    print("winner!")
                end


                animating = false
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
        print("EXIT",page.number)
        local numbers = tm:GetEntitiesWithTag("page"..page.number)
        for i=1,#numbers do
            local graph = cm:getComponentOfTypeOnEntity(numbers[i],"graphics")
            graph.prop:seekScl ( 1, -1, 1.0,MOAIEaseType.SHARP_EASE_IN )
        end
        page.lastSelected = -1
    end

    function page:onEnter()
        print("ENTER",page.number)

    end

    return page
end

