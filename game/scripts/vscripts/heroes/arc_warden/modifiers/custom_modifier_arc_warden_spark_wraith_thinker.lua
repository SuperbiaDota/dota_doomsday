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
modifier_custom_arc_warden_spark_wraith_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_custom_arc_warden_spark_wraith_thinker:IsHidden()
	return false
end

function modifier_custom_arc_warden_spark_wraith_thinker:IsDebuff()
	return false
end

function modifier_custom_arc_warden_spark_wraith_thinker:IsStunDebuff()
	return false
end

function modifier_custom_arc_warden_spark_wraith_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_custom_arc_warden_spark_wraith_thinker:OnCreated( kv )
	if not IsServer() then return end
	-- references

	local thinker = self:GetParent()
	local ability = self:GetAbility()

	self.delay = ability:GetSpecialValueFor("activation_delay")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")
	self.search_radius = ability:GetSpecialValueFor("search_radius")
	self.vision_radius = ability:GetSpecialValueFor("vision_radius")

	self.think_interval = self:GetAbility():GetSpecialValueFor("think_interval")
	
	thinker:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	local startup_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff_sphere3.vpcf", PATTACH_WORLDORIGIN, thinker)
	local thinker_pos = thinker:GetAbsOrigin()
	ParticleManager:SetParticleControl(startup_particle, 3, (thinker_pos + Vector(0, 0, 150)))

	-- start delay
	self:StartIntervalThink( self.delay )
	self.startup_particle = startup_particle

	-- pass info to thinker
	thinker:SetDayTimeVisionRange(self.vision_radius)
	thinker:SetNightTimeVisionRange(self.vision_radius)
	local thinker_ability = thinker:AddAbility("arc_warden_spark_wraith")
	--thinker:FindAbilityByName("arc_warden_spark_wraith"):SetLevel(ability:GetLevel())
	thinker_ability:SetLevel(ability:GetLevel())
	thinker.player_id = ability:GetCaster():GetPlayerOwnerID()

	-- play effects
	-- self:PlayEffects()
end

function arc_warden_spark_wraith_thinker:OnDestroy()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
	end
end

function arc_warden_spark_wraith_thinker:CheckState()
	if self.duration then
		return {[MODIFIER_STATE_PROVIDES_VISION] = true}
	end
	return nil
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_custom_arc_warden_spark_wraith_thinker:OnIntervalThink()

	local thinker = self:GetParent()
	local thinkerpos = thinker:GetAbsOrigin()
	if self.delay ~= nil then
		ParticleManager:DestroyParticle(self.startup_particle, false)
		self.delay = nil
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff_sphere.vpcf", PATTACH_WORLDORIGIN, thinker)
		ParticleManager:SetParticleControl(self.particle, 3, (thinker_pos + Vector(0, 0, 150)))

		-- start search interval
		self:StartIntervalThink( self.think_interval )
	end

	local caster = self:GetCaster()
	local projectile_name = "particles/units/heroes/hero_arc_warden/arc_warden_spell_spark_wraith.vpcf"

	-- find enemies
	local enemies = FindUnitsInRadius(
		thinker:GetTeamNumber(),	-- int, thinker team number
		thinker_pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.search_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	if enemies[1] == nil then return end

	self.target = enemies[1]
	self.duration = nil
	self.expire = nil
	self:StartIntervalThink(-1)

	-- send wraith projectile
	local info = {
		Target = self.target,
		Source = thinker,
		Ability = thinker:FindAbilityByName("arc_warden_spark_wraith"),
		
		EffectName = "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf",
		vSourceLoc = (thinker_pos + Vector(0, 0, 150)),
		bDrawsOnMinimap = false,
		iSourceAttachment = 1,
		iMoveSpeed = self.projectile_speed,
		bDodgeable = false,                           -- Optional
		bProvidesVision = true,
		iVisionRadius = self.vision_radius,
		iVisionTeamNumber = thinker:GetTeamNumber(),
		bVisibleToEnemies = true,
		flExpireTime = nil,
		bReplaceExisting = false
	}
	ProjectileManager:CreateTrackingProjectile(info)

	ParticleManager:DestroyParticle(self.particle, false)
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_custom_arc_warden_spark_wraith_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_bramble_wraith.vpcf"
	local sound_cast = "Hero_DarkWillow.Bramble.Spawn"
	local sound_loop = "Hero_DarkWillow.BrambleLoop"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_loop, self:GetParent() )
end