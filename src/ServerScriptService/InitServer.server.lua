local Knit = require(game.ReplicatedStorage.Knit)

local function game_init()
    game.Players.CharacterAutoLoads = false

    Knit.AddServices(game.ServerScriptService.Services)

    Knit.Start():Then(function()
        print("Knit successfully started(server)")
    end):Catch(function(err)
        warn(err)
    end)
end

game_init()
