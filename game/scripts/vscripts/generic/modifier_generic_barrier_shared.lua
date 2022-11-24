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
modifier_generic_barrier_shared = class({})

LinkLuaModifier( "modifier_generic_barrier_instance",
	"generic/modifier_generic_barrier_instance",
	LUA_MODIFIER_MOTION_NONE
)
local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_barrier_shared:IsHidden()
	return true
end

function modifier_generic_barrier_shared:IsDebuff()
	return false
end

function modifier_generic_barrier_shared:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_barrier_shared:OnCreated( kv )

	if IsServer() then

		-- init table
		if not self.mod_table then
			self.mod_table = {}
			if not self.mod_table[kv.damage_type] then
				self.mod_table[kv.damage_type] = {}
			end
		end

		local ability = tempTable:RetATValue( kv.ability_index )

		local this = tempTable:AddATValue( self )
		local hmod = self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_generic_barrier_instance", -- modifier name
			{
				duration = kv.duration,
				modifier = this,
				block = kv.block,
				damage_type = kv.damage_type,
				ability_name = ability:GetName()
			} -- kv
		)

		-- add to table
		self.mod_table[kv.damage_type][ability:GetName()] = hmod

		-- increment stack
		self:IncrementStackCount()
	end
end

function modifier_generic_barrier_shared:OnRefresh( kv ) -- TODO: make sure short duration barriers dont overwrite long duration

	if IsServer() then

		-- init table
		if not self.mod_table then
			self.mod_table = {}
			if not self.mod_table[kv.damage_type] then
				self.mod_table[kv.damage_type] = {}
			end
		end

		self:SetDuration(math.max(self:GetRemainingTime(), kv.duration), true)

		local ability = tempTable:RetATValue( kv.ability_index )

		-- if barrier already exists then refresh it (assumes one barrier per ability)
		if self.mod_table[kv.damage_type] then 
			local old_mod = self.mod_table[kv.damage_type][ability:GetName()]
			if old_mod then
				old_mod:SetDuration(kv.duration, true)
				old_mod.block = kv.block
				return
			end
		end

		local this = tempTable:AddATValue( self )
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_generic_barrier_instance", -- modifier name
			{
				duration = kv.duration,
				modifier = this,
				block = kv.block,
				damage_type = kv.damage_type,
				ability_name = ability:GetName()
			} -- kv
		)
	
		-- add to table
		self.mod_table[kv.damage_type][ability:GetName()] = hmod

		-- increment stack
		self:IncrementStackCount()
	end
end

function modifier_generic_barrier_shared:OnRemoved()
end

function modifier_generic_barrier_shared:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_barrier_shared:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE 
	}

	return funcs
end

function modifier_generic_barrier_shared:GetModifierTurnRate_Override()
	return true
end

function modifier_generic_barrier_shared:GetModifierIncomingDamage_Percentage( params ) -- TODO: how does this stack with other damage modifiers?
-- TODO: dont trigger with hp removal
	local excess_dmg = params.original_damage
	local damage_type = params.damage_type

	if damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PHYSICAL or damage_type == DAMAGE_TYPE_PURE then

		if damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PHYSICAL then
			excess_dmg = self:BarrierTakeDamage( damage_type, excess_dmg )
		end
		excess_dmg = self:BarrierTakeDamage( DAMAGE_TYPE_ALL, excess_dmg )
	
		return (excess_dmg / params.original_damage * 100) - 100
	end
	return 0
end

function modifier_generic_barrier_shared:BarrierTakeDamage( damage_type, damage )

	if not self.mod_table[damage_type] then return damage end

	local excess = damage
	for _, hmod in pairs(self.mod_table[damage_type]) do -- TODO: oldest first
		if not hmod:IsNull() then
			if excess >= hmod.block then
				--print(excess .. " damage exceeds barrier value of " .. hmod.block)
				excess = excess - hmod.block
				hmod:Destroy()
				--print("barrier destroyed")
			else
				--print(excess .. " damage blocked by barrier value of " .. hmod.block)
				hmod.block = hmod.block - excess
				--print(hmod.block .. " barrier health remaining")
				return 0
			end
		end
	end
	return excess
end

function modifier_generic_barrier_shared:OnStackCountChanged( old_count )
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
end