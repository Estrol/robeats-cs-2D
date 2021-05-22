local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Ban = require(script.Ban)
local Kick = require(script.Kick)
local Users = require(script.Users)
local Delete = require(script.Delete)
local Home = require(script.Home)

local Moderation = Roact.Component:extend("Moderation")

Moderation.routes = {
    ban = Ban,
    kick = Kick,
    users = Users,
    delete = Delete,
    home = Home
}

function Moderation:render()
    return e(self.routes[self.props.match.path], self.props)
end

return Moderation