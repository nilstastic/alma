textureCache = {}
TextureManager = {}
function TextureManager.Get(texture)
    if textureCache[texture]==nil then
        textureCache[texture] = MOAITexture.new()
        textureCache[texture]:load(texture)
    end
    return textureCache[texture]
end
