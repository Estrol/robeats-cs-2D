local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Promise = require(game.ReplicatedStorage.Knit.Util.Promise)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RoundedLargeScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedLargeScrollingFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local SongButton = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongButton)

local SongList = Roact.Component:extend("SongList")

local function noop() end

SongList.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    OnSongSelected = noop
}

-- LOL SEARCHING GO BYE BYE, PLEASE FIX
-- RIP SEARCHING

--[[
    startIndex = floor(scrollPosition / elementHeight)
    endIndex = ceil((scrollPosition + scrollSize) / elementHeight)
]]

function SongList:init()
    self._songbuttons = {}
    self._list_layout_ref = Roact.createRef()
    self:setState({
        search = "";
        found = SongDatabase:filter_keys();
    })

    self.OnSearchChanged = function(o)
        self:setState({
            search = o.Text;
        })
    end
end


function SongList:didUpdate(_, prevState)
    if self.state.search ~= prevState.search then
        Promise.new(function(resolve)
            resolve(SongDatabase:filter_keys(self.state.search))
        end):andThen(function(found)
            self:setState({
                found = found
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
            items = self.state.found;
            renderItem = function(id)
                return e(SongButton, {
                    SongKey = id,
                    OnClick = self.props.OnSongSelected
                })
            end,
            getStableId = function(id)
                return id
            end,
            getItemSize = function()
                return 80
            end
        }),

        PLACEHOLDER_BUTTON = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.125, .045),
            Position = UDim2.new(0, 0, 0, 0),
            HoldSize = UDim2.fromScale(0.125, .05),
            BackgroundColor3 = Color3.fromRGB(142, 210, 255),
            Text = "PLACEHOLDER",
            OnClick = function()
                return noop
            end
        });

        PLACEHOLDER_BUTTON_2 = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.125, .045),
            Position = UDim2.new(0.1275, 0, 0, 0),
            HoldSize = UDim2.fromScale(0.125, .05),
            BackgroundColor3 = Color3.fromRGB(142, 210, 255),
            Text = "PLACEHOLDER_2",
            OnClick = function()
                return noop
            end
        });
        SearchBar = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(41, 41, 41),
            Position = UDim2.new(1, 0, 0.04, 0),
            Size = UDim2.fromScale(.74, 0.045),
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
                Text = self.state.search,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                [Roact.Event.Focused] = function()
                    
                end,
                [Roact.Change.Text] = self.OnSearchChanged
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 17,
                    MinTextSize = 7,
                })
            })
        })
    })
end

return SongList
