local Roact = require(game.ReplicatedStorage.Packages.Roact)
local LeaderboardDisplay = require(game.ReplicatedStorage.UI.Screens.SongSelect.LeaderboardDisplay)

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
            PlayerName = "DetWasTaken",
            Marvelouses = 6,
            Perfects = 5,
            Greats = 4,
            Goods = 3,
            Bads = 2,
            Misses = 1,
            Time = 1596666465,
            Accuracy = 95.67,
            Place = 2,
            Score = 0
        },
        {
            UserId = 160677253,
            PlayerName = "DetWasTaken",
            Marvelouses = 6,
            Perfects = 5,
            Greats = 4,
            Goods = 3,
            Bads = 2,
            Misses = 1,
            Time = 1596666465,
            Accuracy = 95.67,
            Place = 3,
            Score = 0
        },
        {
            UserId = 160677253,
            PlayerName = "DetWasTaken",
            Marvelouses = 6,
            Perfects = 5,
            Greats = 4,
            Goods = 3,
            Bads = 2,
            Misses = 1,
            Time = 1596666465,
            Accuracy = 95.67,
            Place = 4,
            Score = 0
        },
        {
            UserId = 160677253,
            PlayerName = "DetWasTaken",
            Marvelouses = 6,
            Perfects = 5,
            Greats = 4,
            Goods = 3,
            Bads = 2,
            Misses = 1,
            Time = 1596666465,
            Accuracy = 95.67,
            Place = 5,
            Score = 0
        }
    }

    local app = Roact.createElement(LeaderboardDisplay, {
        leaderboard = leaderboard,
        Size = UDim2.new(1, 0, 1, 0);
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end
