local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local Promise = require(game.ReplicatedStorage.Packages.Promise)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RoundedLargeScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedLargeScrollingFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local Dropdown = require(game.ReplicatedStorage.UI.Components.Base.Dropdown)

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

local function sortByDifference(a, b, options)
    local ratingA = SongDatabase:get_difficulty_for_key(a.SongKey, options.SongRate)
    local ratingB = SongDatabase:get_difficulty_for_key(b.SongKey, options.SongRate)

    return math.abs(SongDatabase:get_glicko_estimate_from_rating(ratingA.Overall) - options.mmr) < math.abs(SongDatabase:get_glicko_estimate_from_rating(ratingB.Overall) - options.mmr)
end

local sorts = { "Sort by Rating", "Sort Alphabetically", "Sort by Skill Difference" }

local sortFunctions = {
    [sorts[1]] = sortByDifficulty,
    [sorts[2]] = sortByAlphabeticalOrder,
    [sorts[3]] = sortByDifference,
}

SongList.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    OnSongSelected = noop,
    SelectedSongKey = 1
}

function SongList:getSongs()
    local found = SongDatabase:filter_keys(self.props.Search, self.props.SongRate / 100, self.props.ExcludeCustomMaps)

    local options = {
        mmr = self.props.profile.GlickoRating,
        rate = self.props.SongRate
    }

    print(options)

    return Llama.List.sort(found, function(a, b)
        return sortFunctions[self.state.sort](a, b, options)
    end)
end

function SongList:init()
    self:setState({
        found = {};
        sort = sorts[1]
    })

    self:setState({
        found = self:getSongs()
    })

    self.OnSearchChanged = function(o)
        self.props.setSearch(o.Text)
    end
end


function SongList:didUpdate(prevProps, prevState)
    if (self.props.Search ~= prevProps.Search) or (self.state.sort ~= prevState.sort) or (self.props.SongRate ~= prevProps.SongRate) then
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
            Size = UDim2.fromScale(0.76, 0.045),
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
        SortByDifficulty = e(Dropdown, {
            Position = UDim2.fromScale(0, 0),
            ButtonSize = UDim2.new(1, 0, 0, 23),
            Size = UDim2.new(0.23, 0, 0, 30 * 2.5),
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0),
            Options = sorts,
            SelectedOption = self.state.sort,
            OnSelectionChange = function(sort)
                self:setState({
                    sort = sort
                })
            end
        })
    })
end

return RoactRodux.connect(function(state)
    return {
        Search = state.options.transient.Search,
        SortByDifficulty = state.options.transient.SortByDifficulty,
        SongRate = state.options.transient.SongRate,
        profile = state.profiles[tostring(game.Players.LocalPlayer.UserId)]
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
