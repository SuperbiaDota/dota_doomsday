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
custom_modifier_rubick_telekinesis = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_rubick_telekinesis:IsHidden()
	return false
end

function custom_modifier_rubick_telekinesis:IsDebuff()
	return true
end

function custom_modifier_rubick_telekinesis:IsPurgable()
	return true
end

-- Optional Classifications
function custom_modifier_rubick_telekinesis:IsStunDebuff()
	return true
end

function custom_modifier_rubick_telekinesis:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_rubick_telekinesis:OnCreated( kv )
	-- references
	self.land_ratio = self:GetAbility():GetSpecialValueFor( "fall_duration" )
    self.interval = kv.duration * ( 1 - land_ratio )

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( self.interval )
end

function custom_modifier_rubick_telekinesis:OnRefresh( kv )
	
end

function custom_modifier_rubick_telekinesis:OnRemoved()
end

function custom_modifier_rubick_telekinesis:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_rubick_telekinesis:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function custom_modifier_rubick_telekinesis:OnIntervalThink()
    
end

--------------------------------------------------------------------------------
-- Motion Effects
function custom_modifier_rubick_telekinesis:UpdateHorizontalMotion( me, dt )
end

function custom_modifier_rubick_telekinesis:OnHorizontalMotionInterrupted()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_rubick_telekinesis:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_rubick_telekinesis:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_rubick_telekinesis:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_rubick_telekinesis:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_rubick_telekinesis:PlayEffects()
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