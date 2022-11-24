
--------------------------------------------------------------------------------
custom_modifier_drow_ranger_frost_arrows_freeze_grace = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_drow_ranger_frost_arrows_freeze_grace:IsHidden()
	return true
end

function custom_modifier_drow_ranger_frost_arrows_freeze_grace:IsDebuff()
	return false
end

function custom_modifier_drow_ranger_frost_arrows_freeze_grace:IsPurgable()
	return false
end