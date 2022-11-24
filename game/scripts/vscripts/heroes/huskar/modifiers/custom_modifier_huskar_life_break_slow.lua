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
custom_modifier_huskar_life_break_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_huskar_life_break_slow:IsHidden()
	return false
end

function custom_modifier_huskar_life_break_slow:IsDebuff()
	return true
end

function custom_modifier_huskar_life_break_slow:IsStunDebuff()
	return false
end

function custom_modifier_huskar_life_break_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_huskar_life_break_slow:OnCreated( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow_pct" )
    self.lifesteal = self:GetAbility():GetSpecialValueFor( "target_lifesteal" )
end

function custom_modifier_huskar_life_break_slow:OnRefresh( kv )
	
end

function custom_modifier_huskar_life_break_slow:OnRemoved()
end

function custom_modifier_huskar_life_break_slow:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_huskar_life_break_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function custom_modifier_huskar_life_break_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_huskar_life_break_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end