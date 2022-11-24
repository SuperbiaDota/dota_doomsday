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
custom_modifier_rubick_null_field = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_rubick_null_field:IsHidden()
	return true
end

function custom_modifier_rubick_null_field:IsDebuff()
	return false
end

function custom_modifier_rubick_null_field:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_rubick_null_field:OnCreated( kv )
	-- references
    self.radius = self:GetAbility():GetAOERadius()

end

function custom_modifier_rubick_null_field:OnRefresh( kv )
	self.radius = self:GetAbility():GetAOERadius()
end

function custom_modifier_rubick_null_field:OnRemoved()
end

function custom_modifier_rubick_null_field:OnDestroy()
end

--------------------------------------------------------------------------------
-- Aura Effects
function custom_modifier_rubick_null_field:IsAura()
    return true
end

function custom_modifier_rubick_null_field:GetModifierAura()
    return "custom_modifier_rubick_null_field_effect"
end

function custom_modifier_rubick_null_field:GetAuraRadius()
    return self.radius
end

function custom_modifier_rubick_null_field:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function custom_modifier_rubick_null_field:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function custom_modifier_rubick_null_field:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end