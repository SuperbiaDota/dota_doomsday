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
custom_modifier_meepo_earthbind = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_meepo_earthbind:IsHidden()
	return false
end

function custom_modifier_meepo_earthbind:IsDebuff()
	return true
end

function custom_modifier_meepo_earthbind:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_meepo_earthbind:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
end

function custom_modifier_meepo_earthbind:GetModifierProvidesFOWVision()
    return 1
end


--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_meepo_earthbind:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_meepo_earthbind:GetEffectName()
	return "particles/units/heroes/hero_meepo/meepo_earthbind.vpcf"
end

function custom_modifier_meepo_earthbind:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end