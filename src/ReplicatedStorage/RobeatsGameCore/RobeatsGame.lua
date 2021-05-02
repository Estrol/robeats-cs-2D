local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)
local InputUtil = require(game.ReplicatedStorage.Shared.InputUtil)
local SPDict = require(game.ReplicatedStorage.Shared.SPDict)
local AudioManager = require(game.ReplicatedStorage.RobeatsGameCore.AudioManager)
local ObjectPool = require(game.ReplicatedStorage.RobeatsGameCore.ObjectPool)
local SFXManager = require(game.ReplicatedStorage.RobeatsGameCore.SFXManager)
local ScoreManager = require(game.ReplicatedStorage.RobeatsGameCore.ScoreManager)
local NoteTrackSystem = require(game.ReplicatedStorage.RobeatsGameCore.NoteTrack.NoteTrackSystem)
local EffectSystem = require(game.ReplicatedStorage.RobeatsGameCore.Effects.EffectSystem)
local GameSlot = require(game.ReplicatedStorage.RobeatsGameCore.Enums.GameSlot)
local GameTrack = require(game.ReplicatedStorage.RobeatsGameCore.Enums.GameTrack)
local AssertType = require(game.ReplicatedStorage.Shared.AssertType)
local Signal = require(game.ReplicatedStorage.Knit.Util.Signal)

--local Settings = require(game.ReplicatedStorage.)

local RobeatsGame = {}
RobeatsGame.Mode = {
	Setup = 1;
	Game = 2;
	GameEnded = 3;
}

function RobeatsGame:new(_game_environment_center_position)
	local self = {
		_tracksystems = SPDict:new();
		_audio_manager = nil;
		_score_manager = nil;
		_effects = EffectSystem:new();
		_input = InputUtil:new();
		_sfx_manager = SFXManager:new();
		_object_pool = ObjectPool:new();
	}

	local _show_hit_lighting = false

	self._audio_manager = AudioManager:new(self)
	self._score_manager = ScoreManager:new(self)

	self._mode_changed = Signal.new()
	
	local _local_game_slot = 0
	function self:get_local_game_slot() return _local_game_slot end
	
	local _current_mode = RobeatsGame.Mode.Setup
	function self:get_mode() return _current_mode end
	function self:set_mode(val) 
		AssertType:is_enum_member(val, RobeatsGame.Mode)
		_current_mode = val 
		self._mode_changed:Fire(_current_mode)
	end

	function self:set_hit_lighting(val) _show_hit_lighting = val end
	function self:get_hit_lighting() return _show_hit_lighting end

	function self:get_game_environment_center_position()
		return _game_environment_center_position
	end

	function self:setup_world(game_slot)
		_local_game_slot = game_slot
		workspace.CurrentCamera.CFrame = GameSlot:slot_to_camera_cframe_offset(self:get_local_game_slot()) + self:get_game_environment_center_position()
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		workspace.CurrentCamera.CameraSubject = nil
	end

	function self:start_game()
		self._tracksystems:add(self:get_local_game_slot(),NoteTrackSystem:new(self,self:get_local_game_slot()))
		self._audio_manager:start_play()
		_current_mode = RobeatsGame.Mode.Game
	end

	function self:get_tracksystem(index)
		return self._tracksystems:get(index)
	end
	function self:get_local_tracksystem()
		return self:get_tracksystem(self:get_local_game_slot())
	end
	function self:tracksystems_itr()
		return self._tracksystems:key_itr()
	end
	
	function self:update(dt_scale)
		if _current_mode == RobeatsGame.Mode.Game then
			self._audio_manager:update(dt_scale)
			for itr_key,itr_index in GameTrack:inpututil_key_to_track_index():key_itr() do
				if self._input:control_just_pressed(itr_key) then
					self:get_local_tracksystem():press_track_index(itr_index)
				end
				if self._input:control_just_released(itr_key) then
					self:get_local_tracksystem():release_track_index(itr_index)
				end
			end
			
			for _, itr in self._tracksystems:key_itr() do
				itr:update(dt_scale)
			end
			
			self._sfx_manager:update()
			self._score_manager:update()
			self._effects:update(dt_scale)
			self._input:post_update()
		end
	end

	function self:load(_song_key, _local_player_slot, _config)
		EnvironmentSetup:set_mode(EnvironmentSetup.Mode.Game)

		self._audio_manager:load_song(_song_key, _config)
		self:setup_world(_local_player_slot)
	end
	
	function self:teardown()
		for _, val in self:tracksystems_itr() do
			val:teardown()
		end
		self._audio_manager:teardown()
		self._effects:teardown() 

		EnvironmentSetup:set_mode(EnvironmentSetup.Mode.Menu)
	end

	return self
end

return RobeatsGame
