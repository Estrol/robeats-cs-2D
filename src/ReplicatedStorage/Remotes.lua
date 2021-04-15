local Net = require(game.ReplicatedStorage.Packages.Net)

local Remotes = Net.Definitions.Create({
  SubmitScore = Net.Definitions.Event(),
  GetScores = Net.Definitions.AsyncFunction(),
  GetMaps = Net.Definitions.AsyncFunction(),
  GetHitData = Net.Definitions.AsyncFunction(),
  AddRoom = Net.Definitions.AsyncFunction(),
  JoinRoom = Net.Definitions.AsyncFunction(),
  RemoveRoom = Net.Definitions.AsyncFunction(),
  LeaveRoom = Net.Definitions.AsyncFunction(),
  SetMap = Net.Definitions.AsyncFunction(),
  PlayMap = Net.Definitions.AsyncFunction(),
  GetRoom = Net.Definitions.AsyncFunction(),
  GetRooms = Net.Definitions.AsyncFunction(),
  Ready = Net.Definitions.AsyncFunction(),
  UpdateMAValues = Net.Definitions.AsyncFunction(),
  Finished = Net.Definitions.Event(),
  Abort = Net.Definitions.AsyncFunction()
})

return Remotes