local Roact = require(game.ReplicatedStorage.Packages.Roact)

local e = Roact.createElement

local BannerCard = require(game.ReplicatedStorage.UI.Screens.Results.BannerCard)

return function(target)
    local app = e(BannerCard, {
        playername = "GripWarrior";
        song_key = 48;
        rate = 100;
        grade_image = "http://www.roblox.com/asset/?id=5702584062";
    });

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end


