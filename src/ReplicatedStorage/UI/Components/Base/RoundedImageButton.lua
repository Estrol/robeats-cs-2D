--[[
    NOTE: This component will only render properly if the ScreenGui it is childed to has its ZIndexBehavior set to "Global".
    This is due to the fact that an ImageLabel is DECLARED UNDER THE TEXTLABEL. Normal animated TextLabels will work fine, but those with backgournd images will not.
]]

local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)

local RoundedImageButton = Roact.Component:extend("Button")

local function noop() end

RoundedImageButton.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.GothamSemibold;
    TextSize = 18;
    BackgroundColor3 = Color3.fromRGB(29, 29, 29);
    HoldSize = UDim2.fromScale(0.8, 0.8);
    HighlightBackgroundColor3 = Color3.fromRGB(17, 17, 17);
    ImageColor3 = Color3.fromRGB(255, 255, 255);
    HighlightImageColor3 = Color3.fromRGB(175, 172, 172);
    OnPress = noop;
    OnRelease = noop;
    Frequency = 13;
    dampingRatio = 2.5;
    ZIndex = 1,
    TextBackgroundTransparency = 1
}

function RoundedImageButton:init()
    self.motor = Flipper.GroupMotor.new({
        tap = 0;
    });
    self.motorBinding = RoactFlipper.getBinding(self.motor)
end

function RoundedImageButton:render()
    local props = {
        AnchorPoint = self.props.AnchorPoint;
        Position = self.props.Position;
        ZIndex = self.props.ZIndex;
        AutoButtonColor = false;
        LayoutOrder = self.props.LayoutOrder;
        Image = self.props.Image;
        ImageColor3 = self.motorBinding:map(function(a)
            return self.props.ImageColor3:Lerp(self.props.HighlightImageColor3, a.tap)
        end);
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
        [Roact.Ref] = self.props[Roact.Ref]
    }

    local children = Llama.Dictionary.join(self.props[Roact.Children], {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0,4);
        });
    })

    if self.props.Text then
        children = Llama.Dictionary.join(children, {
            ImageButtonText = Roact.createElement(RoundedTextLabel, {
                Size = UDim2.fromScale(1, 1),
                TextColor3 = self.props.TextColor3;
                Font = self.props.Font;
                Text = self.props.Text;
                TextSize = self.props.TextSize;
                TextScaled = self.props.TextScaled;
                TextXAlignment = self.props.TextXAlignment;
                TextYAlignment = self.props.TextYAlignment;
                BackgroundTransparency = self.props.TextBackgroundTransparency;
            })
        })
    end

    return Roact.createElement("ImageButton", props, children)
end

return RoundedImageButton