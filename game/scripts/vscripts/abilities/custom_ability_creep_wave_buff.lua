custom_ability_creep_wave_buff = class({})

LinkLuaModifier(
	"custom_modifier_creep_wave_buff",
	"modifiers/custom_modifier_creep_wave_buff",
	LUA_MODIFIER_MOTION_NONE
)

function custom_ability_creep_wave_buff:GetIntrinsicModifierName()
	return "custom_modifier_creep_wave_buff"
end