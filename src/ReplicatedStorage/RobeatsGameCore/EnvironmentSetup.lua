local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)
local SPDict = require(game.ReplicatedStorage.Shared.SPDict)
local AssertType = require(game.ReplicatedStorage.Shared.AssertType)
local SkinManager = require(game.ReplicatedStorage.Skins.SkinManager)

local EnvironmentSetup = {}
EnvironmentSetup.Mode = {
	Menu = 0;
	Game = 1;
}

EnvironmentSetup.LaneMode = {
	['2D'] = 0;
	['3D'] = 1;
}

local _game_environment
local _element_protos_folder
local _local_elements_folder
local _player_gui
local _skin_manager
local _current_skin

function EnvironmentSetup:initial_setup()
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

	_skin_manager = SkinManager:new()

	_game_environment = game.Workspace.GameEnvironment
	_game_environment.Parent = nil
	
	_element_protos_folder = game.Workspace.ElementProtos
	_element_protos_folder.Parent = game.ReplicatedStorage
	
	_local_elements_folder = Instance.new("Folder",game.Workspace)
	_local_elements_folder.Name = "LocalElements"

	_player_gui = Instance.new("ScreenGui")
	_player_gui.Parent = game.Players.LocalPlayer.PlayerGui
	_player_gui.IgnoreGuiInset = false
	_player_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end

-- from Estrol: You might want re-writte this to Roact or just leave it
-- to support existing rosu!mania skin

-- @param {string} skin
-- @return {bool}
function EnvironmentSetup:set_skin(name)
	local skin = _skin_manager:get_skin_from_name(name)
	if skin == nil then
		return false
	end
	_current_skin = skin
	return true
end

function EnvironmentSetup:get_2d_skin()
	return _current_skin.Data
end

function EnvironmentSetup:get_2d_skin_info()
	return _current_skin
end

function EnvironmentSetup:get_current_lane_mode()
	return EnvironmentSetup.LaneMode['2D']
end

function EnvironmentSetup:setup_2d_environment()
	local gameplayframe = _current_skin.Data:FindFirstChild("GameplayFrame"):Clone()
	if gameplayframe == nil then
		DebugOut:errf("[EnvironmentSetup] something went wrong.. missing GameplayFrame in skin and this shouldn't happen after skin loaded")
	end

	local hit_pos = 10

	gameplayframe.Parent = EnvironmentSetup:get_player_gui_root()
	gameplayframe.Position = UDim2.new(0.5, 0, 1, 0)

	local tracks = gameplayframe.Tracks
	local triggerbuttons = gameplayframe.TriggerButtons
	if #triggerbuttons:GetChildren() == 0 then
		for i,proto in pairs(_current_skin.GameplayFrame.TriggerButtons:Clone():GetChildren()) do
			proto.Parent = triggerbuttons
		end
	end

	triggerbuttons.Size = UDim2.new(1, 0, hit_pos/100, 0)
	tracks.Size = UDim2.new(1, 0, 1-hit_pos/100, 0)
end

function EnvironmentSetup:reset_2d_environment()
	local gameplayframe = EnvironmentSetup:get_player_gui_root():FindFirstChild("GameplayFrame")
	if gameplayframe == nil then
		DebugOut:warnf("[EnvironmentSetup] this shouldn't happen if 2D setting enabled... but if from 3D why you called it???")
	end

	gameplayframe.ResultPopups:ClearAllChildren()
	local triggerbuttons = gameplayframe.TriggerButtons
	for i=1,4 do
		for j,proto in pairs(triggerbuttons["Button"..i]:GetChildren()) do
			if proto.Name == "EffectProto" then
				proto:Destroy()
			end
		end
	end

	gameplayframe:Destroy()
end

function EnvironmentSetup:set_mode(mode)
	AssertType:is_enum_member(mode, EnvironmentSetup.Mode)
	if mode == EnvironmentSetup.Mode.Game then
		_game_environment.Parent = game.Workspace
	else
		_game_environment.Parent = nil
	end
end

function EnvironmentSetup:get_game_environment_center_position()
	return _game_environment.GameEnvironmentCenter.Position
end

function EnvironmentSetup:get_game_environment()
	return _game_environment
end

function EnvironmentSetup:get_element_protos_folder()
	return _element_protos_folder
end

function EnvironmentSetup:get_local_elements_folder()
	return _local_elements_folder
end

function EnvironmentSetup:get_player_gui_root()
	return _player_gui
end

function EnvironmentSetup:get_robeats_game_stage()
	return _game_environment.Platform
end

return EnvironmentSetup
