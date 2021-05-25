local SPList = require(game.ReplicatedStorage.Shared.SPList)
local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)
local SkinManager = {}

function SkinManager:new()
    local self = {}
    self._list = SPList:new()

    function self:cons()
        local itr = 1
        local list = game.ReplicatedStorage.Skins:GetChildren()
        for i, itr_node in pairs(list) do
            if itr_node:IsA("Folder") then
                local info_file = itr_node:FindFirstChild("SkinInfo")
                if info_file ~= nil and info_file:IsA("ModuleScript") then
                    local info = require(info_file)

                    --[[ Skin checks ]]
                    if itr_node:FindFirstChild("GameplayFrame") == nil then
                        DebugOut:warnf("[Error] Folder GameplayFrame missing from skin folder "..itr_node.Name)
                    elseif itr_node:FindFirstChild("HeldNoteProto") == nil then
                        DebugOut:warnf("[Error] Folder HeldNoteProto missing from skin folder "..itr_node.Name)
                    elseif itr_node:FindFirstChild("EffectProto") == nil then
                        DebugOut:warnf("[Error] Folder EffectProto missing from skin folder "..itr_node.Name)
                    elseif itr_node:FindFirstChild("NoteProto") == nil then
                        DebugOut:warnf("[Error] Folder NoteProto missing from skin folder "..itr_node.Name)
                    elseif itr_node:FindFirstChild("ButtonColor") == nil then
                        DebugOut:warnf("[Error] Folder ButtonColor missing from skin folder "..itr_node.Name)
                    else    
                        info.ModuleName = itr_node.Name
                        info.Number = itr
                        itr = itr + 1
    
                        info.Data = itr_node
                        self._list:push_back(info)
    
                        print('[2D SKIN MANAGER] Loaded skin '..info.ModuleName)
                    end
                end
            end
        end

        print(string.format('[2D SKIN MANAGER] Loaded like %d skins', itr))
    end

    function self:get_skin(index)
		for i=1, self._list:count() do
			local itr_skin = self._list:get(i)
			if itr_skin.Number == index then
				return itr_skin
			end
		end
		
		return nil
	end
	
	function self:get_skin_from_name(name)
		for i=1, self._list:count() do
			local itr_skin = self._list:get(i)
			if itr_skin.Name == name then
				return itr_skin
			end
		end

		return nil
	end
	
	function self:get_skin_list_index()
		local names = {}
		for i=1, self._list:count() do
			local itr_skin = self._list:get(i)
			table.insert(names, #names+1, {
				name = itr_skin.Name,
				index = itr_skin.Number
			})
		end
		
		return names
	end

    self:cons()
    return self
end

return SkinManager