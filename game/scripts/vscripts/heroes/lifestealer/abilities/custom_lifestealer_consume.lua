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
custom_lifestealer_consume = class({})

--------------------------------------------------------------------------------
-- Init Abilities
--[[
function custom_lifestealer_consume:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_custom_lifestealer_consume.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_custom_lifestealer_consume/custom_lifestealer_consume.vpcf", context )
end
]]

--------------------------------------------------------------------------------
-- Ability Start
function custom_lifestealer_consume:OnSpellStart()
	-- load data
	local caster = self:GetCaster()

	-- make blood
	--self:PlayEffects()

	-- pop out lifestealer
	hmod = caster:FindModifierByName("custom_modifier_lifestealer_infest")
	hmod:Destroy()
end

--------------------------------------------------------------------------------
-- Effects
function custom_lifestealer_consume:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf"
	local sound_cast = "string"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		iControlPoint,
		hTarget,
		PATTACH_NAME,
		"attach_name",
		vOrigin, -- unknown
		bool -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end

