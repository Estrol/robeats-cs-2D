local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Loading = require(script.Parent.OtherLoading)

return function(target)
	local app = Roact.createElement(Loading)
	local handle = Roact.mount(app, target)

	return function()
		Roact.unmount(handle)
	end
end