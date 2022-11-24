-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Break behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
custom_huskar_life_break = class({})

LinkLuaModifier( "custom_modifier_huskar_life_break_charge", 
	"heroes/huskar/modifiers/custom_modifier_huskar_life_break_charge", 
	LUA_MODIFIER_MOTION_HORIZONTAL 
)
LinkLuaModifier( "custom_modifier_huskar_life_break_slow", 
	"heroes/huskar/modifiers/custom_modifier_huskar_life_break_slow", 
	LUA_MODIFIER_MOTION_NONE 
)

local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Ability Cast Filter
function custom_huskar_life_break:CastFilterResultTarget( hTarget )
	if hTarget:GetUnitName() == "npc_dota_roshan" then
		return UF_FAIL_CUSTOM
	elseif self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- TODO(jason): is basic just creep + mechanical?
		DOTA_UNIT_TARGET_FLAG_NONE,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function custom_huskar_life_break:GetCustomCastErrorTarget( hTarget )
	if hTarget:GetUnitName() == "npc_dota_roshan" then
		return "#dota_hud_error_cant_cast_on_roshan"
	elseif hTarget == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_huskar_life_break:OnSpellStart()

	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- add modifiers
	local tgt = tempTable:AddATValue( target )
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"custom_modifier_huskar_life_break_charge", -- modifier name
		{
			target = tgt
		} -- kv
	)

	-- play effects
	local sound_cast = "Hero_Huskar.Life_Break"
	EmitSoundOn( sound_cast, caster )
end
