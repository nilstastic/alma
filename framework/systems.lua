GraphicsSystem = {}
function GraphicsSystem.Update(cm)
    local components = cm:getEntitiesWithComponent("graphics")
    for i=1,#(components or {}) do
        local pos = cm:getComponentOfTypeOnEntity(components[i],"position")
        local graphics = cm:getComponentOfTypeOnEntity(components[i],"graphics")
        graphics.prop:setLoc(pos.x,pos.y)
    end

    components = cm:getEntitiesWithComponent("collision")
    for i=1,#components do
        local pos = cm:getComponentOfTypeOnEntity(components[i],"position")
        local col = cm:getComponentOfTypeOnEntity(components[i],"collision")
        col.x,col.y = pos.x,pos.y
    end

end