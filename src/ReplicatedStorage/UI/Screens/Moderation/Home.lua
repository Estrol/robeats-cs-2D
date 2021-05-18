local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)

local Home = Roact.Component:extend("Home")

function Home:init()
    
end

function Home:render()
    return e(RoundedFrame, {

    }, {
        ButtonContainer = e(RoundedAutoScrollingFrame, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromScale(0.3, 0.7),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        }, {
            Users = e(RoundedTextButton, {
                Size = UDim2.new(1, 0, 0, 40),
                HoldSize = UDim2.new(1, 0, 0, 35),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundColor3 = Color3.fromRGB(32, 32, 32),
                Text = "Users",
                OnClick = function()
                    self.props.history:push("/moderation/users")
                end
            }),
        }),
        BackButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.04, 0.95),
            BackgroundColor3 = Color3.fromRGB(212, 23, 23),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Back",
            TextSize = 12,
            OnClick = function()
                self.props.history:goBack()
            end
        }),
    })
end

return Home