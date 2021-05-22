local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedTextBox = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextBox)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local Delete = Roact.Component:extend("Delete")

local function noop() end

Delete.defaultProps = {
    OnDelete = noop
}

function Delete:init()
    self.scoreService = self.props.scoreService
end

function Delete:render()
    local state = self.props.location.state

    return e(RoundedFrame, {
        
    }, {
        DeleteText = e(RoundedTextLabel, {
            Position = UDim2.fromScale(0.5, 0.45),
            AnchorPoint = Vector2.new(0.5, 1),
            Size = UDim2.fromScale(0.5, 0.1),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(172, 172, 172),
            Text = "Are you sure you want to delete this score?",
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            TextScaled = true
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 26
            })
        }),
        BackButton = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.25, 0.5),
            Size = UDim2.fromScale(0.245, 0.1),
            HoldSize = UDim2.fromScale(0.245, 0.1),
            BackgroundColor3 = Color3.fromRGB(78, 78, 78),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Back",
            OnClick = function()
                self.props.history:goBack()
            end
        }),
        DeleteButton = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.25, 0.1),
            HoldSize = UDim2.fromScale(0.25, 0.1),
            BackgroundColor3 = Color3.fromRGB(228, 19, 19),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Delete",
            OnClick = function()
                self.scoreService:DeleteScore(self.props.location.state.scoreId)
                self.props.history:goBack()
            end
        })
    })
end

return withInjection(Delete, {
    scoreService = "ScoreService"
})