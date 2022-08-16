local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageButton)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local AnimatedNumberLabel = require(game.ReplicatedStorage.UI.Components.Base.AnimatedNumberLabel)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local Loading = Roact.Component:extend("Loading")

Loading.defaultProps = {
    OnBack = function()

    end,
    OnSkipClicked = function()

    end,
    SecondsLeft = 10
}

function Loading:render()
    return e(RoundedFrame, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(29, 29, 29),
        Position = UDim2.fromScale(0.5, 0.489),
        Size = UDim2.fromScale(0.314, 0.233)
    }, {
        SkipLoading = e(RoundedTextButton, {
            Font = Enum.Font.SourceSansSemibold,
            Text = "Skip Loading",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            TextSize = 14,
            TextWrapped = true,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(231, 76, 31),
            Position = UDim2.fromScale(0.5, 0.775),
            Size = UDim2.fromScale(0.481, 0.15),
            HoldSize = UDim2.fromScale(0.483, 0.16),
            OnClick = self.props.OnSkipClicked
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 25
            })
        }),
        LoadingText = e(RoundedTextLabel, {
            Font = Enum.Font.SourceSansSemibold,
            Text = string.format("Loading Map... [%d]", self.props.SecondsLeft),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            TextSize = 14,
            TextWrapped = true,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.05),
            Size = UDim2.fromScale(0.976, 0.15),
        }),
        Exit = e(RoundedTextButton, {
            Font = Enum.Font.SourceSansBold,
            Text = "x",
            TextColor3 = Color3.fromRGB(231, 76, 31),
            TextScaled = true,
            TextSize = 14,
            TextWrapped = true,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.904, 0),
            Size = UDim2.fromScale(0.096, 0.2),
            HoldSize = UDim2.fromScale(0.098, 0.22),
            ZIndex = 5,
            OnClick= self.props.OnBack
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                DominantAxis = Enum.DominantAxis.Height
            })
        }),
        LoadingWheel = e(LoadingWheel, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.192, 0.4),
        })
    })
end

return Loading

--[[return e(RoundedFrame, {
    frame = e("Frame", {
      
    }, {
      uICorner = e("UICorner", {
        CornerRadius = UDim.new(0, 4),
      }),
  
      skipLoading = e("TextButton", {
        
      }, {
        uICorner1 = e("UICorner", {
          CornerRadius = UDim.new(0, 4),
        }),
  
        uITextSizeConstraint = e("UITextSizeConstraint", {
          MaxTextSize = 25,
        }),
      }),
  
      loadingMap = e("TextLabel", {
        
      }),
  
      exit = e("TextButton", {
        
      }, {
        uIAspectRatioConstraint = e("UIAspectRatioConstraint", {
          DominantAxis = Enum.DominantAxis.Height,
        }),
      }),
  
      loadingWheel = e("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(80, 80),
      }),
    }),
  })]]