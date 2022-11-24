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
custom_arc_warden_spark_wraith = class({})
LinkLuaModifier( "modifier_custom_arc_warden_spark_wraith", "lua_abilities/custom_arc_warden_spark_wraith/modifier_custom_arc_warden_spark_wraith", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function custom_arc_warden_spark_wraith:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_custom_arc_warden_spark_wraith.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_custom_arc_warden_spark_wraith/custom_arc_warden_spark_wraith.vpcf", context )
end

--------------------------------------------------------------------------------
-- Custom KV
function custom_arc_warden_spark_wraith:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_AOE
end

-- AOE Radius
function custom_arc_warden_spark_wraith:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function custom_arc_warden_spark_wraith:GetCooldown( level )
	local base_cooldown = self.BaseClass.GetCooldown( self, level )
	if self:GetCaster():HasTalent("custom_arc_warden_special_bonus_unique_1") then
		return base_cooldown + self:FindTalentValue( "custom_arc_warden_special_bonus_unique_1" )
	else
		return base_cooldown
	end
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_arc_warden_spark_wraith:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- logic
	CreateModifierThinker(
		caster,
		self,
		"modifier_custom_arc_warrden_spark_wraith_thinker",
		{ duration = self:GetSpecialValueFor("duration") + self:GetSpecialValueFor("activation_delay") },
		point,
		caster:GetTeam(),
		false
	)
end

--------------------------------------------------------------------------------
-- Projectile

function custom_arc_warden_spark_wraith:OnProjectileHit( target, location )
	local thinker = self:GetCaster()
	local modifier = thinker:FindModifierByName("modifier_custom_arc_warden_spark_wraith_thinker")
	local caster = modifier:GetCaster()
	if caster == nil then
		caster = PlayerResource:GetSelectedHeroEntity(thinker.player_id)
	end

	ApplyDamage(
		{ victim = target,
		attacker = caster,
		damage = self:GetAbilityDamage(), 
		damage_type = self:GetAbilityDamageType(), 
		["ability"] = self}
	)

	local ms_slow = self:GetSpecialValueFor("move_speed_slow_pc")
	local slow_duration = self:GetLevelSpecialValueFor("slow_duration")

	AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_custom_arc_warden_spark_wraith_slow", -- modifier name
		{ 
			ms_slow = ms_slow
			duration = slow_duration 
		} -- kv
	)
	local damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_base_attack_sparkles.vpcf", PATTACH_ROOTBONE_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(damage_particle)
	AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), self:GetSpecialValueFor("vision_radius"), 3.34, true)
	modifier:Destroy()
end


--------------------------------------------------------------------------------
-- Effects
function custom_arc_warden_spark_wraith:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
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