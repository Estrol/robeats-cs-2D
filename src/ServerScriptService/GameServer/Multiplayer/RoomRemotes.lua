local Remotes = require(game.ReplicatedStorage.Remotes)

local RoomRemotes = {}

RoomRemotes.AddRoom = Remotes.Server:Create("AddRoom")
RoomRemotes.RemoveRoom = Remotes.Server:Create("RemoveRoom")
RoomRemotes.JoinRoom = Remotes.Server:Create("JoinRoom")
RoomRemotes.LeaveRoom = Remotes.Server:Create("LeaveRoom")
RoomRemotes.SetMap = Remotes.Server:Create("SetMap")
RoomRemotes.PlayMap = Remotes.Server:Create("PlayMap")
RoomRemotes.Ready = Remotes.Server:Create("Ready")
RoomRemotes.UpdateMAValues = Remotes.Server:Create("UpdateMAValues")
RoomRemotes.Finished = Remotes.Server:Create("Finished")
RoomRemotes.Abort = Remotes.Server:Create("Abort")

return RoomRemotes
