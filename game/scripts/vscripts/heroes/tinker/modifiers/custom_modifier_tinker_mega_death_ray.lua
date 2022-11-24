
custom_modifier_tinker_mega_death_ray = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_tinker_mega_death_ray:IsHidden()
	return false
end

function custom_modifier_tinker_mega_death_ray:IsDebuff()
	return true
end

function custom_modifier_tinker_mega_death_ray:IsPurgable()
	return true
end

function custom_modifier_tinker_mega_death_ray:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE 
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_tinker_mega_death_ray:OnCreated( kv )
	if not IsServer() then return end

    self.interval = 0.2
    self.team_number = self:GetCaster():GetTeamNumber()

	-- ability properties
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.vision_radius = self:GetAbility():GetSpecialValueFor("vision_radius")
    self.vision_linger = self:GetAbility():GetSpecialValueFor("vision_linger")

    self.burn_damage = self:GetAbility():GetSpecialValueFor("burn_damage")
    self.burn_duration = self:GetAbility():GetSpecialValueFor("burn_duration")
    self.burn_interval = self:GetAbility():GetSpecialValueFor("burn_interval")

    self.damage_table = {
        attacker = self:GetCaster(),
        damage = self:GetAbility():GetSpecialValueFor("burst_damage"),
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility()
    }

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()
end

-- TODO: does this execute if dispelled
function custom_modifier_tinker_mega_death_ray:OnDestroy()
    if not IsServer() then return end

    AddFOWViewer(
        self.team_number,
        self:GetParent():GetAbsOrigin(),
        self.vision_radius,
        self.vision_linger,
        true
    )

    local enemies = FindUnitsInRadius(
        self.team_number,
        self:GetParent():GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        0,
        0,
        false
    )
    for _, enemy in pairs(enemies) do
        self.damage_table.victim = enemy
        ApplyDamage(self.damage_table)
    end

    local thinker = CreateModifierThinker(
        self:GetCaster(),
        self:GetAbility(),
        "custom_modifier_tinker_mega_death_ray_burn",
        {
            duration = self.burn_duration,
            radius = self.radius,
            burn_damage = self.burn_damage,
            interval = self.burn_interval
        },
        self:GetParent():GetAbsOrigin(),
        self.team_number,
        false
    )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_tinker_mega_death_ray:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
end

function custom_modifier_tinker_mega_death_ray:GetModifierProvidesFOWVision( )
    return 1
end

--------------------------------------------------------------------------------
-- Interval Effects
function custom_modifier_tinker_mega_death_ray:OnIntervalThink()
    AddFOWViewer(
        self.team_number,
        self:GetParent():GetAbsOrigin(),
        self.vision_radius,
        self.interval,
        true
    )
end

--[[
--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_tinker_mega_death_ray:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_tinker_mega_death_ray:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_tinker_mega_death_ray:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_tinker_mega_death_ray:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_tinker_mega_death_ray:PlayEffects()
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
--]]