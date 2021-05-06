local Knit = require(game.ReplicatedStorage.Knit)

local function game_init()
    game.Players.CharacterAutoLoads = false
    game.Lighting.ClockTime = 0

    local sky = Instance.new("Sky")

    sky.CelestialBodiesShown = false
    sky.Parent = game.Lighting

    game.Players.PlayerAdded:Connect(function(player)
        if player.AccountAge < 2 then
            player:Kick(string.format("Your account must be older than 2 days to join this game. %d days left", 2 - player.AccountAge))
        end
    end)

    Knit.AddServices(game.ServerScriptService.Services)

    Knit.Start():Then(function()
        print("Knit successfully started(server)")
    end):Catch(function(err)
        warn(err)
    end)
end

game_init()
