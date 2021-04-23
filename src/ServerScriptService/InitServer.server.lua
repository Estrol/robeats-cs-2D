local Knit = require(game.ReplicatedStorage.Knit)

local function game_init()
    game.Players.CharacterAutoLoads = false
    game.Lighting.ClockTime = 0

    local sky = Instance.new("Sky")

    sky.CelestialBodiesShown = false
    sky.Parent = game.Lighting

    Knit.AddServices(game.ServerScriptService.Services)

    Knit.Start():Then(function()
        print("Knit successfully started(server)")
    end):Catch(function(err)
        warn(err)
    end)
end

game_init()
