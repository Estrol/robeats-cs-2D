local Roact = require(game.ReplicatedStorage.Packages.Roact)

local Tier = require(game.ReplicatedStorage.UI.Components.Tier)

return function(target)
    local app = Roact.createElement(Tier, {
        tier = "Gold",
        division = 3,
        unranked = true
    })

    Roact.mount(app, target)
end