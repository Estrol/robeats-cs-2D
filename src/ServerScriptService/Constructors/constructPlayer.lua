local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local function constructPlayer(player)
    return SPUtil:make("ObjectValue", {
        Name = player.Name,
        Value = player
    }, {
        IsReady = SPUtil:make("BoolValue", {
            Value = false
        }),
        Marvelouses = SPUtil:make("IntValue"),
        Perfects = SPUtil:make("IntValue"),
        Greats = SPUtil:make("IntValue"),
        Goods = SPUtil:make("IntValue"),
        Bads = SPUtil:make("IntValue"),
        Misses = SPUtil:make("IntValue"),
        Score = SPUtil:make("IntValue"),
        Accuracy = SPUtil:make("NumberValue"),
        CurCombo = SPUtil:make("NumberValue"),
        MaxCombo = SPUtil:make("NumberValue")
    })
end

return constructPlayer
