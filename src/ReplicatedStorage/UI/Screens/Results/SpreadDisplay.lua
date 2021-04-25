local Roact = require(game.ReplicatedStorage.Packages.Roact)

local SpreadBar = require(script.Parent.SpreadBar)

local SpreadDisplay = Roact.Component:extend("SpreadDisplay")

function SpreadDisplay:render()
    local totalCount = self.props.Marvelouses + self.props.Perfects + self.props.Greats + self.props.Goods + self.props.Bads + self.props.Misses
    return Roact.createElement("Frame", {
        BackgroundColor3 = self.props.BackgroundColor3 or Color3.fromRGB(25, 25, 25),
        Position = self.props.Position,
        Size = self.props.Size or UDim2.new(1, 0, 1, 0),
        AnchorPoint = self.props.AnchorPoint
    }, {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0, 6),
        }),
        SpreadDisplay = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0.985, 0, 0.97, 0),
        }, {
            ListLayout = Roact.createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
            });
            Marvelouses = Roact.createElement(SpreadBar, {
                Size = UDim2.new(1, 0, 1/6, 0);
                LayoutOrder = 1;
                color = Color3.fromRGB(48, 47, 47);
                count = self.props.Marvelouses;
                total = totalCount;
            });
            Perfects = Roact.createElement(SpreadBar, {
                Size = UDim2.new(1, 0, 1/6, 0);
                LayoutOrder = 2;
                color = Color3.fromRGB(41, 37, 0);
                count = self.props.Perfects;
                total = totalCount;
            });
            Greats = Roact.createElement(SpreadBar, {
                Size = UDim2.new(1, 0, 1/6, 0);
                LayoutOrder = 3;
                color = Color3.fromRGB(12, 43, 5);
                count = self.props.Greats;
                total = totalCount;
            });
            Goods = Roact.createElement(SpreadBar, {
                Size = UDim2.new(1, 0, 1/6, 0);
                LayoutOrder = 4;
                color = Color3.fromRGB(4, 3, 44);
                count = self.props.Goods;
                total = totalCount;
            });
            Bads = Roact.createElement(SpreadBar, {
                Size = UDim2.new(1, 0, 1/6, 0);
                LayoutOrder = 5;
                color = Color3.fromRGB(34, 2, 43);
                count = self.props.Bads;
                total = totalCount;
            });
            Misses = Roact.createElement(SpreadBar, {
                Size = UDim2.new(1, 0, 1/6, 0);
                LayoutOrder = 6;
                color = Color3.fromRGB(29, 1, 1);
                count = self.props.Misses;
                total = totalCount;
            });

        })
    })
end

return SpreadDisplay
