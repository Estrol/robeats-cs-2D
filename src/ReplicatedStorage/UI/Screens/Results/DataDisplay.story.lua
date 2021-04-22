local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local DataDisplay = require(script.Parent.DataDisplay)

return function (target)
    local app  = e(DataDisplay,  {
        data = {
            {
                Name = "Accuracy";
                Value = 98;
            };
            {
                Name = "Score";
                Value = 45899936;
            };
            {
                Name = "Rating";
                Value = 45.85;
            };
        }
    });

    local handle = Roact.mount(app, target)

    return function ()
        Roact.unmount(handle)
    end
end
