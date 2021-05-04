local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local e = Roact.createElement
local f = Roact.createFragment

local RunService = game:GetService("RunService")

local RankSlot = require(script.RankSlot)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local Rankings = Roact.Component:extend("Rankings")

function Rankings:init()
    self:setState({
        players = {}
    })

    if RunService:IsRunning() then
        local Knit = require(game:GetService("ReplicatedStorage").Knit)

        local ScoreService = Knit.GetService("ScoreService")

        local players = ScoreService:GetGlobalLeaderboard()

        self:setState({
            players = players
        })
    end
end

function Rankings:render()
    local players = {}

    for i, playerSlot in ipairs(self.state.players) do
        local rankSlot = e(RankSlot, {
            Data = Llama.Dictionary.join(playerSlot, {
                Place = i
            }),
            Size = UDim2.new(1, 0, 0, 50)
        })

        table.insert(players, rankSlot)
    end

    return e(RoundedFrame, {

    }, {
        RankContainer = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.45, 0.8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(24, 24, 24),
            UIListLayoutProps = {
                SortOrder = Enum.SortOrder.LayoutOrder
            }
        }, players),
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

return Rankings