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
custom_modifier_attribute_bonus = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_attribute_bonus:IsHidden()
	return true
end

function custom_modifier_attribute_bonus:IsDebuff()
	return false
end

function custom_modifier_attribute_bonus:IsPurgable()
	return false
end

function custom_modifier_attribute_bonus:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_attribute_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end

function custom_modifier_attribute_bonus:GetModifierConstantHealthRegen()
	local default_regen = 0.1
	local target_regen = 0.03
	return -(self:GetParent():GetStrength() * (default_regen - target_regen))
end

function custom_modifier_attribute_bonus:GetModifierPreAttack_BonusDamage()
	return self:GetParent():GetStrength() / 3
end
