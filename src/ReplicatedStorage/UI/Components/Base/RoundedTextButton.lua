local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

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
    Frequency = 13;
    dampingRatio = 2.5;
    ZIndex = 1
}

function RoundedTextButton:init()
    self.motor = Flipper.GroupMotor.new({
        tap = 0;
    });
    self.motorBinding = RoactFlipper.getBinding(self.motor)
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
        BackgroundTransparency = self.props.BackgroundTransparency;
        [Roact.Event.MouseMoved] = self.props.OnMoved;
        [Roact.Event.MouseEnter] = function()
            self.motor:setGoal({
                tap = Flipper.Spring.new(0.7, {
                    frequency = self.props.Frequency;
                    dampingRatio = self.props.dampingRatio;
                })
            })
        end;
        [Roact.Event.MouseLeave] = function()
            self.motor:setGoal({
                tap = Flipper.Spring.new(0, {
                    frequency = self.props.Frequency;
                    dampingRatio = self.props.dampingRatio;
                })
            })
        end;
        [Roact.Event.MouseButton1Down] = function()
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
        [Roact.Ref] = self.props[Roact.Ref]
    }

    local children = Llama.Dictionary.join(self.props[Roact.Children], {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0,4);
        });
    })

    return Roact.createElement("TextButton", props, children)
end

return RoundedTextButton