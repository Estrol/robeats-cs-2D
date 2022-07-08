local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedTextButton = Roact.Component:extend("Button")

local function noop() end

RoundedTextButton.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.GothamSemibold;
    Text = "RoundedTextButton";
    TextSize = 18;
    BackgroundColor3 = Color3.fromRGB(29, 29, 29);
    HoldSize = UDim2.fromScale(0.8, 0.8);
    HighlightBackgroundColor3 = Color3.fromRGB(17, 17, 17);
    OnPress = noop;
    OnRelease = noop;
    OnRightPress = noop;
    OnMouseMoved = noop;
    Frequency = 13;
    dampingRatio = 2.5;
    ZIndex = 1
}

function RoundedTextButton:init()
    self.motor = Flipper.GroupMotor.new({
        tap = 0;
        tooltip = 0
    });
    self.motorBinding = RoactFlipper.getBinding(self.motor)

    self.tooltip = Roact.createRef()

    self.isHovering = false
end

function RoundedTextButton:render()
    local props = {
        TextColor3 = self.props.TextColor3;
        Font = self.props.Font;
        Text = self.props.Text;
        TextSize = self.props.TextSize;
        AnchorPoint = self.props.AnchorPoint;
        Position = self.props.Position;
        TextScaled = self.props.TextScaled;
        TextXAlignment = self.props.TextXAlignment;
        TextYAlignment = self.props.TextYAlignment;
        ZIndex = self.props.ZIndex;
        AutoButtonColor = false;
        LayoutOrder = self.props.LayoutOrder;
        Size = self.motorBinding:map(function(a)
            return self.props.Size:Lerp(self.props.HoldSize, a.tap)
        end);
        BackgroundColor3 = self.motorBinding:map(function(a)
            return self.props.BackgroundColor3:Lerp(self.props.HighlightBackgroundColor3, a.tap)
        end);
        ClipsDescendants = self.props.ClipsDescendants;
        BackgroundTransparency = self.props.BackgroundTransparency;
        [Roact.Event.MouseMoved] = function(object, x, y)
            local tooltip = self.tooltip:getValue()

            tooltip.Position = UDim2.fromScale(SPUtil:inverse_lerp(object.AbsolutePosition.X, object.AbsolutePosition.X + object.AbsoluteSize.X, x), SPUtil:inverse_lerp(object.AbsolutePosition.Y, object.AbsolutePosition.Y + object.AbsoluteSize.Y, y)) + UDim2.fromOffset(10, -tooltip.AbsoluteSize.Y * 2.2)

            self.props.OnMouseMoved()
        end;
        [Roact.Event.MouseEnter] = function()
            self.isHovering = true

            self.props.sfxController:Play(self.props.sfxController.BUTTON_HOVER, 0.4)

            self.motor:setGoal({
                tap = Flipper.Spring.new(0.7, {
                    frequency = self.props.Frequency;
                    dampingRatio = self.props.dampingRatio;
                })
            })

            task.delay(0.8, function()
                if self.isHovering and self.props.Tooltip then
                    self.motor:setGoal({
                        tooltip = Flipper.Spring.new(1, {
                            frequency = self.props.Frequency;
                            dampingRatio = self.props.dampingRatio;
                        })
                    })
                end
            end)
        end;
        [Roact.Event.MouseLeave] = function()
            self.isHovering = false

            self.motor:setGoal({
                tap = Flipper.Spring.new(0, {
                    frequency = self.props.Frequency;
                    dampingRatio = self.props.dampingRatio;
                }),
                tooltip = Flipper.Spring.new(0, {
                    frequency = self.props.Frequency;
                    dampingRatio = self.props.dampingRatio;
                })
            })
        end;
        [Roact.Event.MouseButton1Down] = function()
            self.props.sfxController:Play(self.props.sfxController.BUTTON_CLICK, 1.2)

            self.props.OnPress()
            self.motor:setGoal({
                tap = Flipper.Spring.new(0.9, {
                    frequency = 8;
                    dampingRatio = 2.5;
                })
            })
        end;
        [Roact.Event.MouseButton1Up] = function()
            self.props.OnRelease()
            self.motor:setGoal({
                tap = Flipper.Spring.new(0.7, {
                    frequency = 8;
                    dampingRatio = 2.5;
                })
            })
        end;
        [Roact.Event.MouseButton1Click] = self.props.OnClick;
        [Roact.Event.MouseButton2Click] = self.props.OnRightClick;
        [Roact.Event.TouchLongPress] = self.props.OnLongPress;
        [Roact.Ref] = self.props[Roact.Ref]
    }

    local children = Llama.Dictionary.join(self.props[Roact.Children], {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0,4);
        });
        Tooltip = Roact.createElement("TextLabel", {
            Text = if self.props.Tooltip then " " .. self.props.Tooltip .. " " else nil;
            TextSize = 11;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundColor3 = Color3.fromRGB(43, 43, 43);
            AnchorPoint = Vector2.new(0, 0.5);
            Size = UDim2.fromOffset(50, 25);
            ZIndex = self.props.ZIndex + 10;
            Font = Enum.Font.Gotham;
            TextTransparency = self.motorBinding:map(function(a)
                return 1 - a.tooltip
            end),
            BackgroundTransparency = self.motorBinding:map(function(a)
                return 1 - a.tooltip
            end),
            AutomaticSize = Enum.AutomaticSize.XY,
            [Roact.Ref] = self.tooltip
        }, {
            Corner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0,4);
            })
        })
    })

    return Roact.createElement("TextButton", props, children)
end

return withInjection(RoundedTextButton, {
    sfxController = "SFXController"
})