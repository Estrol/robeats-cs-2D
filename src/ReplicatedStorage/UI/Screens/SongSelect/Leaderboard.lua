local Roact = require(game.ReplicatedStorage.Packages.Roact)

local RoundedScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedScrollingFrame)

local LeaderboardSlot = require(game.ReplicatedStorage.UI.Screens.SongSelect.LeaderboardSlot)

local Leaderboard = Roact.Component:extend("LeaderboardDisplay")

Leaderboard.defaultProps = {
    Leaderboard = {}
}

function Leaderboard:init()
    self.listLayoutRef = Roact.createRef()
end

function Leaderboard:didMount()
    local leaderboardListLayout = self.listLayoutRef:getValue()
    local leaderboard_list = leaderboardListLayout.Parent
    leaderboardListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        leaderboardListLayout.Parent.CanvasSize = UDim2.new(0, 0, 0, leaderboard_list.UIListLayout.AbsoluteContentSize.Y)
    end)
end

function Leaderboard:render()
    local children = {}

    for i, v in pairs(self.props.Leaderboard) do
        children[i] = Roact.createElement(LeaderboardSlot, v)
    end

    return Roact.createElement(RoundedScrollingFrame, {
        Active = true,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 0,
        BorderColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = self.props.Position,
        AnchorPoint = self.props.AnchorPoint,
        Size = self.props.Size,
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        ScrollingDirection = Enum.ScrollingDirection.Y,
        TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
    }, {
        UIListLayout = Roact.createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            [Roact.Ref] = self.listLayoutRef,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 4),
        }),
        Children = Roact.createFragment(children)
    });
end

return Leaderboard
