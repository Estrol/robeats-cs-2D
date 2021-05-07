local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Score = require(game.ReplicatedStorage.UI.Screens.Scores.Score)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

return function(target)
    local app = Roact.createElement(Score, {
        SongMD5Hash = SongDatabase:get_hash_for_key(1),
        Rate = 180,
        Rating = 100,
        Accuracy = 100
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end