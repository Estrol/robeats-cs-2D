local Tiers = {}

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local TierRatingMap = {
    { name = "Prism", minRating = 2450 },
    { name = "Ultraviolet", minRating = 2100 },
    { name = "Emerald", minRating = 1800 },
    { name = "Diamond", minRating = 1500 },
    { name = "Gold", minRating = 1200 },
    { name = "Silver", minRating = 850 },
    { name = "Bronze", minRating = 500 },
    { name = "Tin", minRating = 350 }
}

function Tiers:GetTierFromRating(rating)
    for i, tier in ipairs(TierRatingMap) do
        if i == #TierRatingMap and rating < tier.minRating then
            return {
                name = tier.name,
                division = 1,
                subdivision = 1,
                tierBaseValue = i
            }
        end

        if rating >= tier.minRating or i == #TierRatingMap then
            if i ~= 1 then
                local nextTier = TierRatingMap[i - 1]

                for x = 2, 0, -1 do
                    local divisionBorder = SPUtil:lerp(tier.minRating, nextTier.minRating, x / 3)

                    if rating >= divisionBorder then
                        local nextDivisionBorder = if x == 2 then nextTier.minRating else SPUtil:lerp(tier.minRating, nextTier.minRating, (x + 1) / 3)
                        
                        for y = 3, 0, -1 do
                            local subdivisionBorder = SPUtil:lerp(divisionBorder, nextDivisionBorder, y / 4)

                            if rating >= subdivisionBorder then
                                return {
                                    name = tier.name,
                                    division = x + 1,
                                    subdivision = y + 1,
                                    tierBaseValue = i
                                }
                            end
                        end
                    end
                end
            else
                return {
                    name = tier.name
                }
            end
        end
    end
end

function Tiers:GetStringForTier(tier, omitSubdivision)
    local str = tier.name

    if tier.division then
        str ..= " " .. string.rep("I", tier.division)

        if not omitSubdivision then
            str ..= " Division " .. if tier.subdivision == 4 then "IV" else string.rep("I", tier.subdivision)
        end
    end

    return str
end

return Tiers
