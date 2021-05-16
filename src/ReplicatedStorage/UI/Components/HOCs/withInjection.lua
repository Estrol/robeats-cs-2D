local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local e = Roact.createElement

local DIContext = require(game.ReplicatedStorage.Contexts.DIContext)

local function withInjection(wrappedComponent, dependencyMap)
    local function InjectedComponent(props)
        return e(DIContext.Consumer, {
            render = function(dependencies)
                local depProps = {}
    
                for propName, dependencyName in pairs(dependencyMap) do
                    depProps[propName] = dependencies[dependencyName]
                end
    
                local mappedProps = Llama.Dictionary.join(depProps, props)
                return e(wrappedComponent, mappedProps)
            end
        })
    end

    return InjectedComponent
end

return withInjection
