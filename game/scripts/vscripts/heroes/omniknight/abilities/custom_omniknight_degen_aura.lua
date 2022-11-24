-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
custom_omniknight_degen_aura = class({})
LinkLuaModifier( 
    "custom_modifier_omniknight_degen_aura", 
    "heroes/omniknight/modifiers/custom_modifier_omniknight_degen_aura", 
    LUA_MODIFIER_MOTION_NONE 
)
LinkLuaModifier( 
    "custom_modifier_omniknight_degen_aura_effect", 
    "heroes/omniknight/modifiers/custom_omniknight_degen_aura_effect", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Passive Modifier
function custom_omniknight_degen_aura:GetIntrinsicModifierName()
	return "custom_modifier_omniknight_degen_aura_effect"
end
