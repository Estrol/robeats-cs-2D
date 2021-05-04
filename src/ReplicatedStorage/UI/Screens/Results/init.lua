local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local RunService = game:GetService("RunService")

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local NoteResult = require(game.ReplicatedStorage.RobeatsGameCore.Enums.NoteResult)
local Grade = require(game.ReplicatedStorage.RobeatsGameCore.Enums.Grade)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local Results = Roact.Component:extend("Results")

local DotGraph = require(game.ReplicatedStorage.UI.Components.Graph.DotGraph)
local SpreadDisplay = require(script.SpreadDisplay)
local BannerCard = require(script.BannerCard)
local DataDisplay = require(script.DataDisplay)

function Results:init()
	if RunService:IsRunning() then
		self.knit = require(game:GetService("ReplicatedStorage").Knit)
	end

	self.gradeImages = {
		[Grade.SS] = "http://www.roblox.com/asset/?id=5702584062",
		[Grade.S] = "http://www.roblox.com/asset/?id=5702584273",
		[Grade.A] = "http://www.roblox.com/asset/?id=5702584488",
		[Grade.B] = "http://www.roblox.com/asset/?id=5702584846",
		[Grade.C] = "http://www.roblox.com/asset/?id=5702585057",
		[Grade.D] = "http://www.roblox.com/asset/?id=5702585272",
		[Grade.F] = "http://www.roblox.com/asset/?id=5702585272"
	}
	
	self.backOutConnection = SPUtil:bind_to_key(Enum.KeyCode.Return, function()
		self.props.history:push("/select")
	end)
end

function Results:didMount()
	if self.knit then
		local PreviewController = self.knit.GetController("PreviewController")

		PreviewController:PlayId("rbxassetid://6419511015", function(audio)
			audio.TimePosition = 0
		end, 0.12)
	end
end

function Results:willUnmount()
	self.backOutConnection:Disconnect()
end

function Results:render()
	local state = self.props.location.state

	local grade = Grade:get_grade_from_accuracy(state.Accuracy)

	local hits = state.Hits or {}
	local mean = state.Mean or 0

    return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0;
		Size = UDim2.new(1, 0, 1, 0);
	}, {
		UIGradient = Roact.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(17, 17, 17)),
			}),
			Rotation = 45
		}),
		HitGraph = Roact.createElement(DotGraph, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BorderSizePixel = 0,
			Position = UDim2.new(0.75, 0, 0.675, 0),
			Size = UDim2.new(0.4, 0, 0.35, 0),
			bounds = {
				min = {
					y = -350;
				};
				max = {
					y = 350;
				}
			};
			interval = {
				y = 50;
			};
			points = hits;
			formatPoint = function(hit)
				return {
					x = (hit.hit_object_time + hit.time_left) / (SongDatabase:get_song_length_for_key(state.SongKey, state.Rate / 100) + 3300),
					y = SPUtil:inverse_lerp(-300, 300, hit.time_left),
					color = NoteResult:result_to_color(hit.judgement)
				}
			end
		}),
		SpreadDisplay = Roact.createElement(SpreadDisplay, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.25, 0, 0.675, 0),
			Size = UDim2.new(0.4, 0, 0.35, 0),
			Marvelouses = state.Marvelouses,
			Perfects = state.Perfects,
			Greats = state.Greats,
			Goods = state.Goods,
			Bads = state.Bads,
			Misses = state.Misses
		}),
		BannerCard = Roact.createElement(BannerCard, {
			AnchorPoint = Vector2.new(0.5,0);
			SongKey = state.SongKey;
			PlayerName = state.PlayerName;
			TimePlayed = state.TimePlayed;
			Position = UDim2.new(0.5,0,0.05,0);
			Size = UDim2.new(0.95,0,0.2,0);
			SongRate = state.Rate;
			GradeImage = self.gradeImages[grade];
		});
		DataDisplay = Roact.createElement(DataDisplay, {
			data = {
				{
					Name = "Score";
					Value = string.format("%d", state.Score);
				};
				{
					Name = "Accuracy";
					Value = string.format("%0.2f%%", state.Accuracy);
				};
				{
					Name = "Play Rating";
					Value = string.format("%0.2f", state.Rating);
				};
				{
					Name = "Max Combo";
					Value = state.MaxChain
				};
				{
					Name = "Mean";
					Value = string.format("%0d ms", mean);
				};
			};
			Position = UDim2.new(0.5,0,0.28,0);
			Size = UDim2.new(0.95,0,0.1,0);
			AnchorPoint = Vector2.new(0.5,0);
		});
		GoBack = Roact.createElement(RoundedTextButton, {
			BackgroundColor3 = Color3.fromRGB(236, 33, 33);
			AnchorPoint = Vector2.new(0, 1);
			Position = UDim2.fromScale(0.0135, 0.98);
			Size = UDim2.new(0.07,0,0.065,0);
			HoldSize = UDim2.fromScale(0.09, 0.065);
			Text = "Go Back";
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 16,
			ZIndex = 5,
			OnClick = function()
				self.props.history:push("/select")
			end
		})
	})
end

return Results
