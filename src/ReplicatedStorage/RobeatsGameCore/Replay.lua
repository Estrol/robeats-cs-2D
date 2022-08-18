local SongDatabase = require(game:GetService("ReplicatedStorage").RobeatsGameCore.SongDatabase)

local Replay = {}

Replay.HitType = {
    Press = 1,
    Release = 2,
}

function Replay:new()
    local self = {}
    self.hits = {}

    local index = 1

    function self:add_replay_hit(hit)
        table.insert(self.hits, hit)
    end

    function self:get_actions_this_frame(time)
        local actions = {}

        while index <= #self.hits and self.hits[index].time <= time do
            -- print(time, self.hits[index].time)

            table.insert(actions, self.hits[index])
            index = index + 1
        end

        return actions
    end

    return self
end

function Replay.perfect(hash, rate)
    local hitObjects = SongDatabase:get_hit_objects_for_key(SongDatabase:get_key_for_hash(hash), rate / 100)

    local replay = Replay:new()

    for _, hitObject in pairs(hitObjects) do
        if hitObject.Type == 1 then
            replay:add_replay_hit({
                time = hitObject.Time,
                track = hitObject.Track,
                action = Replay.HitType.Press
            })

            replay:add_replay_hit({
                time = hitObject.Time,
                track = hitObject.Track,
                action = Replay.HitType.Release
            })
        else
            replay:add_replay_hit({
                time = hitObject.Time,
                track = hitObject.Track,
                action = Replay.HitType.Press
            })

            replay:add_replay_hit({
                time = hitObject.Time + hitObject.Duration,
                track = hitObject.Track,
                action = Replay.HitType.Release
            })
        end
    end

    return replay
end

return Replay
