local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Breakdown = Roact.Component:extend("Breakdown")

Breakdown.defaultProps = {
    Skillsets = {
        Stream = 0,
        Stamina = 0,
        Jack = 0,
        Chordjack = 0,
        Jumpstream = 0,
        Handstream = 0,
        Technical = 0
    }
}

local MAX_SR = 80

function Breakdown:render()
    local skillsets = self.props.Skillsets

    return e("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Position = self.props.Position,
        Size = self.props.Size,
        AnchorPoint = Vector2.new(0, 0.5),
    }, {
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 3.19,
        }),

        UICorner = e("UICorner"),
    
        Handstream = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(57, 57, 57),
            LayoutOrder = 6,
            Position = UDim2.fromScale(0, 0.723),
            Size = UDim2.fromScale(1, 0.119),
        }, {
            UICorner1 = e("UICorner", {
                CornerRadius = UDim.new(0, 30),
            }),
    
            Percent = skillsets.Handstream > 0 and e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(126, 126, 126),
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(skillsets.Handstream / MAX_SR, 1),
            }, {
                UICorner2 = e("UICorner", {
                    CornerRadius = UDim.new(0, 30),
                }),
            }),
    
            Value = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = string.format("%0.2f", skillsets.Handstream),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.963, 0.5),
                Size = UDim2.new(0, 49, 1, 0),
            }),
    
            UIStroke = e("UIStroke"),
    
            Label = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = "Handstream",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.33, 0.547),
                Size = UDim2.fromScale(0.315, 1),
            }),
        }),
    
        Chordjack = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(57, 57, 57),
            LayoutOrder = 4,
            Position = UDim2.fromScale(0, 0.434),
            Size = UDim2.fromScale(1, 0.119),
        }, {
            UICorner3 = e("UICorner", {
                CornerRadius = UDim.new(0, 30),
            }),
    
            Percent1 = skillsets.Chordjack > 0 and e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(126, 126, 126),
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(skillsets.Chordjack / MAX_SR, 1),
            }, {
                UICorner4 = e("UICorner", {
                    CornerRadius = UDim.new(0, 30),
                }),
            }),
    
            Value1 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = string.format("%0.2f", skillsets.Chordjack),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.963, 0.5),
                Size = UDim2.new(0, 49, 1, 0),
            }),
    
            UIStroke1 = e("UIStroke"),
    
            Label1 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = "Chordjack",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.33, 0.547),
                Size = UDim2.fromScale(0.315, 1),
            }),
        }),
    
        Jack = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(57, 57, 57),
            LayoutOrder = 3,
            Position = UDim2.fromScale(0, 0.289),
            Size = UDim2.fromScale(1, 0.119),
        }, {
            UICorner5 = e("UICorner", {
                CornerRadius = UDim.new(0, 30),
            }),
    
            Percent2 = skillsets.Jack > 0 and e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(126, 126, 126),
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(skillsets.Jack / MAX_SR, 1),
            }, {
                UICorner6 = e("UICorner", {
                    CornerRadius = UDim.new(0, 30),
                }),
            }),
    
            Value2 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = string.format("%0.2f", skillsets.Jack),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.963, 0.5),
                Size = UDim2.fromScale(0.248, 1),
            }),
    
            UIStroke2 = e("UIStroke"),
    
            Label2 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = "Jack",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.33, 0.547),
                Size = UDim2.fromScale(0.315, 1),
            }),
        }),
    
        Stream = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(57, 57, 57),
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 0.119),
        }, {
            UICorner7 = e("UICorner", {
                CornerRadius = UDim.new(0, 30),
            }),
    
            Percent3 = skillsets.Stream > 0 and e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(126, 126, 126),
                Position = UDim2.fromScale(7.75e-08, 0.5),
                Size = UDim2.fromScale(skillsets.Stream / MAX_SR, 1),
            }, {
                UICorner8 = e("UICorner", {
                    CornerRadius = UDim.new(0, 30),
                }),
            }),
    
            Value3 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = string.format("%0.2f", skillsets.Stream),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.963, 0.547),
                Size = UDim2.fromScale(0.248, 1),
            }),
    
            UIStroke3 = e("UIStroke"),
    
            Label3 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = "Stream",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.33, 0.547),
                Size = UDim2.fromScale(0.315, 1),
            }),
        }),
    
        Technical = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(57, 57, 57),
            LayoutOrder = 7,
            Position = UDim2.fromScale(0, 0.868),
            Size = UDim2.fromScale(1, 0.119),
        }, {
            UICorner9 = e("UICorner", {
                CornerRadius = UDim.new(0, 30),
            }),
    
            Percent4 = skillsets.Technical > 0 and e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(126, 126, 126),
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(skillsets.Technical / MAX_SR, 1),
            }, {
                UICorner10 = e("UICorner", {
                    CornerRadius = UDim.new(0, 30),
                }),
            }),
    
            Value4 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = string.format("%0.2f", skillsets.Technical),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.963, 0.5),
                Size = UDim2.new(0, 49, 1, 0),
            }),
    
            UIStroke4 = e("UIStroke"),
    
            Label4 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = "Technical",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.33, 0.547),
                Size = UDim2.fromScale(0.315, 1),
            }),
        }),
    
        Stamina = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(57, 57, 57),
            LayoutOrder = 2,
            Position = UDim2.fromScale(0, 0.145),
            Size = UDim2.fromScale(1, 0.119),
        }, {
            UICorner11 = e("UICorner", {
                CornerRadius = UDim.new(0, 30),
            }),
    
            Percent5 = skillsets.Stamina > 0 and e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(126, 126, 126),
                Position = UDim2.fromScale(7.75e-08, 0.5),
                Size = UDim2.fromScale(skillsets.Stamina / MAX_SR, 1),
            }, {
                UICorner12 = e("UICorner", {
                    CornerRadius = UDim.new(0, 30),
                }),
            }),
    
            Value5 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = string.format("%0.2f", skillsets.Stamina),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.963, 0.501),
                Size = UDim2.fromScale(0.248, 1),
            }),
    
            UIStroke5 = e("UIStroke"),
    
            Label5 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = "Stamina",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.33, 0.547),
                Size = UDim2.fromScale(0.315, 1),
            }),
        }),
    
        UIListLayout = e("UIListLayout", {
            Padding = UDim.new(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
    
        Jumpstream = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(57, 57, 57),
            LayoutOrder = 5,
            Position = UDim2.fromScale(0, 0.578),
            Size = UDim2.fromScale(1, 0.119),
        }, {
            UICorner13 = e("UICorner", {
                CornerRadius = UDim.new(0, 30),
            }),
    
            Percent6 = skillsets.Jumpstream > 0 and e("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(126, 126, 126),
                Position = UDim2.fromScale(7.75e-08, 0.5),
                Size = UDim2.fromScale(skillsets.Jumpstream / MAX_SR, 1),
            }, {
                UICorner14 = e("UICorner", {
                    CornerRadius = UDim.new(0, 30),
                }),
            }),
    
            Value6 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = string.format("%0.2f", skillsets.Jumpstream),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.963, 0.5),
                Size = UDim2.new(0, 49, 1, 0),
            }),
    
            UIStroke6 = e("UIStroke"),
    
            Label6 = e("TextLabel", {
                Font = Enum.Font.GothamBlack,
                Text = "Jumpstream",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.33, 0.547),
                Size = UDim2.fromScale(0.315, 1),
            }),
        }),
    })
end

return Breakdown