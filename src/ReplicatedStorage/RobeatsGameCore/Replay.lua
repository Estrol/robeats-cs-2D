local SongDatabase = require(game:GetService("ReplicatedStorage").RobeatsGameCore.SongDatabase)
local NoteResult = require(game:GetService("ReplicatedStorage").RobeatsGameCore.Enums.NoteResult)
local SocialService = game:GetService("SocialService")

local Replay = {}

Replay.HitType = {
    Press = 1,
    Release = 2,
}

function Replay:new(viewing)
    local self = {}
    self.viewing = not not viewing
    self.hits = {}

    local minIndex = 1

    function self:add_replay_hit(hit)
        table.insert(self.hits, hit)
    end

    function self:get_hits()
        return self.hits
    end

    function self:get_actions_this_frame(time)
        local actions = {}

        for i = minIndex, #self.hits do
            local hit = self.hits[i]

            if time >= hit.time then
                table.insert(actions, hit)
                minIndex += 1
            else
                break
            end
        end

        return actions
    end

    return self
end

function Replay.perfect(hash, rate)
    local hitObjects = SongDatabase:get_hit_objects_for_key(SongDatabase:get_key_for_hash(hash), rate / 100)

    local replay = Replay:new()

    for _, hitObject in ipairs(hitObjects) do
        if hitObject.Type == 1 then
            replay:add_replay_hit({
                time = hitObject.Time,
                track = hitObject.Track,
                action = Replay.HitType.Press,
                judgement = NoteResult.Marvelous,
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
                action = Replay.HitType.Press,
                judgement = NoteResult.Marvelous,
            })

            replay:add_replay_hit({
                time = hitObject.Time + hitObject.Duration,
                track = hitObject.Track,
                action = Replay.HitType.Release,
                judgement = NoteResult.Marvelous,
            })
        end
    end

    local hits = replay:get_hits()

    table.sort(hits, function(a, b)
        if a.time == b.time then
            return a.action < b.action
        end

        return a.time < b.time
    end)

    return replay
end

return Replay
