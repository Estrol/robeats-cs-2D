local Promise = require(game.ReplicatedStorage.Knit.Util.Promise)
local HttpService = game:GetService("HttpService")

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local RequestService = Knit.CreateService {
    Name = "RequestService";
    Client = {};
}

function RequestService:RequestAsync(url, method, headers, body)
    local data = {
        Headers = headers,
        Url = url,
        Body = body,
        Method = method
    }

    return Promise.new(function(resolve, reject)
        local response = HttpService:RequestAsync(data)

        SPUtil:try(function()
            response.DecodedBody = HttpService:JSONDecode(response.Body)
        end)

        resolve(response)
    end)
end


return RequestService