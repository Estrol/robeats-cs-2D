local Roact = require(game.ReplicatedStorage.Packages.Roact)

local Ranking = require(script.Parent.Ranking)

return function(target)
    local rating = 45

    local app = Roact.createElement(Ranking, {
        Rating = rating
    })

    local handle = Roact.mount(app, target)

    task.spawn(function()
        while task.wait(2) do
            rating += 1

            local app = Roact.createElement(Ranking, {
                Rating = rating
            })

            Roact.update(handle, app)
        end
    end)

    return function()
        Roact.unmount(handle)
    end
end