custom_lifestealer_feast = class({})
LinkLuaModifier( "custom_modifier_lifestealer_feast", "heroes/lifestealer/modifiers/custom_modifier_lifestealer_feast", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function custom_lifestealer_feast:GetIntrinsicModifierName()
	return "custom_modifier_lifestealer_feast"
end