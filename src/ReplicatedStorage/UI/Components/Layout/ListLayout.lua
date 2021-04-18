local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local e = Roact.createElement

local ListLayout = Roact.Component:extend("ListLayout")

ListLayout.defaultProps = {
    HorizontalAlignment = "Left",
    StartAt = 0,
    Padding = UDim.new(0, 0)
}

function ListLayout:init()
    self.ref = Roact.createRef()
end

function ListLayout:applyLayout()
    local list = self.ref:getValue()

    local children = list:GetChildren()
    local guiObjects = {}

    for _, child in ipairs(children) do
        if child:IsA("GuiObject") then
            table.insert(guiObjects, child)
        end
    end

    table.sort(guiObjects, function(a, b)
        return a.LayoutOrder < b.LayoutOrder
    end)

    local totalSize = self.props.StartAt

    for _, guiObject in ipairs(guiObjects) do
        if self.props.HorizontalAlignment == "Center" then
            guiObject.AnchorPoint = Vector2.new(0.5, 0)
            guiObject.Position = UDim2.new(0.5, 0, 0, totalSize)
        elseif self.props.HorizontalAlignment == "Right" then
            guiObject.AnchorPoint = Vector2.new(1, 0)
            guiObject.Position = UDim2.new(1, 0, 0, totalSize)
        else
            guiObject.AnchorPoint = Vector2.new(0, 0)
            guiObject.Position = UDim2.new(0, 0, 0, totalSize)
        end

        local padding = self.props.Padding.Offset
        -- local parent = guiObject.Parent

        -- if parent.ClassName == "ScrollingFrame" then
        --     local absoluteCanvasSize = (parent.AbsoluteSize.Y * parent.CanvasSize.Y.Scale)
        --     padding += (self.props.Padding.Scale * absoluteCanvasSize)
        -- else
        --     padding += parent.AbsoluteSize.Y * self.props.Padding.Scale
        -- end

        totalSize += guiObject.AbsoluteSize.Y + padding
    end
end

function ListLayout:didUpdate()
    self:applyLayout()
end

function ListLayout:didMount()
    self.refreshLayout = SPUtil:bind_to_frame(function()
        self:applyLayout()
    end)
end

function ListLayout:render()
    return e("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        [Roact.Ref] = self.ref
    }, self.props[Roact.Children])
end

function ListLayout:willUnmount()
    self.refreshLayout:Disconnect()
end

return ListLayout