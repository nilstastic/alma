SoundManager = {}
SoundManager.mode = "notFMOD"
soundCache = {}
function SoundManager.Init()
    if SoundManager.mode =="FMOD" then
        channel = 1
        sfxchannel = MOAIFmodExChannel.new()
    else
        MOAIUntzSystem.initialize()
        MOAIUntzSystem.setVolume(1)
    end
end


function SoundManager.Load(path)
    if soundCache[path]~=nil then
        return soundCache[path]
    end

    local snd
    if SoundManager.mode=="FMOD" then
        snd = MOAIFmodExSound.new()
        snd:loadSFX(path)
    else
        snd = MOAIUntzSound.new()
        snd:load(path)
    end
    soundCache[path] = snd
    return snd
end




function SoundManager.Play(sound,channel)
    if SoundManager.mode=="FMOD" then
        channel = channel or 1
        sfxchannel:setChannel(channel)
        sfxchannel:play(sound)

        channel = channel + 1
        if channel > 10 then
            channel = 1
        end
    else
        sound:play()
    end
end