local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local TopBar = Roact.Component:extend("TopBar")

TopBar.blacklistedRoutes = {
    "/play",
    "/retrydelay"
}

TopBar.routeColors = {
    ["/results"] = Color3.fromRGB(18, 18, 18)
}

function TopBar:render()
    for _, route in ipairs(TopBar.blacklistedRoutes) do
        if string.find(self.props.location.path, route) then
            return nil
        end
    end

    return e(RoundedFrame, {
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.fromOffset(0, -36),
        BackgroundColor3 = TopBar.routeColors[self.props.location.path]
    })
end

return TopBar