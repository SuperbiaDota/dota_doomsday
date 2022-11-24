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
modifier_generic_barrier_instance = class({})
local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_barrier_instance:IsHidden()
	return false
end

function modifier_generic_barrier_instance:IsPurgable()
	return true
end

function modifier_generic_barrier_instance:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_barrier_instance:OnCreated( kv )
	if IsServer() then
		-- get references
		self.modifier = tempTable:RetATValue( kv.modifier )
		self.block = kv.block
		self.damage_type = kv.damage_type
		self.ability_name = kv.ability_name
	end
end

function modifier_generic_barrier_instance:OnRemoved()
	if IsServer() then
		-- decrement stack
		if not self.modifier:IsNull() then
			self.modifier:DecrementStackCount()
			self.modifier.mod_table[self.damage_type][self.ability_name] = nil
		end
	end
end

function modifier_generic_barrier_instance:OnDestroy()
end