local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local Promise = require(game.ReplicatedStorage.Packages.Promise)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RoundedLargeScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedLargeScrollingFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local SongButton = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongButton)

local SongList = Roact.Component:extend("SongList")

local function noop() end

local function sortByDifficulty(a, b)
    return SongDatabase:get_difficulty_for_key(a.SongKey).Overall > SongDatabase:get_difficulty_for_key(b.SongKey).Overall
end

local function sortByAlphabeticalOrder(a, b)
    if a.AudioFilename == b.AudioFilename then
        return sortByDifficulty(a, b)
    end
    
    return a.AudioFilename < b.AudioFilename
end

SongList.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    OnSongSelected = noop,
    SelectedSongKey = 1
}

function SongList:getSongs()
    local found = SongDatabase:filter_keys(self.props.Search, self.props.SongRate / 100, self.props.ExcludeCustomMaps)

    if self.props.SortByDifficulty then
        return Llama.List.sort(found, sortByDifficulty)
    end

    return Llama.List.sort(found, sortByAlphabeticalOrder)
end

function SongList:init()
    self:setState({
        found = {};
    })

    self:setState({
        found = self:getSongs()
    })

    self.OnSearchChanged = function(o)
        self.props.setSearch(o.Text)
    end
end


function SongList:didUpdate(prevProps, prevState)
    if (self.props.Search ~= prevProps.Search) or (self.props.SortByDifficulty ~= prevProps.SortByDifficulty) or (self.props.SongRate ~= prevProps.SongRate) then
        Promise.new(function(resolve)
            resolve(self:getSongs())
        end):andThen(function(sorted)
            self:setState({
                found = sorted
            })
        end)
    end
end

function SongList:render()
    return e("Frame", {
        AnchorPoint = self.props.AnchorPoint,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = self.props.Position,
        Size = self.props.Size,
    }, {
        UICorner = e("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),
        SongList = e(RoundedLargeScrollingFrame, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.05, 0),
            Size = UDim2.new(1, 0, 0.95, 0),
            Padding = UDim.new(0, 4),
            HorizontalAlignment = "Right",
            ScrollBarThickness = 5,
            items = self.state.found;
            renderItem = function(item, i)
                return e(SongButton, {
                    SongKey = item.SongKey,
                    SongRate = self.props.SongRate,
                    OnClick = self.props.OnSongSelected,
                    LayoutOrder = i,
                    Selected = item.SongKey == self.props.SelectedSongKey
                })
            end,
            getStableId = function(item)
                return item and item.SongKey or "???"
            end,
            getItemSize = function()
                return 80
            end
        }),
        SearchBar = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(41, 41, 41),
            Position = UDim2.new(1, 0, 0.045, 0),
            Size = UDim2.fromScale(0.85, 0.045),
            AnchorPoint = Vector2.new(1, 1),
        }, {
            UICorner = e("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),
            SearchBox = e("TextBox", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.02, 0, 0, 0),
                Size = UDim2.new(0.98, 0, 1, 0),
                ClearTextOnFocus = false,
                Font = Enum.Font.GothamBold,
                PlaceholderColor3 = Color3.fromRGB(181, 181, 181),
                PlaceholderText = "Search here...",
                Text = self.props.Search,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                [Roact.Change.Text] = self.OnSearchChanged
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 17,
                    MinTextSize = 7,
                })
            })
        }),
        SortByDifficulty = e(RoundedTextButton, {
            BackgroundColor3 = self.props.SortByDifficulty and Color3.fromRGB(41, 176, 194) or Color3.fromRGB(41, 41, 41),
            Position = UDim2.fromScale(0, 0.045),
            Size = UDim2.fromScale(0.14, 0.045),
            HoldSize = UDim2.fromScale(0.14, 0.045),
            AnchorPoint = Vector2.new(0, 1),
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Sort By Difficulty",
            OnClick = function()
                self.props.setSortByDifficulty(not self.props.SortByDifficulty)
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 13
            })
        })
    })
end

return RoactRodux.connect(function(state)
    return {
        Search = state.options.transient.Search,
        SortByDifficulty = state.options.transient.SortByDifficulty,
    }
end, function(dispatch)
    return {
        setSearch = function(search)
            dispatch({ type = "setTransientOption", option = "Search", value = search })
        end,
        setSortByDifficulty = function(sortByDifficulty)
            dispatch({ type = "setTransientOption", option = "SortByDifficulty", value = sortByDifficulty })
        end
    }
end)(SongList)
