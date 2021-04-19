local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local LoadingWheel = Roact.Component:extend("LoadingWheel")

LoadingWheel.defaultProps = {
    RotationSpeed = 1
}

function LoadingWheel:init()
    self.wheelRot, self.setWheelRot = Roact.createBinding(0)
end

function LoadingWheel:didMount()
    self.onEveryFrame = SPUtil:bind_to_frame(function(dt)
        local currentRot = self.wheelRot:getValue()
        self.setWheelRot((currentRot + (dt*self.props.RotationSpeed)) % 1)
    end)
end

function LoadingWheel:render()
    return e("ImageLabel", {
        Size = self.props.Size,
        Position = self.props.Position,
        AnchorPoint  = self.props.AnchorPoint,
        BackgroundTransparency = 1,
        Image = "rbxassetid://4463050739",
        Rotation = self.wheelRot:map(function(a)
            return 360*a
        end)
    }, {
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 1
        })
    })
end

function LoadingWheel:willUnmount()
    self.onEveryFrame:Disconnect()
end

return LoadingWheel