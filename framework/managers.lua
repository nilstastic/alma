TagManager = {}
function TagManager.new()
    local tm = {}
    tm.entitiesWithTag = {}

    function tm:RegisterEntity(tag,e)
        if self.entitiesWithTag[tag] == nil then
            self.entitiesWithTag[tag] = {}
        end

        table.insert(self.entitiesWithTag[tag],e)
    end

    function tm:GetEntitiesWithTag(tag)
        return self.entitiesWithTag[tag]
    end

    return tm
end


ComponentManager = {}
function ComponentManager.new()
    local cm = {}
    cm.componentsOfType = {}
    cm.componentsOnEntity = {}
    cm.componentOfTypeOnEntity = {}
    cm.entitiesWithComponent = {}
    cm.entityOnComponent = {}
    --cm.components = {}

    function cm:registerComponent(e,c)
        if self.componentsOfType[c.name] == nil then
            self.componentsOfType[c.name] = {}
        end
        if self.componentsOnEntity[e] == nil then
            self.componentsOnEntity[e] = {}
        end
        if self.componentOfTypeOnEntity[e] == nil then
            self.componentOfTypeOnEntity[e] = {}
        end
        if self.entitiesWithComponent[c.name] == nil then
            self.entitiesWithComponent[c.name] = {}
        end

        table.insert(self.componentsOfType[c.name],c)
        table.insert(self.componentsOnEntity[e],c)
        self.componentOfTypeOnEntity[e][c.name] = c
        table.insert(self.entitiesWithComponent[c.name],e)
        self.entityOnComponent[c] = e
    end

    -- components by type
    function cm:getComponentsOfType(c)
        return self.componentsOfType[c]
    end

    -- components an an entity
    function cm:getComponentsOnEntity(e)
        return self.componentsOnEntity[e]
    end

    -- component of a specific type on an entity
    function cm:getComponentOfTypeOnEntity(e,c)
        return cm.componentOfTypeOnEntity[e][c]
    end

    function cm:getEntitiesWithComponent(c)
        return cm.entitiesWithComponent[c]
    end

    function cm:getEntityWithComponent(c)
        return cm.entityOnComponent[c]
    end

    function cm:entityHasComponent(e,c)
        return cm.componentOfTypeOnEntity[e][c]~=nil
    end

    function cm:removeComponent(c)
        local e = cm:getEntityWithComponent(c)

        table.removekey()
    end

    return cm
end

function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end