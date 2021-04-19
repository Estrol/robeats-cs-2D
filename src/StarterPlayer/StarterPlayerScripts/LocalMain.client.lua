local Knit = require(game.ReplicatedStorage.Knit)

local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)

local function game_init()
	Knit.AddControllers(game.ReplicatedStorage.Controllers)
	EnvironmentSetup:initial_setup()

	Knit.Start():Then(function()
		print("Knit successfully started(client)")
	end):Catch(function(err)
		warn(err)
	end)
end

game_init()
