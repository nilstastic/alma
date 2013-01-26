print("a")

require "managers.assets"
--local caaklj = TextureManager.Get("assets/numbers/1_16.png")

require "framework.managers"
require "framework.components"
require "framework.systems"
require "collision"
require "helpers"

require "managers.input"
require "managers.sound"

width,height = MOAIEnvironment.horizontalResolution or 640, MOAIEnvironment.verticalResolution or 960
--width,height = 640,  960

print( MOAIEnvironment.horizontalResolution or "nothing", MOAIEnvironment.verticalResolution or "nothing")

-- profiler för olika storlekar
sizeTable = {}
sizeTable[640] = {}
sizeTable[640].large = 180
sizeTable[640].largepadding = 25
sizeTable[640].small = 135
sizeTable[640].smallpadding = 25
sizeTable[640].width = 640
sizeTable[640].height = 960
sizeTable[640].div = 1

sizeTable[320] = {}
sizeTable[320].large = 180
sizeTable[320].largepadding = 20
sizeTable[320].small = 135
sizeTable[320].smallpadding = 25
sizeTable[320].height = 960
sizeTable[320].width = 640
sizeTable[320].div = 2


blockSize = sizeTable[width]


MOAISim.openWindow("alma",width,height)

viewport = MOAIViewport.new()
viewport:setSize(width,height)
viewport:setScale(width,-height)
viewport:setOffset(-1,1)

mainLayer = MOAILayer2D.new()
MOAISim.pushRenderPass(mainLayer)
mainLayer:setViewport(viewport)

guiLayer = MOAILayer2D.new()
MOAISim.pushRenderPass(guiLayer)
guiLayer:setViewport(viewport)

camera = MOAICamera.new ()
camera:setLoc (0,0,camera:getFocalLength(640))
mainLayer:setCamera(camera)

SoundManager.Init()


cm = ComponentManager.new()
tm = TagManager.new()

require "levels.numbers"
require "levels.randomnumbers"
require "levels.repeatnumbers"
require "levels.countnumbers"
require "levels.purchaseapp"
pages = 0
pageItems = {}
pageItems[1] = Numbers.new(3,3,blockSize.large,blockSize.largepadding)
pageItems[2] = Numbers.new(4,5,blockSize.small,blockSize.smallpadding)
pageItems[3] = PurchaseApp.new()


-- page dots
local dotStart = 4000
function GenerateDots(from,to)
    for i = from,to do
        cm:registerComponent(dotStart+i,PositionComponent.new(i*20+20,height-64))
        cm:registerComponent(dotStart+i,GraphicsStaticComponent.new(8,8,"assets/dot.png",guiLayer,false))
        tm:RegisterEntity("dot",dotStart+i)
    end
end

function GuiActivePage(pageNumber)
    local dots = tm:GetEntitiesWithTag("dot")
    for i=1,#dots do
        if i==pageNumber then
            cm:getComponentOfTypeOnEntity(dots[i],"graphics").prop:setColor(1,1,1,1)
        else
            cm:getComponentOfTypeOnEntity(dots[i],"graphics").prop:setColor(0.5,0.5,0.5,1)
        end
    end
end

GenerateDots(1,pages)
GuiActivePage(1)


-- lås

function CreateLock()
    locked = true
    cm:registerComponent(9999,PositionComponent.new(width-64,height-64))
    cm:registerComponent(9999,GraphicsStaticComponent.new(64,64,"assets/locked.png",guiLayer,false))
    cm:registerComponent(9999,CollisionComponent.new(width-64,height-64,64,64,
        function()
            print("selected")
            ToggleLock()
        end
        ))
end

function ToggleLock()
    locked = locked==false
    print(locked)
    if locked then
        cm:getComponentOfTypeOnEntity(9999,"graphics").prop:setColor(1,1,1,1)
    else
        cm:getComponentOfTypeOnEntity(9999,"graphics").prop:setColor(0.5,0.5,0.5,1)
    end
end
CreateLock()
ToggleLock()


-- in app purchase
purchased = true
function Purchase()
    mainLayer:clear()
    guiLayer:clear()

    cm = ComponentManager.new()
    tm = TagManager.new()

    MOAISim.forceGarbageCollection()

    CreateLock()
    ToggleLock()

    local cx,cy,cz = camera:getLoc()
    camera:setLoc(0,cy,cz,0.1,MOAIEaseType.SHARP_EASE_IN)

    pages = 0
    pageItems = {}
    pageItems[1] = Numbers.new(3,3,blockSize.large,blockSize.largepadding)
    GraphicsSystem.Update(cm)
    pageItems[2] = Numbers.new(4,5,blockSize.small,blockSize.smallpadding)
    pageItems[3] = RandomNumbers.new(3,3,blockSize.large,blockSize.largepadding)
    pageItems[4] = RandomNumbers.new(4,5,blockSize.small,blockSize.smallpadding)
    --pageItems[5] = RepeatNumbers.new(3,3,blockSize.large,blockSize.largepadding)
    --pageItems[6] = RepeatNumbers.new(4,5,blockSize.small,blockSize.smallpadding)
    pageItems[5] = CountNumbers.new(3,3,blockSize.large,blockSize.largepadding)
    pageItems[6] = CountNumbers.new(4,5,blockSize.small,blockSize.smallpadding)

    activePage = 1
    GenerateDots(1,pages)
    GuiActivePage(1)
    purchased = true
    GraphicsSystem.Update(cm)
end

if purchased then
    Purchase()
end


print("z")
GraphicsSystem.Update(cm)
print("ö")

-- göra en köpsida som låser upp
-- spela in nya ljud
--