local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local function weightingPercentage(x)
	if x == 100 then return 110
    elseif x >= 90 then return -116640 + (64595/18)*x - (9937/270)*x^2 + (17/135)*x^3
    elseif x >= 85 then return 6040 - (851/6)*x + (5/6)*x^2
    elseif x >= 75 then return 0.5*x - 37.5
    else return 0 end
end

local Rating = {}

function Rating:get_rating_from_accuracy(song_key, accuracy, rate)
    rate = rate or 1

    local difficulty = SongDatabase:get_data_for_key(song_key).AudioDifficulty
    local ratemult = 1

	if rate then
		if rate >= 1 then
			ratemult = 1 + (rate-1) * 1.3
		else
			ratemult = 1 + (rate - 1) * 1.15
		end
	end

	return ratemult *  difficulty * weightingPercentage(accuracy)/100
end

return Rating
