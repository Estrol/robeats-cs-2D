local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

local actions = {}

actions.setPersistentOption = makeActionCreator("setPersistentOption", function(option, value)
    return { option = option, value = value }
end)

actions.setTransientOption = makeActionCreator("setTransientOption", function(option, value)
    return { option = option, value = value }
end)

actions.setAdmin = makeActionCreator("setAdmin", function(value)
    return { value = value }
end)

return actions
