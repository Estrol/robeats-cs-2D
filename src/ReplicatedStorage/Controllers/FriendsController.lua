local Flipper = require(game.ReplicatedStorage.Packages.Flipper)

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local FriendsController = Knit.CreateController { Name = "FriendsController" }

function FriendsController:KnitInit()
    local pages = game.Players:GetFriendsAsync(game.Players.LocalPlayer.UserId)

    self.Friends = {}

    repeat
        table.foreachi(pages:GetCurrentPage(), function(i, friend)
            table.insert(self.Friends, friend.Id)
        end)

        pages:AdvanceToNextPageAsync()
    until pages.IsFinished
end

function FriendsController:IsFriend(id)
    return if table.find(self.Friends, id) then true else false
end

return FriendsController