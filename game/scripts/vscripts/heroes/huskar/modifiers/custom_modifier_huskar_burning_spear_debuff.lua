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
custom_modifier_huskar_burning_spear_debuff = class({})
local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_huskar_burning_spear_debuff:IsHidden()
	return false
end

function custom_modifier_huskar_burning_spear_debuff:IsDebuff()
	return true
end

function custom_modifier_huskar_burning_spear_debuff:IsStunDebuff()
	return false
end

function custom_modifier_huskar_burning_spear_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_huskar_burning_spear_debuff:OnCreated( kv )
	-- references
	self.dps = self:GetAbility():GetLevelSpecialValueFor( "burn_damage" , self:GetAbility():GetLevel()-1)

	if IsServer() then
		local duration = self:GetAbility():GetDuration()
		
		-- add stack modifier
		local this = tempTable:AddATValue( self )
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"custom_modifier_huskar_burning_spear_stack", -- modifier name
			{
				duration = duration,
				modifier = this,
			} -- kv
		)

		-- increment stack
		self:IncrementStackCount()

		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = 500,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- start interval
		self:StartIntervalThink( 1 )
	end
end

function custom_modifier_huskar_burning_spear_debuff:OnRefresh( kv )
	-- references
	self.dps = self:GetAbility():GetSpecialValueFor( "burn_damage" )

	if IsServer() then
		local duration = self:GetAbility():GetDuration()

		-- add stack
		local this = tempTable:AddATValue( self )
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"custom_modifier_huskar_burning_spear_stack", -- modifier name
			{
				duration = duration,
				modifier = this,
			} -- kv
		)
		
		-- increment stack
		self:IncrementStackCount()
	end
end

function custom_modifier_huskar_burning_spear_debuff:OnRemoved()
	-- stop effects
	local sound_cast = "Hero_Huskar.Burning_Spear"
	StopSoundOn( sound_cast, self:GetParent() )
end

function custom_modifier_huskar_burning_spear_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function custom_modifier_huskar_burning_spear_debuff:OnIntervalThink()
	-- apply dot damage
	self.damageTable.damage = self:GetStackCount() * self.dps
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_huskar_burning_spear_debuff:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function custom_modifier_huskar_burning_spear_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end