local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Leaderboard = require(game.ReplicatedStorage.UI.Screens.SongSelect.Leaderboard)

return function(target)
    local leaderboard = {
        {
            UserId = 526993347,
            PlayerName = "kisperal",
            Marvelouses = 6,
            Perfects = 5,
            Greats = 4,
            Goods = 3,
            Bads = 2,
            Misses = 1,
            Time = 1596444113,
            Accuracy = 98.98,
            Place = 1,
            Score = 0
        },
        {
            UserId = 160677253,
            PlayerName = "AstralKingdoms",
            Marvelouses = 696969,
            Perfects = 51324,
            Greats = 43,
            Goods = 0,
            Bads = 1,
            Misses = 0,
            Time = 1596666465,
            Accuracy = 100,
            Place = 2,
            Score = 939394993
        }
    }

    local app = Roact.createElement(Leaderboard, {
        Leaderboard = leaderboard,
        Size = UDim2.new(1, 0, 1, 0);
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end
