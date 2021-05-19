local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageButton)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local ColorValue = Roact.Component:extend("ColorValue")

ColorValue.defaultProps = {
    Size = UDim2.new(1, 0, 0, 300),
    Value = Color3.fromRGB(255, 255, 255),
    OnChanged = function() end
}

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

function ColorValue:init()
    self.isDown = false

    self.wheelRef = Roact.createRef()
    self.sliderRef = Roact.createRef()
end

function ColorValue:render()
    local h, s, v = self.props.Value:ToHSV()
    local xs = math.cos(math.rad(h*360))*s
    local ys = math.sin(math.rad(h*360))*s

    xs = SPUtil:inverse_lerp(1, -1, xs)
    ys = SPUtil:inverse_lerp(-1, 1, ys)

    return e(RoundedFrame, {
        Size = self.props.Size,
        Position = self.props.Position,
        BackgroundColor3 =  Color3.fromRGB(25, 26, 26),
        LayoutOrder = self.props.LayoutOrder,
        [Roact.Event.MouseMoved] = function(_, x, y)
            
        end
    }, {
        Name = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.35, 0.2),
            Position = UDim2.fromScale(0.05, 0.07),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Text = self.props.Name,
            TextScaled = true
        }),
        Value = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.38, 0.3),
            Position = UDim2.fromScale(0.05, 0.6),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(37, 37, 37),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = string.format("%d, %d, %d", self.props.Value.R * 255, self.props.Value.G * 255, self.props.Value.B * 255),
            TextScaled = true,
            CornerRadius = UDim.new(0, 12),
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 20,
                MinTextSize = 12
            })
        }),
        Wheel = e(RoundedImageButton, {
            Size = UDim2.new(1,0,0.75,0);
            BackgroundTransparency = 1;
            Image = "rbxassetid://2849458409";
            AnchorPoint = Vector2.new(0.5, 0.5);
            Position = UDim2.new(0.615, 0, 0.5, 0);
            ClipsDescendants = true;
            OnPress = function()
                self.isDown = true
            end,
            OnRelease = function()
                self.isDown = false
            end,
            OnMoved = function(_, x, y)
                if self.isDown == false then return end

                local inset = GuiService:GetGuiInset()

                y -= inset.Y
                
                local wheel = self.wheelRef:getValue()
                local wheelPos = wheel.AbsolutePosition
                local wheelSize = wheel.AbsoluteSize
                local centerPoint = Vector2.new((wheelPos.x + (wheelPos.x + wheelSize.x))/2, (wheelPos.y + (wheelPos.y + wheelSize.y))/2)
        
                local angle = 180 - SPUtil:get_vec2_angle(Vector2.new(x, y), centerPoint)
        
                local distanceFromCenter = SPUtil:find_distance(centerPoint.X, centerPoint.Y, x, y)
        
                local _h = angle/360
                local _s = math.clamp(distanceFromCenter/(wheelSize.X/2), 0, 1)
        
                if h < 0 then
                    h += 1
                end
        
                local _, _, _v = self.props.Value:ToHSV()
        
                local newColor = Color3.fromHSV(_h, _s, _v)

                if _v > 1 then return end
        
                self.props.OnChanged(newColor)
            end,
            [Roact.Ref] = self.wheelRef;
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1;
            });
            Pointer = e(RoundedFrame, {
                Size = UDim2.new(0,10,0,10);
                Position = UDim2.fromScale(xs, ys);
                BorderSizePixel = 0;
                AnchorPoint = Vector2.new(0.5, 0.5);
                BackgroundColor3 = Color3.fromRGB(15, 15, 15);
                ZIndex = 3;
            });
            Color = e("ImageLabel", {
                Image = "rbxassetid://130424513";
                Size = UDim2.new(0.2, 0, 0.2, 0);
                ZIndex = 2;
                BackgroundTransparency = 1;
                AnchorPoint = Vector2.new(1, 1);
                Position = UDim2.new(0.85, 0, 0.9, 0);
                ImageTransparency = 0.157969;
                ImageColor3 = self.props.Value;
            })
        }),
        ValueSlider = e(RoundedTextButton, {
            HoldSize = UDim2.fromScale(0.11, 0.5),
            Size = UDim2.fromScale(0.1, 0.5),
            Text = "",
            Position = UDim2.fromScale(0.85, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            HighlightBackgroundColor3 = Color3.fromRGB(255, 255, 255),
            OnPress = function()
                self.isDown = true
            end,
            OnRelease = function()
                self.isDown = false
            end,
            OnMoved = function(_, _, y)
                if self.isDown == false then return end

                local inset = GuiService:GetGuiInset()

                y -= inset.Y

                local slider = self.sliderRef:getValue()
                local sliderPos = slider.AbsolutePosition
                local sliderSize = slider.AbsoluteSize

                local _v = 1 - SPUtil:inverse_lerp(sliderPos.Y, sliderPos.Y + sliderSize.Y, y)
        
                local _h, _s = self.props.Value:ToHSV()

                local newColor = Color3.fromHSV(_h, _s, _v)

                if _v > 1 then return end
        
                self.props.OnChanged(newColor)
            end,
            [Roact.Ref] = self.sliderRef
        }, {
            UIGradient = e("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.new(
                        math.clamp(self.props.Value.R, 0, 1),
                        math.clamp(self.props.Value.G, 0, 1),
                        math.clamp(self.props.Value.B, 0, 1)
                    ))
                }),
                Rotation = -90
            }),
            ValueBar = e(RoundedFrame, {
                Size = UDim2.fromScale(1, 0.1),
                Position = UDim2.fromScale(0, 1 - v),
                BackgroundColor3 = Color3.fromRGB(54, 54, 54),
                AnchorPoint = Vector2.new(0, 0.5)
            })
        }),
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 3,
            AspectType = Enum.AspectType.ScaleWithParentSize
        })
    })

    -- return e("Frame", {
    --     Size = props.Size or UDim2.new(1,0,1,0);
    --     Position = props.Position;
    --     BackgroundTransparency = props.BackgroundTransparency or 1;
    --     BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(25,25,25);
    --     [Roact.Event.MouseMoved] = props.onMouse;
    --     [Roact.Event.InputBegan] = SPUtil:bind_to_key(props.onMouseClick);
    --     [Roact.Event.InputEnded] = SPUtil:bind_to_key(props.onMouseRelease);
    -- }, {
   
    -- })
end

return ColorValue