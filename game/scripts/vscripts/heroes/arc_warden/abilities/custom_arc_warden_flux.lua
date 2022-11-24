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
custom_arc_warden_flux = class({})
LinkLuaModifier( "custom_modifier_arc_warden_flux", "heroes/arc_warden/modifers/custom_modifier_arc_warden_flux", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function template:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_template.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_template/template.vpcf", context )
end

function arc_warden_flux:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local debuff_duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, "custom_modifier_arc_warden_flux", { duration = debuff_duration}) 
	
end