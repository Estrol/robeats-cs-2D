local HttpService = game:GetService("HttpService")

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local function constructRoom(player)
    return SPUtil:make("StringValue", {
        Name = HttpService:GenerateGUID(false),
        Value = string.format("%s's room", player.Name)
    }, {
        InGame = SPUtil:make("BoolValue", {
            Value = false
        }),
        Aborted = SPUtil:make("BoolValue", {
            Value = false
        }),
        SelectedSongIndex = SPUtil:make("IntValue", {
            Value = 1
        }),
        SelectedSongRate = SPUtil:make("NumberValue"),
        SongStarted = SPUtil:make("BoolValue"),
        Players = SPUtil:make("ObjectValue", {
            Value = player
        })
    })
end

return constructRoom
