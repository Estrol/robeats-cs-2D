local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

SPUtil:make("Folder", {
    Name = "GameRooms",
    Parent = workspace
})

-- IMPORT REMOTES
local RoomRemotes = require(game.ServerScriptService.GameServer.Multiplayer.RoomRemotes)

-- IMPORT MANAGERS
local MultiplayerAPI = require(game.ServerScriptService.API.MultiplayerAPI)

-- BIND REMOTES
RoomRemotes.AddRoom:SetCallback(MultiplayerAPI.BuildMPRoom)
RoomRemotes.JoinRoom:SetCallback(MultiplayerAPI.JoinRoom)
RoomRemotes.LeaveRoom:SetCallback(MultiplayerAPI.LeaveRoom)
RoomRemotes.SetMap:SetCallback(MultiplayerAPI.SetMap)
RoomRemotes.PlayMap:SetCallback(MultiplayerAPI.PlayMap)
RoomRemotes.Ready:SetCallback(MultiplayerAPI.Ready)
RoomRemotes.UpdateMAValues:SetCallback(MultiplayerAPI.UpdateMAValues)
RoomRemotes.Finished:Connect(MultiplayerAPI.Finished)