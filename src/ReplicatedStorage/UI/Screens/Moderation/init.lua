local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Ban = require(script.Ban)

local Moderation = Roact.Component:extend("Moderation")

Moderation.routes = {
    ban = Ban
}

function Moderation:render()
    return e(self.routes[self.props.match.path], self.props)
end

return Moderation