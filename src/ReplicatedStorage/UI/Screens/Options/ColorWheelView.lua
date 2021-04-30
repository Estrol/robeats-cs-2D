local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

function ColorWheel(props)
    return e("Frame", {
        Size = props.Size or UDim2.new(1,0,1,0);
        Position = props.Position;
        BackgroundTransparency = props.BackgroundTransparency or 1;
        BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(25,25,25);
        [Roact.Event.MouseMoved] = props.onMouse;
        [Roact.Event.InputBegan] = SPUtil:bind_to_key(props.onMouseClick);
        [Roact.Event.InputEnded] = SPUtil:bind_to_key(props.onMouseRelease);
    }, {
        Wheel = e("ImageLabel", {
            Size = UDim2.new(1,0,0.75,0);
            BackgroundTransparency = 1;
            Image = "rbxassetid://2849458409";
            AnchorPoint = Vector2.new(0.5, 0.5);
            Position = UDim2.new(0.5, 0, 0.5, 0);
            ClipsDescendants = true;
            [Roact.Ref] = props[Roact.Ref];
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1;
            });
            Pointer = e("Frame", {
                Size = UDim2.new(0,10,0,10);
                Position = props.pointerPosition;
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
                ImageColor3 = props.currentColor;
            })
        })
    })
end

return ColorWheel