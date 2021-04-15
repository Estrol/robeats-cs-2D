local Roact = require(game.ReplicatedStorage.Packages.Roact)
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
    ShrinkBy = 0.1;
    HighlightBackgroundColor3 = Color3.fromRGB(17, 17, 17);
    OnPress = noop;
    OnRelease = noop
}

function RoundedTextButton:init()
    self.motor = Flipper.GroupMotor.new({
        tap = 0;
        colorR = self.props.BackgroundColor3 and self.props.BackgroundColor3.R or 1;
        colorG = self.props.BackgroundColor3 and self.props.BackgroundColor3.G or 1;
        colorB = self.props.BackgroundColor3 and self.props.BackgroundColor3.B or 1;
    });
    self.motorBinding = RoactFlipper.getBinding(self.motor)

    self.onActivated = self.props.onActivated or noop
    self.onPress = self.props.onPress or noop
    self.onRelease = self.props.onRelease or noop
end

function RoundedTextButton:didUpdate()
    self.motor:setGoal({
        colorR = Flipper.Spring.new(self.props.BackgroundColor3.R, {
            frequency = 8;
            dampingRatio = 2.5;
        });
        colorG = Flipper.Spring.new(self.props.BackgroundColor3.G, {
            frequency = 8;
            dampingRatio = 2.5;
        });
        colorB = Flipper.Spring.new(self.props.BackgroundColor3.B, {
            frequency = 8;
            dampingRatio = 2.5;
        });
    })
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
        AutoButtonColor = false;
        Size = self.motorBinding:map(function(a)
            local shrinkByX = self.props.suppressXAxis and 0 or self.props.ShrinkBy*a.tap
            local shrinkByY = self.props.suppressYAxis and 0 or self.props.ShrinkBy*a.tap
            return self.props.Size - UDim2.fromScale(shrinkByX, shrinkByY)
        end);
        BackgroundColor3 = self.motorBinding:map(function(a)
            return self.props.BackgroundColor3:Lerp(self.props.HighlightBackgroundColor3, a.tap)
        end);
        [Roact.Event.MouseEnter] = function()
            self.motor:setGoal({
                tap = Flipper.Spring.new(0.7, {
                    frequency = 8;
                    dampingRatio = 2.5;
                })
            })
        end;
        [Roact.Event.MouseLeave] = function()
            self.motor:setGoal({
                tap = Flipper.Spring.new(0, {
                    frequency = 8;
                    dampingRatio = 2.5;
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
    }

    return Roact.createElement("TextButton", props, {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0,4);
        });
        Cdrn = Roact.createFragment(self.props[Roact.Children]);
    })
end

return RoundedTextButton