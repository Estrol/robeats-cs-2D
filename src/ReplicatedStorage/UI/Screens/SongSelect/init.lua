local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement

local RunService = game:GetService("RunService")

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)
local Mods = require(game.ReplicatedStorage.RobeatsGameCore.Enums.Mods)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local Actions = require(game.ReplicatedStorage.Actions)

local Maid = require(game.ReplicatedStorage.Knit.Util.Maid)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local ButtonLayout = require(game.ReplicatedStorage.UI.Components.Base.ButtonLayout)

local SongInfoDisplay = require(script.SongInfoDisplay)
local SongList = require(script.SongList)
local Leaderboard = require(script.Leaderboard)
local ModSelection = require(script.ModSelection)

local SongSelect = Roact.Component:extend("SongSelect")

function SongSelect:init()
    self.scoreService = self.props.scoreService
    self.previewController = self.props.previewController

    self:setState({
        modSelectionVisible = false
    })

    self.maid = Maid.new()

    local onUprateKeyPressed = SPUtil:bind_to_key(Enum.KeyCode.Equals, function()
        if self.props.options.SongRate < 500 then
            self.props.setSongRate(self.props.options.SongRate + 5)
        end
    end)

    local onDownrateKeyPressed = SPUtil:bind_to_key(Enum.KeyCode.Minus, function()
        if self.props.options.SongRate > 5 then
            self.props.setSongRate(self.props.options.SongRate - 5)
        end
    end)

    local onOptionsKeyPressed = SPUtil:bind_to_key_combo({Enum.KeyCode.O, Enum.KeyCode.LeftControl}, function()
        self.props.history:push("/options")
    end)

    self.maid:GiveTask(onUprateKeyPressed)
    self.maid:GiveTask(onDownrateKeyPressed)
    self.maid:GiveTask(onOptionsKeyPressed)
end

function SongSelect:render()
    return e(RoundedFrame, {

    }, {
        SongInfoDisplay = e(SongInfoDisplay, {
            Size = UDim2.fromScale(0.985, 0.2),
            Position = UDim2.fromScale(0.01, 0.01),
            SongKey = self.props.options.SongKey,
            SongRate = self.props.options.SongRate
        }),
        SongList = e(SongList, {
            Size = UDim2.fromScale(0.64, 0.77),
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.fromScale(0.995, 0.985),
            OnSongSelected = function(key)
                self.props.setSongKey(key)
            end
        }),
        Leaderboard = e(Leaderboard, {
            Size = UDim2.fromScale(0.325, 0.7),
            Position = UDim2.fromScale(0.02, 0.22),
            SongKey = self.props.options.SongKey,
            IsAdmin = self.props.permissions.isAdmin,
            OnLeaderboardSlotClicked = function(stats)
                local _, hits = self.scoreService:GetGraphPromise(stats.UserId, stats.SongMD5Hash)
                    :await()

                self.props.history:push("/results", Llama.Dictionary.join(stats, {
                    SongKey = SongDatabase:get_key_for_hash(stats.SongMD5Hash),
                    TimePlayed = DateTime.fromIsoDate(stats.updatedAt).UnixTimestamp,
                    Hits = hits
                }))
            end,
            OnDelete = function(id)
                self.scoreService:DeleteScore(id)
            end,
            OnBan = function(userId, playerName)
                self.props.history:push("/moderation/ban", {
                    userId = userId,
                    playerName = playerName
                })
            end
        }),
        ButtonContainer = e(ButtonLayout, {
            Size = UDim2.fromScale(0.3325, 0.042),
            Position = UDim2.fromScale(0.02, 0.975),
            AnchorPoint = Vector2.new(0, 1),
            Padding = UDim.new(0, 8),
            MaxTextSize = 14,
            DefaultSpace = 4,
            Buttons = {
                {
                    Text = "Play",
                    Color = Color3.fromRGB(8, 153, 32),
                    OnClick = function()
                        self.props.history:push("/play")
                    end
                },
                {
                    Text = "Options",
                    Color = Color3.fromRGB(37, 37, 37),
                    OnClick = function()
                        self.props.history:push("/options")
                    end
                },
                {
                    Text = "Mods",
                    Color = Color3.fromRGB(33, 126, 83),
                    OnClick = function()
                        self:setState({
                            modSelectionVisible = not self.state.modSelectionVisible
                        })
                    end
                },
                {
                    Text = "Main Menu",
                    Color = Color3.fromRGB(37, 37, 37),
                    OnClick = function()
                        self.props.history:push("/")
                    end
                }
            }
        }),
        ModSelection = e(ModSelection, {
            ActiveMods = self.props.options.Mods,
            OnModSelected = function(mods)
                print(Mods:get_string_for_mods(mods))

                self.props.setMods(mods)
            end,
            Visible = self.state.modSelectionVisible,
            OnBackClicked = function()
                self:setState({
                    modSelectionVisible = false
                })
            end
        })
    })
end

function SongSelect:didMount()
    self.previewController:PlayId(SongDatabase:get_data_for_key(self.props.options.SongKey).AudioAssetId, function(audio)
        audio.TimePosition = audio.TimeLength * 0.33
    end, 0.5, true)
end

function SongSelect:didUpdate(oldProps)
    if self.props.options.SongKey ~= oldProps.options.SongKey then
        self.previewController:PlayId(SongDatabase:get_data_for_key(self.props.options.SongKey).AudioAssetId, function(audio)
            audio.TimePosition = audio.TimeLength * 0.33
        end)
    end

    if self.props.options.SongRate ~= oldProps.options.SongRate then
        self.previewController:SetRate(self.props.options.SongRate / 100)
    end
end

function SongSelect:willUnmount()
    self.previewController:Silence()
    self.maid:DoCleaning()
end

local Injected = withInjection(SongSelect, {
    scoreService = "ScoreService",
    previewController = "PreviewController"
})

return RoactRodux.connect(function(state, props)
    return Llama.Dictionary.join(props, {
        options = Llama.Dictionary.join(state.options.persistent, state.options.transient),
        permissions = state.permissions
    })
end, function(dispatch)
    return {
        setSongKey = function(songKey)
            dispatch(Actions.setTransientOption("SongKey", songKey))
        end,
        setSongRate = function(songRate)
            dispatch(Actions.setTransientOption("SongRate", songRate))
        end,
        setMods = function(mods)
            dispatch(Actions.setTransientOption("Mods", mods))
        end
    }
end)(Injected)