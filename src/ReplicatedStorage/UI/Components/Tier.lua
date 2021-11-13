local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Llama = require(game.ReplicatedStorage.Packages.Llama)

local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

local Tier = Roact.Component:extend("Tier")

Tier.defaultProps = {
    tier = "Bronze",
    division = 1,
    imageLabelProps = {}
}

Tier.Images = {
    Aluminum = { "rbxassetid://7989701214", "rbxassetid://7989699108", "rbxassetid://7989698178" },
    Bronze = { "rbxassetid://7989698032", "rbxassetid://7989697690", "rbxassetid://7989697392" },
    Silver = { "rbxassetid://7989697204", "rbxassetid://7989697045", "rbxassetid://7989696784" },
    Gold = { "rbxassetid://7989701026", "rbxassetid://7989700857", "rbxassetid://7989700681" },
    Platinum = { "rbxassetid://7989700475", "rbxassetid://7989700256", "rbxassetid://7989700104" },
    Diamond = { "rbxassetid://7989699899", "rbxassetid://7989699697", "rbxassetid://7989699464" },
    Master = { "rbxassetid://7989699316", "rbxassetid://7989698831", "rbxassetid://7989698577" },
    Grandmaster = { "rbxassetid://7989698336" }
}

function Tier:render()
    local image = self.Images[self.props.tier][if self.props.division then self.props.division else 1]

    local props = Llama.Dictionary.join(self.props.imageLabelProps, {
        Image = image
    })

    return e(RoundedImageLabel, props, {
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 1
        })
    })
end

return Tier
