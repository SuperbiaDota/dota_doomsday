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
custom_modifier_lifestealer_infest = class({})

--------------------------------------------------------------------------------
-- Classifications

function custom_modifier_lifestealer_infest:IsHidden()
	return false
end

function custom_modifier_lifestealer_infest:IsDebuff()
	return false
end

function custom_modifier_lifestealer_infest:IsPurgable()
	return false
end


--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_lifestealer_infest:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()
	self.regen_pct = ability:GetLevelSpecialValueFor("self_regen", ability:GetLevel()-1)
	--self:GetParent():AddNoDraw()
	self:StartIntervalThink(0.03)
end

function custom_modifier_lifestealer_infest:OnRefresh( kv )
	
end

function custom_modifier_lifestealer_infest:OnDestroy()
	if not IsServer() then return end
	local caster = self:GetParent()
	local infest_ability = self:GetAbility()

	-- kill infested unit if creep
	-- remove buff if hero
	if not self.infested_unit:IsHero() then
        self.infested_unit:Kill(infest_ability, caster)
        PlayerResource:NewSelection(caster:GetPlayerOwnerID(), caster)
	elseif self.infested_unit:IsAlive() then
		local hbuff = self.infested_unit:FindModifierByName("custom_modifier_lifestealer_infest_buff")
		if hbuff ~= nil then hbuff:Destroy() end
	end

	-- draw, reposition lifestealer
	caster:RemoveNoDraw()
    caster:SetOrigin(self.infested_unit:GetOrigin())
	
	-- restore abilities
	caster:SwapAbilities(
		"custom_lifestealer_infest",
		"custom_lifestealer_consume",
		true,
		false
	)

	-- NOTE: will cd and do damage based on current level of infest
	-- assume that the player can't level infest while infested

	-- restart cooldown
	infest_ability:StartCooldown(infest_ability:GetCooldown())

	-- deal AOE damage
	local radius = infest_ability:GetLevelSpecialValueFor("radius", infest_ability:GetLevel()-1)
	local damage = infest_ability:GetLevelSpecialValueFor("damage", infest_ability:GetLevel()-1)
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local damageTable = {
		victim = nil,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = infest_ability, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end
end

--------------------------------------------------------------------------------
-- Modifier Functions
function custom_modifier_lifestealer_infest:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		--MODIFIER_EVENT_ON_ORDER
	}
	return funcs
end

function custom_modifier_lifestealer_infest:GetModifierHealthRegenPercentage()
	return self.regen_pct
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_lifestealer_infest:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function custom_modifier_lifestealer_infest:OnIntervalThink()
	if not IsServer() then return end
	if self.infested_unit == nil then
		self:Destroy()
		return
	end
	self:GetParent():SetAbsOrigin(self.infested_unit:GetAbsOrigin())
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_lifestealer_infest:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_lifestealer_infest:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_lifestealer_infest:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_lifestealer_infest:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_lifestealer_infest:PlayEffects()
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
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

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
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end