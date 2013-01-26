PurchaseApp = {}
function PurchaseApp.new()
    pages = pages + 1
    local page = {}
    page.number = pages
    local e = 5000 -- så att vi kan använda den i actionen
    local nx = (page.number-1) * width + width/2
    cm:registerComponent(e,PositionComponent.new(nx,256))
    cm:registerComponent(e,GraphicsStaticComponent.new(512,512,"assets/information.png",mainLayer,false))

    cm:registerComponent(e+1,PositionComponent.new(nx,256))
    cm:registerComponent(e+1,GraphicsStaticComponent.new(64,64,"assets/kop.png",mainLayer,false))
    cm:registerComponent(e+1,CollisionComponent.new(nx,256,64,64,
    function()
        print("köper")
        if purchased == true then return end
        Purchase()
    end))
    tm:RegisterEntity("page"..pages,e+1)

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
