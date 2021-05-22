local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local f = Roact.createFragment

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local TabLayout = Roact.Component:extend("TabLayout")

function TabLayout:render()
    local _buttons = {}
    local num = self.props.totalButtons and self.props.totalButtons or math.max(9, #self.props.Buttons)
    for i, v in pairs(self.props.Buttons) do
        _buttons[i] = e(RoundedTextButton, {
            Size = UDim2.new((1/num)*(1-(num*0.01)),0,0.8,0);
            Text = v.Text;
            TextScaled = true;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            Font = Enum.Font.GothamBold;
            BackgroundColor3 = v.Color or Color3.fromRGB(40,40,40);
            backgroundTransparency = 1;
            shrinkBy = 0;
            darkenBy = 5;
            transparencyBy = -1;
            onActivated = v.OnActivated;
            onPress = v.onPress;
            onRelease = v.onRelease;
        }, {
            TextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 16;
                MinTextSize = 12;
            })
        })
    end
    return e(RoundedFrame, {
        Size = self.props.Size;
        Position = self.props.Position;
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 0;
        AnchorPoint = self.props.AnchorPoint;
    }, {
        Layout = e("Frame", {
            Position = UDim2.new(0.5,0,0.5,0);
            Size = UDim2.new(0.99,0,0.99,0);
            BackgroundTransparency = 1;
            AnchorPoint = Vector2.new(0.5,0.5);
        }, {
            Buttons = f(_buttons);
            UIListLayout = e("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                Padding = UDim.new(0.01,0)
            })
        }),
        UICorner = e("UICorner", {
            CornerRadius = UDim.new(0,4)
        })
    })
end

return TabLayout
