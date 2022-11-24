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
custom_huskar_burning_spear = class({})

LinkLuaModifier( "custom_modifier_huskar_burning_spear_debuff", 
	"heroes/huskar/modifiers/custom_modifier_huskar_burning_spear_debuff", 
	LUA_MODIFIER_MOTION_NONE 
)
LinkLuaModifier( "custom_modifier_huskar_burning_spear_stack", 
	"heroes/huskar/modifiers/custom_modifier_huskar_burning_spear_stack", 
	LUA_MODIFIER_MOTION_NONE 
)
LinkLuaModifier( "modifier_generic_orb_effect_lua", 
	"generic/modifier_generic_orb_effect_lua", 
	LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Passive Modifier
function custom_huskar_burning_spear:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

--------------------------------------------------------------------------------
-- Orb Effects
function custom_huskar_burning_spear:GetProjectileName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end

function custom_huskar_burning_spear:OnOrbFire( params )
	-- health cost
	local damageTable = {
		victim = self:GetCaster(),
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetHealth() * self:GetSpecialValueFor("health_cost") / 100,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
	}
	ApplyDamage(damageTable)
end

function custom_huskar_burning_spear:OnOrbImpact( params )
	local duration = self:GetDuration()

	params.target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"custom_modifier_huskar_burning_spear_debuff", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	local sound_cast = "Hero_Huskar.Burning_Spear.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_huskar_burning_spear:OnSpellStart()
end