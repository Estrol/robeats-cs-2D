local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RankSlot = require(game.ReplicatedStorage.UI.Screens.Rankings.RankSlot)

return function(target)
    local app = Roact.createElement(RankSlot)
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end