
function FindClosestToPoint(units, point)
    local target = {}
    closest = math.huge
    for i,unit in ipairs(units) do
        -- Positioning and distance variables
        local unit_location = unit:GetAbsOrigin()
        local vector_distance = point - unit_location
        local distance = (vector_distance):Length2D()
        -- If the unit is closer than the closest checked so far, then we set its distance as the new closest distance and it as the new target
        if distance < closest then
            closest = distance
            target = unit
        end
    end
    return target
end

--[[
	kv and default values:
	{
		caster,
		ability,
		point,
		radius,
		all_valid_heroes 	= false, -- returns all valid hero targets
		all_valid_units		= false, -- returns all valid unit targets
		prioritize_heroes 	= false
	}
]]

function SearchArea(key)
    local caster = key.caster
    local ability = key.ability
    local point = key.point
	local radius = key.radius
	local all_valid_heroes = key.all_valid_heroes
	local all_valid_units = key.all_valid_units
	local prioritize_heroes = key.prioritize_heroes

    local targets = {}

	if (prioritize_heroes or all_valid_heroes) and not (all_valid_units) then
		-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
		local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO, 0, 0, false)
		if all_valid_heroes then
			targets = units
		else
			targets[1] = FindClosestToPoint(units, point)
		end
	end

    -- Checks if the target was set in the last block (checking for heroes in the aoe)
    if target[1] == nil then
        local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), 0, 0, false)
		if all_valid_units then
			targets = units
		else
			targets[1] = FindClosestToPoint(units, point)
		end
    end
    return targets
end
