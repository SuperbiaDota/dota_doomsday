if not AttributeBonus then
	AttributeBonus = class({})
end

function AttributeBonus:OnNPCSpawned(event)
	local unit = EntIndexToHScript(event.entindex)
	if unit:IsHero() and event.is_respawn ~= 1 then
		unit:AddNewModifier(
			unit, -- player source
			-- TODO: dummy ability?
			unit:FindAbilityByName("custom_ability_craft"), -- ability source
			"custom_modifier_attribute_bonus", -- modifier name
			{} -- kv
		)
	end
end

function AttributeBonus:Init()
	LinkLuaModifier("custom_modifier_attribute_bonus", "scripts/vscripts/modifiers/custom_modifier_attribute_bonus", LUA_MODIFIER_MOTION_NONE)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(AttributeBonus, 'OnNPCSpawned'), self)
end