
custom_modifier_tinker_laser_blind = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_tinker_laser_blind:IsHidden()
	return false
end

function custom_modifier_tinker_laser_blind:IsDebuff()
	return true
end

function custom_modifier_tinker_laser_blind:IsPurgable()
	return true
end


--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_tinker_laser_blind:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}
end

function custom_modifier_tinker_laser_blind:GetModifierMiss_Percentage( )
    return 100
end
