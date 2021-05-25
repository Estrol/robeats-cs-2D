local EffectSystem = require(game.ReplicatedStorage.RobeatsGameCore.Effects.EffectSystem)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local CurveUtil = require(game.ReplicatedStorage.Shared.CurveUtil)
local NoteResult = require(game.ReplicatedStorage.RobeatsGameCore.Enums.NoteResult)
local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)

local TriggerNoteEffect = {}
TriggerNoteEffect.Type = "TriggerNoteEffect"

function TriggerNoteEffect:new(_game, _position, _result)
	local self = EffectSystem:EffectBase()
	self.ClassName = TriggerNoteEffect.Type

	local _effect_obj = nil
	local _anim_t = 0

	local function update_visual()
		_effect_obj.ImageTransparency = _anim_t
	end

	function self:cons()
		local _skin = EnvironmentSetup:get_2d_skin()
		local proto = _skin.EffectProto

		_effect_obj = _game._object_pool:depool(self.ClassName)
		if _effect_obj == nil then
			_effect_obj = EffectProto:Clone()
			_effect_obj.ImageTransparency = .5
		end

		_anim_t = 0
		update_visual()
	end

	--[[Override--]] function self:add_to_parent(parent)
		local gameplayframe = EnvironmentSetup:get_player_gui_root()
		local buttons = gameplayframe.TriggerButtons
		_effect_obj.Parent = buttons['Button'.._track_index]
	end

	--[[Override--]] function self:update(dt_scale)
		_anim_t = _anim_t + CurveUtil:SecondsToTick(0.25) * dt_scale
		update_visual()
	end
	--[[Override--]] function self:should_remove()
		return _anim_t >= 1
	end
	--[[Override--]] function self:do_remove()
		_game._object_pool:repool(self.ClassName, _effect_obj)
	end

	self:cons(_game)
	return self
end

return TriggerNoteEffect
