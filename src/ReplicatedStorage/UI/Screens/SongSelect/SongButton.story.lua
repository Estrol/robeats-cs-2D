local Roact = require(game.ReplicatedStorage.Packages.Roact)

local SongButton = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongButton)

return function(target)
    local testApp = Roact.createElement(SongButton, {
        SongKey = 1,
        Size = UDim2.new(0.5, 0, 0, 100),
        OnClick = function(song_key)
            print(song_key)
        end
    })

    local fr = Roact.mount(testApp, target)

    return function()
        Roact.unmount(fr)
    end 
end