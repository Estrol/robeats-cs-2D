local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement
local f = Roact.createFragment

local RunService = game:GetService("RunService")

local RankSlot = require(script.RankSlot)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local Dropdown = require(game.ReplicatedStorage.UI.Components.Base.Dropdown)

local Countries = require(game.ReplicatedStorage.Countries)

local Rankings = Roact.Component:extend("Rankings")

function Rankings:init()
    self:setState({
        players = {},
        selectedCountry = "Global"
    })

    self.scoreService = self.props.scoreService
    self.moderationService = self.props.moderationService

    self.scoreService:GetGlobalLeaderboard():andThen(function(players)
        self:setState({
            players = players
        })
    end)

end
function Rankings:didUpdate(_, prevState)
    if prevState.selectedCountry ~= self.state.selectedCountry then
        local countryCode = Countries:get_country_code_from_name(self.state.selectedCountry)

        self.scoreService:GetGlobalLeaderboard(if countryCode ~= "Global" then countryCode else nil):andThen(function(players)
            self:setState({
                players = players
            })
        end)
    end
end

function Rankings:render()
    local players = {}

    for i, playerSlot in ipairs(self.state.players) do
        local rankSlot = e(RankSlot, {
            Data = Llama.Dictionary.join(playerSlot, {
                Place = i
            }),
            Size = UDim2.new(1, 0, 0, 50),
            HoldSize = UDim2.new(0.98, 0, 0, 50),
            IsAdmin = self.props.permissions.isAdmin,
            OnBan = function(userId, playerName)
                self.props.history:push("/moderation/ban", {
                    userId = userId,
                    playerName = playerName
                })
            end,
            OnView = function(userId)
                self.props.history:push("/scores", {
                    userId = userId,
                    playerName = playerSlot.PlayerName
                })
            end
        })

        table.insert(players, rankSlot)
    end

    local countryNames = Llama.List.insert(Countries.CountryNames, 1, "Global")

    return e(RoundedFrame, {

    }, {
        Dropdown = e(Dropdown, {
            Position = UDim2.fromScale(0.15, 0.05),
            Options = countryNames,
            OnSelectionChange = function(value)
                self:setState({
                    selectedCountry = value
                })
            end,
            SelectedOption = self.state.selectedCountry
        }),
        RankContainer = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.7, 0.8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(24, 24, 24),
            UIListLayoutProps = {
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center
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

local Injected = withInjection(Rankings, {
    scoreService = "ScoreService",
    moderationService = "ModerationService"
})

return RoactRodux.connect(function(state)
    return {
        permissions = state.permissions
    }
end)(Injected)