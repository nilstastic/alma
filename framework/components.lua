PositionComponent = {}
function PositionComponent.new(x,y)
    local c = {}
    c.name = "position"
    c.x = x or 0
    c.y = y or 0
    return c
end

CollisionComponent = {}
function CollisionComponent.new(x,y,width,height,action)
    local c = {}
    c.name = "collision"
    c.x = x
    c.y = y
    c.width = width
    c.height = height
    c.action = action
    return c
end

SelectedEntityComponent = {}
function SelectedEntityComponent.new(e)
    local c = {}
    c.name = "selectedentity"
    c.e = e or -1
    return c
end


GraphicsStaticComponent = {}
function GraphicsStaticComponent.new(width,height,texture,layer,mipmap)
    local c = {}
    c.name = "graphics"
    c.sprite = MOAIGfxQuad2D.new()
    c.width = width
    c.height = height

    texture = TextureManager.Get(texture)
    if mipmap then
        texture:setFilter (MOAITexture.GL_LINEAR_MIPMAP_LINEAR )
    end

    c.sprite:setTexture(texture)
    c.sprite:setRect(-width/2,-width/2,height/2,height/2)
    c.prop = MOAIProp2D.new()
    c.prop:setDeck(c.sprite)
    c.prop:setScl(1, -1)
    c.prop:setLoc(0,0)
    layer:insertProp(c.prop)
    return c
end

GraphicsStaticAtlasComponent = {}
function GraphicsStaticAtlasComponent.new(width,height,texture,layer,mipmap,index)
    x,y = x or 0, y or 0
    local c = {}
    c.name = "graphics"
    c.sprite =  MOAITileDeck2D.new ()

    c.width = width
    c.height = height

    texture = TextureManager.Get(texture)
    if mipmap then
        texture:setFilter (MOAITexture.GL_LINEAR_MIPMAP_LINEAR )
    end

    c.sprite:setTexture(texture)
    c.sprite:setRect(-width/2,-width/2,height/2,height/2)
    c.sprite:setSize(4,4)
    c.prop = MOAIProp2D.new()

    c.prop:setDeck(c.sprite)
    c.prop:setScl(1, -1)
    c.prop:setLoc(0,0)
    c.prop:setIndex(index)
    layer:insertProp(c.prop)
    return c
end