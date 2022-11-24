
--------------------------------------------------------------------------------
custom_modifier_meepo_divided_we_stand_mute = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_meepo_divided_we_stand_mute:IsHidden()
	return false
end

function custom_modifier_meepo_divided_we_stand_mute:IsDebuff()
	return true
end

function custom_modifier_meepo_divided_we_stand_mute:IsPurgable()
	return false
end

function custom_modifier_meepo_divided_we_stand_mute:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_meepo_divided_we_stand_mute:CheckState()
	local state = {
		[MODIFIER_STATE_MUTED] = true,
	}

	return state
end