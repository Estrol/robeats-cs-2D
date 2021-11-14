local Roact = require(game.ReplicatedStorage.Packages.Roact)
local MusicBox = require(script.Parent.MusicBox)

return function(target)
    local app = Roact.createElement(MusicBox, {
        currentAudioName = "Sky Is The Limit",
        currentAudioArtist = "-RYO-",
        currentAudioSongCover = "https://www.roblox.com/library/6998234944/cs-lgoo"
    })

    local handle = Roact.mount(app, target)

    return function ()
        Roact.unmount(handle)
    end
end