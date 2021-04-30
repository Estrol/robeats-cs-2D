local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local createReducer = Rodux.createReducer

local join = Llama.Dictionary.join

local defaultState = {
    persistent = {
        --These values can be set in SettingsMenu
        Keybind1 = Enum.KeyCode.Q,
        Keybind2 = Enum.KeyCode.W,
        Keybind3 = Enum.KeyCode.O,
        Keybind4 = Enum.KeyCode.P,

        AudioOffset = 0;
        NoteSpeed = 1;
        FOV = 70;

        --Extra settings.
        TimeOfDay = 24;
        BaseTransparency = 0;

        
        --Change this to swap the timing preset
        TimingPreset = "Standard",
        
        --You probably won't need to modify these
        NoteRemoveTimeMS = -200;
        PostFinishWaitTimeMS = 300;
        PreStartCountdownTimeMS = 3000;
    },
    transient = {
        --This is used to determine the speed of the song
        SongRate = 100,
        SongKey = 1
    }
}

return createReducer(defaultState, {
    setPersistentOption = function(state, action)
        return join(state, {
            persistent = join(state.persistent, {
                [action.option] = action.value
            })
        })
    end,
    setTransientOption = function(state, action)
        return join(state, {
            transient = join(state.transient, {
                [action.option] = action.value
            })
        })
    end
})
