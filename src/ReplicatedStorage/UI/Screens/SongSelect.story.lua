local Promise = require(game.ReplicatedStorage.Knit.Util.Promise)
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local State = require(game.ReplicatedStorage.State)
local SongSelect = require(game.ReplicatedStorage.UI.Screens.SongSelect)
local Fitumi = require(game.ReplicatedStorage.Packages.Fitumi)

local a = Fitumi.a

local DIContext = require(game.ReplicatedStorage.Contexts.DIContext)

return function(target)
    local storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
        store = State.Store
    }, {
        App = Roact.createElement(SongSelect)
    })

    local fakeScoreService = a.fake()

    a.callTo(fakeScoreService.GetScoresPromise, fakeScoreService, Fitumi.wildcard)
        :returns(Promise.new(function(resolve)
            resolve({
                {
                    UserId = 526993347,
                    PlayerName = "kisperal",
                    Marvelouses = 6,
                    Perfects = 5,
                    Greats = 4,
                    Goods = 3,
                    Bads = 2,
                    Misses = 1,
                    Accuracy = 98.98,
                    Place = 1,
                    Rating = 56.75,
                    Score = 0,
                    Rate = 100
                }
            })
        end))

    local fakePreviewController = a.fake()

    a.callTo(fakePreviewController.PlayId, fakePreviewController, Fitumi.wildcard)
        :returns(nil)

    local app = Roact.createElement(DIContext.Provider, {
        value = {
            ScoreService = fakeScoreService,
            PreviewController = fakePreviewController
        }
    }, {
        StoreProvider = storeProvider
    })

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end