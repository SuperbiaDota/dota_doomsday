custom_troll_warlord_fervor = class({})
LinkLuaModifier( "custom_modifier_troll_warlord_fervor", "heroes/troll_warlord/modifiers/custom_modifier_troll_warlord_fervor", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function custom_troll_warlord_fervor:GetIntrinsicModifierName()
	return "custom_modifier_troll_warlord_fervor"
end