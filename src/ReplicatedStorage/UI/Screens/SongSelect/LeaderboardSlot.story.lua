local Roact = require(game.ReplicatedStorage.Packages.Roact)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local LeaderboardSlot = require(game.ReplicatedStorage.UI.Screens.SongSelect.LeaderboardSlot)

return function(target)
    local UserId = 526993347
    local name = "kisperal"
    local testApp = Roact.createElement(LeaderboardSlot, {
        UserId = UserId,
        PlayerName = name,
        Score = 0,
        Marvelouses = 6,
        Perfects = 5,
        Greats = 4,
        Goods = 3,
        Bads = 2,
        Misses = 1,
        Time = 8596444113,
        Accuracy = 82,
        Place = 1
    })

    local fr = Roact.mount(testApp, target)

    return function()
        Roact.unmount(fr)
    end 
end
