local Roact = require(game.ReplicatedStorage.Packages.Roact)

local e = Roact.createElement
-- local Story = require(game.ReplicatedStorage.Shared.Utils.Story)

local BannerCard = require(game.ReplicatedStorage.UI.Screens.Results.BannerCard)

-- function BannerCardApp:render()
--     return (BannerCard, {
--         playername = "kisperal";
--         song_key = 15;
--         rate = 100;
--         grade_image = "http://www.roblox.com/asset/?id=5702584062";
--     });
-- end

return function(target)
    local app = e(BannerCard, {
        playername = "kisperal";
        song_key = 15;
        rate = 100;
        grade_image = "http://www.roblox.com/asset/?id=5702584062";
    });

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end


