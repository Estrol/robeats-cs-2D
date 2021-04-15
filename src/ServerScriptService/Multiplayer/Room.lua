local SPList = require(game.ReplicatedStorage.Shared.SPList)
local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)
local AssertType = require(game.ReplicatedStorage.Shared.AssertType)
local HttpService = game:GetService("HttpService")

local RoomRemotes = require(game.ServerScriptService.GameServer.Multiplayer.RoomRemotes)

local Room = {}

function Room:new()
    local self = {}
    self.players = SPList:new()
    self.selected_song_key = 1
    self.name = "name"
    self.id = HttpService:GenerateGUID()

    local _remotes = {
        _player_added = RoomRemotes.PlayerAdded;
        _player_removing = RoomRemotes.PlayerRemoving
    }

    function self:set_host(host)
        AssertType:is_classname(host, "Player", "Host must be a Player instance!")
        self.host = host
	end
	
	function self:set_name(name)
		AssertType:is_string(name, "Name must be a valid string!")
		self.name = name
	end

    function self:random_host()
        local _key = self.players:key_list():random()
        self.host = self.players:get(_key)
    end

    function self:add_player(plr)
        AssertType:is_classname(plr, "Player")
        self.players:push_back(plr)

        DebugOut:puts("Player added(%s) to room(%s) ROOM ID: %s", plr.Name, self.name, self.id)

        _remotes._player_added:SendToAllPlayers(plr, self:get_metadata())
        return self:get_metadata()
    end

    function self:get_players_list()
        local ret = {}
        for _, v in self.players:key_itr() do
            ret[#ret+1] = v
        end
        return ret
    end

    function self:remove_player(plr)
        AssertType:is_classname(plr, "Player")
        for i = 1, self.players:count() do
            local itr_player = self.players:get(i)
            if itr_player.UserId == plr.UserId then
                self.players:remove_at(i)
                _remotes._player_removing:SendToAllPlayers(itr_player, self:get_metadata())
                break
            end
        end

        return self.players:count() == 0
    end

    function self:change_song_key(key)
        AssertType:is_number(key, "Key must be a number!")
        self.selected_song_key = key
    end

    function self:is_host(player)
        AssertType:is_classname(player, "Player")
        return self.host.UserId == player.UserId
    end

    function self:get_metadata()
        return {
            name = self.name;
            id = self.id;
            selected_song_key = self.selected_song_key;
            host = self.host;
            players = self.players._table;
        }
    end

    return self
end

return Room