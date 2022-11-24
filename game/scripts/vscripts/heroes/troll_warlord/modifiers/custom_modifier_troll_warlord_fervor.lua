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
custom_modifier_troll_warlord_fervor = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_troll_warlord_fervor:IsHidden()
	return false
end

function custom_modifier_troll_warlord_fervor:IsDebuff()
	return false
end

function custom_modifier_troll_warlord_fervor:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_troll_warlord_fervor:OnCreated( kv )
end

function custom_modifier_troll_warlord_fervor:OnRefresh( kv )
	
end

function custom_modifier_troll_warlord_fervor:OnRemoved()
end

function custom_modifier_troll_warlord_fervor:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_troll_warlord_fervor:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED ,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT ,
	}

	return funcs
end

function custom_modifier_troll_warlord_fervor:OnAttackLanded( params )
	if not IsServer() then return end
	if self.target == params.target and
	self:GetStackCount() < self:GetAbility():GetSpecialValueFor( "max_stacks" ) then
		self:IncrementStackCount()
	else
		self.target = params.target
		self:SetStackCount(0)
	end
end

function custom_modifier_troll_warlord_fervor:GetModifierAttackSpeedBonus_Constant()
	local ability = self:GetAbility()
	local stack_atk_speed = ability:GetLevelSpecialValueFor("attack_speed", ability:GetLevel()-1)
	return self:GetStackCount() * stack_atk_speed
end