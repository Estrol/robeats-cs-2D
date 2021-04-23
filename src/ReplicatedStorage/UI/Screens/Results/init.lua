local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local Grade = require(game.ReplicatedStorage.RobeatsGameCore.Enums.Grade)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local ResultsScreenMain = Roact.Component:extend("ResultsScreenMain")

local SpreadDisplay = require(script.SpreadDisplay)
local BannerCard = require(script.BannerCard)
local DataDisplay = require(script.DataDisplay)

function ResultsScreenMain:init()
	self.grade_images = {
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

function ResultsScreenMain:willUnmount()
	self.backOutConnection:Disconnect()
end

function ResultsScreenMain:render()
	local state = self.props.location.state

	local grade = Grade:get_grade_from_accuracy(state.accuracy)

    return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		BorderSizePixel = 0;
		Size = UDim2.new(1, 0, 1, 0);
	}, {
		-- HitGraph = Roact.createElement(DotGraph, {
		-- 	AnchorPoint = Vector2.new(1, 1),
		-- 	BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		-- 	BorderSizePixel = 0,
		-- 	Position = UDim2.new(0.99, 0, 0.98, 0),
		-- 	Size = UDim2.new(0.485, 0, 0.5, 0),
		-- 	bounds = {
		-- 		min = {
		-- 			y = -350;
		-- 		};
		-- 		max = {
		-- 			y = 350;
		-- 		}
		-- 	};
		-- 	interval = {
		-- 		y = 50;
		-- 	};
		-- 	points = self.props.state.hitDeviance;
		-- }),
		-- SpreadDisplay = Roact.createElement(SpreadDisplay, {
		-- 	AnchorPoint = Vector2.new(0,1),
		-- 	Position = UDim2.new(0.01,0,0.98,0),
		-- 	Size = UDim2.new(0.485,0,0.5,0),
		-- 	marvelouses = state.marvelouses,
		-- 	perfects = state.perfects,
		-- 	greats = state.greats,
		-- 	goods = state.goods,
		-- 	bads = state.bads,
		-- 	misses = state.misses
		-- }),
		BannerCard = Roact.createElement(BannerCard, {
			AnchorPoint = Vector2.new(0.5,0);
			song_key = self.props.selectedSongKey or 1;
			playername = "kisperal";
			Position = UDim2.new(0.5,0,0.01,0);
			Size = UDim2.new(0.98,0,0.3,0);
			grade_image = self.grade_images[grade];
		});
		DataDisplay = Roact.createElement(DataDisplay, {
			data = {
				{
					Name = "Score";
					Value = string.format("%d", state.score);
				};
				{
					Name = "Accuracy";
					Value = string.format("%0.2f%%", state.accuracy);
				};
				{
					Name = "Play Rating";
					Value = string.format("%0.2f", state.rating or 0);
				};
				{
					Name = "Max Combo";
					Value = state.maxCombo
				};
				{
					Name = "Mean";
					Value = string.format("%0d ms", 0);
				};
			};
			Position = UDim2.new(0.5,0,0.32,0);
			Size = UDim2.new(0.98,0,0.15,0);
			AnchorPoint = Vector2.new(0.5,0);
		});
		GoBack = Roact.createElement(RoundedTextButton, {
			BackgroundColor3 = Color3.fromRGB(236, 33, 33);
			AnchorPoint = Vector2.new(0, 1);
			Position = UDim2.fromScale(0.0135, 0.3);
			Size = UDim2.new(0.07,0,0.065,0);
			HoldSize = UDim2.fromScale(0.09, 0.065);
			Text = "Go Back";
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 16,
			ZIndex = 5,
			OnClick = function()
				self.props.history:push("/")
			end
		})
	})
end

return ResultsScreenMain
